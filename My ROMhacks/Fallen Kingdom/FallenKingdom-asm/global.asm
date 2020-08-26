/*
This file is for shims and code that overwrites vanilla game code. You are free
to use .org, .orga, and .headersize here.
*/

; hide default power meter
.orga 0x9EE10
NOP

; disable pausing before the warp star is acquired
.orga 0x657C
JAL pressed_pause_shim

; replace pause screen
.orga 0x98D20
JAL pause_loop

; double jump shim
.orga 0x2AAFC
J check_double_jump

; replace 1-up geo layout to use the 3d model
.orga 0x219C24
.word 0x02000000, shroom_geo

; replace the blue coin geo layout (unused in this hack) with the double jump ring
.orga 0x219004
.word 0x02000000, double_jump_ring_geo

; camera code
	.orga 0x49F44
	B 0x8028F5FC

	.orga 0x41F30
	JAL update_camera
	
	.orga 0x3E39C
	JAL chase_cam_shim
	
	.orga 0x3E548
	JAL chase_distance_shim
	
	.orga 0x3FD18
	JAL camera_zoom_shim
	
	.orga 0x3FA78
	JAL camera_height_shim
	
	.orga 0x2F92C
	.word 0x0C094CF9
	
	.orga 0x276A4
	.word 0x1000001B
	
	.orga 0xEA756
	.halfword 0x2A80
	
	.orga 0xE9018
	.byte 0xA6
	
	.orga 0x3F7B4
	LUI AT, 0x4348
	MTC1 AT, F10
	SW AT, 0x68 (SP)
	
; save file stubs and shims
	.orga 0x34C44 ; save_file_collect_star_or_key
	JR RA
	NOP

	.orga 0x34E44 ; save_file_exists
	J save_file_exists
	ADDIU A0, A0, 1

	.orga 0x34E80 ; save_file_get_max_coin_score
	JR RA
	MOVE V0, R0

	.orga 0x34F80 ; save_file_get_course_star_count
	JR RA
	MOVE V0, R0

	.orga 0x35010 ; save_file_get_total_star_count
	JR RA
	MOVE V0, R0

	.orga 0x350A8 ; save_file_set_flags
	LUI T0, 0x8034
	SETU AT, 1
	JR RA
	SB AT, 0xB4A6 (T0)

	.orga 0x350F4 ; save_file_clear_flags
	LUI T0, 0x8034
	SETU AT, 1
	JR RA
	SB AT, 0xB4A6 (T0)

	.orga 0x35194 ; save_file_get_flags
	LHU.U A0, g_save_file_num
	J save_file_exists
	LHU.L A0, g_save_file_num

	.orga 0x351C8 ; save_file_get_star_flags
	JR RA
	MOVE V0, R0

	.orga 0x3523C ; save_file_set_star_flags
	JR RA
	NOP

	.orga 0x35310 ; save_file_get_course_coin_score
	JR RA
	MOVE V0, R0

	.orga 0x35340 ; save_file_is_cannon_unlocked
	JR RA
	MOVE V0, R0

	.orga 0x35390 ; save_file_set_cannon_unlocked
	JR RA
	NOP

	.orga 0x35418 ; save_file_set_cap_pos
	JR RA
	NOP

	.orga 0x354AC ; save_file_get_cap_pos
	JR RA
	MOVE V0, R0

	.orga 0x355D4 ; save_file_move_cap_to_default_location
	JR RA
	NOP
	
; Koopa tweaks

	; doesn't drop coins
	.orga 0xB61C4
	NOP
	
	; render distance
	.orga 0xB6D40
	LUI AT, 0x4680
	SW AT, 0x19C (T8)
	
	; shell max speed
	.orga 0x1FED6
	.halfword 0x4040
	
	.orga 0x1FF8E
	.halfword 0x42AE
	
	.orga 0x1FEC2
	.halfword 0x42C0
	
	.orga 0x1FFF6
	.halfword 0x42C0
	
	.orga 0x20012
	.halfword 0x42C0
	
	; no shell ride music
	.orga 0x4310
	JR RA
	NOP
	
	.orga 0x434C
	JR RA
	NOP
	

; Replace flower textures
.orga 0xDA278D
.incbin "./img/dead-flowers.bin"

; Bob-ombs

	; Don't drop coins
	.orga 0xA1B94
	NOP

	; No C-Up while crouching
	.orga 0xEDD4
	LUI T0, 0x400
	ORI AT, T0, 0x8000
	LW T7, 0xC (T6)
	AND T9, T7, AT
	.word 0x17280005

	; bomb pull (crouched)
	.orga 0x1CE80
	LW T9, m_controller (T8)
	LHU T9, c_buttons_pressed (T9)
	ANDI T0, T9, C_BUTTON_C_UP | C_TRIGGER_L
	BEQ T0, R0, @@next_case
	LUI A0, 0x0800
	JAL try_pull_bomb
	ORI A0, A0, 0x0207
	J 0x80261F60
	NOP
	@@next_case:
	NOP
	
	.orga 0x1BC6E
	.halfword 0x8000
	
	; bomb pull (crouch sliding)
	.orga 0x232C0
	LW T6, m_controller (T5)
	LHU T6, c_buttons_pressed (T6)
	ANDI T7, T6, C_BUTTON_C_UP | C_TRIGGER_L
	BEQ T7, R0, @@continue
	NOP
	JAL try_pull_bomb
	SETU A0, 0x0442
	J 0x80268328
	NOP
	@@continue:
	NOP
	
	; bomb stow (idle)
	.orga 0x1BC84
	JAL try_stow_bomb
	
	; bomb stow (moving)
	.orga 0x21884
	JAL try_stow_bomb
	
	; prevent bob-ombs from being picked up while they are exploding
	/*
	.orga 0xA1F6C
	JAL bobomb_explode_shim
	
	.orga 0xA2080
	JAL bobomb_explode_shim
	
	.orga 0xA1BF0
	J bobomb_interaction_shim
	NOP
	*/
	
	.orga 0xA24AC
	JAL bobomb_held_shim

	; prevent bob-ombs pulled out of a bomb bag from respawning
	.orga 0xA1BA8
	JAL bobomb_respawn_shim
	
	.orga 0xA1F9C
	JAL bobomb_respawn_shim
	
	.orga 0xA1FC4
	JAL bobomb_respawn_shim
	
	.orga 0xA20B0
	JAL bobomb_respawn_shim
	
	.orga 0xA20D8
	JAL bobomb_respawn_shim
	
	; throw bombs further
	.orga 0xA22CE
	.halfword 0x420C
	
	; makes bobombs stop in pace and explode quickly when they hit an enemy
	.orga 0xA1CD0
	J bobomb_hit_enemy_shim
	NOP
	
	; make Bob-ombs blue
	.orga 0xA9F27C
	.incbin "./img/bobomb.bin"
	
; Skeeter Tweaks
	; don't drop coins
	.orga 0xEDD3F
	.byte 0
	
	; fast lunge attack
	.orga 0xCE00E
	.halfword 0x4220
	
	; fix Mario targeting... kind of
	.orga 0xCDE05
	.byte 0x1
	
	.orga 0xF3D5C
	.word float( 1000 )
	
	; attack from farther away
	.orga 0xCDFE2
	.halfword 0x44FA
	
	; accelerate faster
	.orga 0xF3D60
	.word float( 2 )
	
	; turn faster
	.orga 0xCDF4E
	.halfword 0xC00
	
	.orga 0xCE0EA
	.halfword 0xC00
	
	.orga 0xCDC48
	SETU T0, 80
	SETU T1, 800
	SETU T2, 3200

; coin interaction changed to use the water ring interaction
.orga 0xE8954
.word 0x8024DBF0

; collected "star" is a golden/life shroom
.orga 0x131FA
.halfword 0xD4

.orga 0x21D674
.word shroom_trophy_init

.orga 0x8D38
JAL collect_shroom_shim

; collecting a golden/life shroom always uses message 3/4
	.orga 0x132F0
	JAL shroom_dialog_shim

	.orga 0xA806A
	.halfword 0x350
	
	.orga 0xA80BE
	.halfword 0x350

; saving after collecting a golden shroom uses my code
.orga 0x13354
JAL save_game

; Fix music being lost after collecting a golden shroom
.orga 0x13398
JAL shroom_dance_done_shim

; Force static camera on Game Ogre screen
.orga 0x42D8C
JAL apply_camera_shim

; Water Level Diamond tweaks

	; offset water level position from model centre
	.orga 0x7DAA0
	LUI T2, 0x8036
	ADDIU T1, T1, 0xFF6A
	SW T1, 0xF8 (T9)
	
	; alter hitbox
	.orga 0x21C400
	BHV_SET_HITBOX 64, 128, 64
	BHV_SET_FLOAT o_collision_distance, 200
	
	.orga 0x7DA50
	SW R0, o_intangibility_timer (T7)
	
; Make Bubba eatbox do damage instead of being an instant kill
	.orga 0xCF5EC
	SETU AT, 1
	SW AT, o_collision_damage (T6)
	NOP
	
	.orga 0xCF690
	SETU AT, 4
	SW AT, o_collision_damage (T4)
	NOP

; Text replacements

	; empty star -> bold L
	.orga 0x809D96
	.incbin "./img/L.bin"
	
	; middle dot -> forward slash
	.orga 0x809C56
	.incbin "./img/forward-slash.bin"
	
	.orga 0xEC46C; TODO EC370 ()
	.byte 5

; Inject Images
.include "./main/icons.asm"

; Steeper Slide Camera pitch
.orga 0x3E592
.halfword 0x2000

; Restart slide timer when over start line
.orga 0xB73C
NOP

; Timer tweaks

	; Don't show fractional seconds or "TIMER" text
	.orga 0x9EA6C
	NOP
	
	.orga 0x9EAC8
	NOP
	
	.orga 0x9EA24
	NOP
	
	; Change number font
	.orga 0x803156
	.incbin "./img/numbers.bin"
	
	.orga 0x806F56
	.incbin "./img/colon.bin"
	
	.orga 0x9EAB2
	.halfword 40

; Don't fadeout the music when getting lost in the bamboo forest
	.orga 0x5EAC
	JAL warp_music_fade_shim

; Fix ceiling collision jank in the Secret of the Bamboo Forest
	.orga 0xFDF9C
	.word 0x45010009
	NOP
	J ceiling_collision_shim
	
	.orga 0xCB2C
	JAL mario_find_ceiling_shim

; Use the panting animation when idle in Tal Tal Mines
	.orga 0x1EB38
	JAL mario_idle_shim
	
; Bullys don't drop coins
	.orga 0xA6910
	NOP
	
; Bullys are in the INTERACTIVE object list instead of GENERIC
	.orga 0x21D42D
	.byte 0x5

; Give brief invulnerability after being on fire
	.orga 0x229D0
	JAL mario_fire_invinvibility_shim

; Remove 12k bounds restriction for automatic movement
	.orga 0x5D5BC
	NOP :: NOP :: NOP

; Goombas don't drop coins
	.orga 0xED8C7
	.byte 0

; Water Mist visibility everywhere
	.orga 0x21ABE0
	BHV_JUMP water_mist_shim

; Patch cloning via instant warps
	.orga 0x5508
	JAL instant_warp_shim

; Stub out the original Bowser behaviour
	.orga 0x21B650
	BHV_START OBJ_LIST_GENERIC
	BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
	BHV_EXEC 0x802B7878
	BHV_END
	
	.orga 0x42590
	JAL bowser_cutscene_shim
	
; Slightly alter the effect of Bowser's shockwave attack
	.orga 0x1D9B4
	JAL mario_hit_by_shockwave

	.orga 0x6A9A0
	J shockwave_shim

; Cannot let go of Bowser unless spinning at max speed
	.orga 0x30BA8
	J 0x80275BC8
	
	.orga 0x30C04
	NOP
	
; Fix bug with solid interaction
	.orga 0x97A0
	NOP
