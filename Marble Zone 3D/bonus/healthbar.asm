/* show_healthbar( currentHealth, maxHealth ) */
show_healthbar:
ADDIU SP, SP, 0xFFE8
MTC1 A1, F4
SW RA, 0x14 (SP)
CVT.S.W F4, F4
S.S F4, @hb_max_hp
ORI T0, R0, 0x1
SB T0, @hb_visible
JAL update_healthbar
NOP
LHU T0, @hb_ex
SH T0, @hb_dx
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

/* hide_healthbar() */
hide_healthbar:
SB R0, @hb_visible
JR RA
NOP

/* update_healthbar( currentHealth ) */
update_healthbar:
MTC1 A0, F4
NOP
CVT.S.W F4, F4
L.S F5, @hb_max_hp
DIV.S F4, F4, F5
LUI AT, 0x431B
MTC1 AT, F5
NOP
MUL.S F4, F4, F5
CVT.W.S F4, F4
MFC1 T0, F4
NOP
ADDIU T0, T0, 0x52
ANDI T0, T0, 0x3FF
SH T0, @hb_ex
JR RA
NOP

/*
gDPFillRectangle format. First word is lower-right corner, second is upper-left; y co-ordinate is from the top down
1111 1100 xxxx xxxx xx00 yyyy yyyy yy00
0000 0000 xxxx xxxx xx00 yyyy yyyy yy00
*/

render_healthbar:

LBU T0, @hb_visible
BEQ T0, R0, @return

;LUI AT, 0x8034
;LW T0, 0xB06C (AT)
LI T0, @healthbar_display_list

; gDPPipeSync
LUI T1, 0xE700
SW T1, 0x0 (T0)
SW R0, 0x4 (T0)

; gDPSetRenderMode: 0x0F0A4000
LI T1, 0xB900031D
SW T1, 0x8 (T0)
LI T1, 0x0F0A4000
SW T1, 0xC (T0)

; gDPSetCycleType G_CYC_FILL
LI T1, 0xBA001402
SW T1, 0x10 (T0)
LUI T1, 0x30
SW T1, 0x14 (T0)

/* Render healthbar border */

; gDPSetFillColor - black
LUI T1, 0xF700
SW T1, 0x18 (T0)
LI T1, 0x00010001
SW T1, 0x1C (T0)

; gDPFillRectangle: (82, 17), (238, 27)
LI T1, 0xF63B806C
SW T1, 0x20 (T0)
LI T1, 0x00148044
SW T1, 0x24 (T0)

/* Render healthbar background */

; gDPSetFillColor - grey
LUI T1, 0xF700
SW T1, 0x28 (T0)
LI T1, 0x94A594A5
SW T1, 0x2C (T0)

; gDPFillRectangle: (83, 18), (237, 26)
LI T1, 0xF63B4068
SW T1, 0x30 (T0)
LI T1, 0x0014C048
SW T1, 0x34 (T0)

ADDIU T0, T0, 0x38

LHU T2, @hb_ex
LHU T3, @hb_dx

ADDIU T3, T3, 0xFFFF
SLTU AT, T3, T2
BEQ AT, R0, @dmg_anim
NOP
	SLL T3, T2, 0x0
@dmg_anim:
SH T3, @hb_dx

BEQ T2, T3, @draw_life
NOP

/* Render healthbar damage animation */

; gDPSetFillColor - faded red
LUI T1, 0xF700
SW T1, 0x0 (T0)
LI T1, 0xFAD7FAD7
SW T1, 0x4 (T0)

; gDPFillRectangle
LI T1, 0xF6000068
SLL AT, T3, 0xE
OR T1, T1, AT
SW T1, 0x8 (T0)
LI T1, 0x0014C048
SW T1, 0xC (T0)

ADDIU T0, T0, 0x10

/* Render healthbar life */

@draw_life:

SLTI AT, T3, 0x53
BNE AT, R0, @done_drawing
NOP

; gDPSetFillColor - red
LUI T1, 0xF700
SW T1, 0x0 (T0)
LI T1, 0xF801F801
SW T1, 0x4 (T0)

; gDPFillRectangle
LI T1, 0xF6000068
SLL AT, T2, 0xE
OR T1, T1, AT
SW T1, 0x8 (T0)
LI T1, 0x0014C048
SW T1, 0xC (T0)

ADDIU T0, T0, 0x10

@done_drawing:
LUI AT, 0xE900
SW AT, 0x0 (T0)
SW R0, 0x4 (T0)
LUI AT, 0xB800
SW AT, 0x8 (T0)
SW R0, 0xC (T0)
ADDIU T0, T0, 0x10

;LUI AT, 0x8034
;SW T0, 0xB06C (AT)

LI T1, (@healthbar_display_list-0x80000000)
LUI T2, 0x8034
LW T0, 0xB06C (T2)
LUI AT, 0x0600
SW AT, 0x0 (T0)
SW T1, 0x4 (T0)
ADDIU T0, T0, 0x8
SW T0, 0xB06C (T2)

@return:
JR RA
NOP

@hb_ex:
.halfword 0x0052
@hb_dx:
.halfword 0x0000
@hb_visible:
.byte 0x00
.align 4
@hb_max_hp:
.word 0x42C80000

@healthbar_display_list:
.fill 256
