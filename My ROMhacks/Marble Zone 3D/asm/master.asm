.relativeinclude on
.open "../Marble Zone 3D.z64",0x80245000
.erroronwarning on
.n64

.include "../labels-v1.asm"

; notes about the spaces to put code in
; there is space in rom from 0x7cc6c0 to 0x800000
; there is space in ram from 0x80367500 to 0x80378700 (can fit in 17536 lines)

.definelabel code_rom, 0x7cc6c0; where your code goes in the rom
.definelabel code_ram, 0x80367500; where your code goes in the ram

.orga 0x396c; here it copies code into the ram at start up
li a0, code_ram
li a1, code_rom
li.u a2, code_end_copy
jal 0x80278504
li.l a2, code_end_copy
jal execonce
nop

.orga 0xfd354
jal execeveryframe
nop

.orga 0xde270; responsible for running every VI frames
b 0x803232a4
sw t4, 0x7110(at)
.skip 28
lw ra, 0x1c(sp)
lw s0, 0x18(sp)
jr ra
addiu sp, sp, 0x38
lb s7, code_ram
nop
beqz s7, @@skip_vi_frames
nop
add s5, r0, ra
jal execviframes
nop
@@skip_vi_frames:
b 0x80323278
lui at, 0x8036

.headersize (code_ram - code_rom)

.orga code_rom
execonce:
addiu sp, sp, 0xffec; don't get rid of those extra things. they are needed
sw a0, 0x4(sp)
sw a1, 0x8(sp)
sw ra, 0xc(sp)

; executes once here at start up

lw a0, 0x4(sp); don't get rid of those extra things. they are needed
lw a1, 0x8(sp)
or a0, r0, r0
jal 0x80277ee0
lui a1, 0x8000
lui a0, 0x8034
lui a1, 0x8034
addiu a1, a1, 0xb044
addiu a0, a0, 0xb028
jal 0x803225a0
addiu a2, r0, 0x1
lw ra, 0xc(sp)
jr ra
addiu sp, sp, 0x14

execeveryframe:
addiu sp, sp, 0xffe8; don't get rid of those extra things. they are needed
sw ra, 0x14(sp)

; your code that runs every frame here

addiu t6, r0, 0x1; don't get rid of those extra things. they are needed
lui at, 0x8039
lw ra, 0x14(sp)
jr ra
addiu sp, sp, 0x18

execviframes:
addiu sp, sp, 0xffe8
sw ra, 0x18(sp)
sw s5, 0x14(sp)

; your code that runs every vi frame here

lw ra, 0x18(sp)
addiu sp, sp, 0x18
jr ra
lw ra, 0x14(sp)

@on_every_mario_active_frame:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

; code that runs every iteration of Mario's behaviour loop
JAL animate_lava
NOP
JAL animate_rainbow_rings
NOP

; fix camera on Game Ogre level
LHU T0, g_level_num
ORI AT, R0, 0x1A
BNE T0, AT, @endif_game_ogre
NOP
	JAL get_or_set_camera_mode
	ORI A0, R0, 0x2
	SH R0, 0x8033C684
	ORI T0, R0, 0x4000
	SH T0, 0x8033C778
@endif_game_ogre:

; Infinite lives
LI T0, g_mario
ORI AT, R0, 0x1
SH AT, m_lives (T0)

; Hide healthbar when not on bonus level
LHU T0, g_level_num
ORI AT, R0, 0x18
BEQ T0, AT, @endif_not_in_bonus_level
NOP
	JAL hide_healthbar
	NOP
@endif_not_in_bonus_level:

; Lower background music volume to 30%
LI T0, 0x3E99999A
SW T0, 0x80222630

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

; misc code

.include "../helper-functions-v1.asm"

.include "./health-shim.asm"
.include "./lost-ring.asm"
.include "./item-box-code.asm"
.include "./explosion.asm"
.include "./blue-shield.asm"
.include "./revealed-secret.asm"
.include "./chain.asm"
.include "./spikes-code.asm"
.include "./press-code.asm"
.include "./item-box-icon.asm"
.include "./chain-and-weight-code.asm"
.include "./loose-block-code.asm"
.include "./rainbow-ring-code.asm"
.include "./caterkiller-code.asm"
.include "./fireball-spawner-code.asm"
.include "./fireball.asm"
.include "./batbrain-code.asm"
.include "./floating-box-code.asm"
.include "./lava-spout-code.asm"
.include "./sign-code.asm"
.include "./lava-chase-code.asm"
.include "./bonus-ring-code.asm"

.include "../lava/animate-texture.asm"
.include "./rainbow-rings.asm"
.include "./hud-shims.asm"
.include "./pausa.asm"

.include "../bonus/healthbar.asm"
.include "../bonus/festive-whomp-asm.asm"
.include "../bonus/whomp-shadow.asm"
.include "../bonus/whomp-minion.asm"
.include "../bonus/meteor.asm"

.include "../bonus/shadow-geo.asm"

code_end:
.definelabel code_end_copy, (code_end - (code_ram - code_rom))

; connect shims
.orga 0xFA18
JAL mario_health_loop_shim

.orga 0x84580
JAL mario_ineractions_shim
NOP

.orga 0xAE21C
NOP

.orga 0xAE234
JAL spawn_revealed_secret

.orga 0x97B50
JAL render_star_hint_viewer

.orga 0x8625C
J @on_every_mario_active_frame

.include "./hud.asm"

.include "./item-box-script.asm"	; overwrites 0x13001744 (Beta Boo key (inside of Boo))
.include "./spikes-script.asm"		; overwrites 0x13000278 (Beta chest)
.include "./press-script.asm"		; overwrites 0x13001778 (Beta Boo key (outside of Boo))
.include "./chain-and-weight-script.asm"	; overwrites 0x13003420 (beta green shell)
.include "./loose-block-script.asm"	; overwrites 0x13001608 (Beta trampoline)
.include "./caterkiller-script.asm" ; overwrites behaviour 0x130029E4 (Static checkered platform (unused?))
.include "./fireball-spawner-script.asm"	; overwrites 0x1300029C (Beta chest upper part - subobject)
.include "./batbrain-script.asm"	; overwrites 0x13004400 (floating Jolly Roger box (unused))
.include "./floating-box-script.asm"; overwrites 0x13004F40 (Unagi the eel (swimming))
.include "./lava-spout-script.asm"	; overwrites 0x130050F4 (Book switch (Big Boo's Haunt))
.include "./sign-script.asm"		; overwrites 0x130050D4 (BookShelf Thing?)
.include "./lava-chase-script.asm"	; overwrites 0x13004F90 (Dorrie)
.include "./bonus-ring-script.asm"	; overwrites 0x130050B4 (spawns bookends)
.include "../bonus/festive-whomp-scripts.asm"; overwrites 0x1300506C (Flying Bookend)

.orga 0x21DCCC
.word beh_rainbow_ring_init
.orga 0x21DCD8
.word beh_rainbow_ring_loop

.orga 0x669A8
NOP ; don't despawn coins when they hit lava (0C 0A 81 5A)

.orga 0x8C48
; make stars not take you out of the level (except the bonus boss star)
LHU T8, g_level_num
SLTIU T0, T8, 0xA

; disable interpolation (Doesn't work on Glide64Mk2)
.orga 0x2030
.word 0x00006025 ; original: 0x240C2000

.include "../objects/bank_0E_import.asm"

.close
