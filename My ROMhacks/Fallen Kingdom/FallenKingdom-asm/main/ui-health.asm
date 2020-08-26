render_health:
LHU T0, g_level_num
SETU AT, 0x1A
BEQ T0, AT, @@cancel
SETU AT, 0x1B
BEQ T0, AT, @@cancel
SETU AT, 0x14
BEQ T0, AT, @@cancel
SETU AT, 0x1F
BEQ T0, AT, @@cancel
LW T0, g_mario_obj_ptr
BNE T0, R0, @@mario_exists
NOP
@@cancel:
JR RA
NOP

@@mario_exists:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

JAL start_icon_rendering
NOP

JAL render_key
NOP

JAL disable_texture_interpolation
NOP

SETU A0, 16
SETU A1, 48
LHU T0, (global_vars + gv_max_health)
LHU T1, (g_mario + m_health)
SLL T1, T1, 16
OR A2, T0, T1
JAL render_hearts
SETU A3, 12

LI T0, global_vars
LBU AT, gv_items (T0)
ANDI AT, AT, ITEM_BOMBS
BEQ AT, R0, @@endif_draw_bomb_icon
	LI A0, icon_bombs
	SETU A1, 16
	SETU A2, 96
	JAL render_icon
	SETU A3, ICON_SIZE_16x16 | ICON_SCALE_x4
@@endif_draw_bomb_icon:
	
JAL end_icon_rendering
NOP

JAL enable_texture_interpolation
NOP

LI T0, global_vars
LBU AT, gv_items (T0)
ANDI AT, AT, ITEM_BOMBS
BEQ AT, R0, @@endif_draw_bomb_count
	LUI A0, 0xFFFF
	JAL begin_print_encoded_text
	ORI A0, A0, 0xFFFF
	
	LBU T0, (global_vars + gv_bombs)
	ORI AT, T0, 0xFB00
	SH AT, 0x10 (SP)
	SETU AT, 0xFF00
	SH AT, 0x12 (SP)
	
	SETU A0, 20
	SETU A1, 200
	JAL print_encoded_text
	ADDIU A2, SP, 0x10
	
	JAL end_print_encoded_text
	NOP
@@endif_draw_bomb_count:

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18


render_hearts:
; a0 = x
; a1 = y
; a2 = (upper 16 bits) current hp
; a2 = (lower 16 bits) max hp
; a3 = hearts per row
ADDIU SP, SP, 0xFFD8
SW RA, 0x24 (SP)
SW S0, 0x20 (SP)
SW S1, 0x1C (SP)
SW S2, 0x18 (SP)
SW S3, 0x14 (SP)

SW A0, 0x28 (SP)
SW A1, 0x2C (SP)
SW A2, 0x30 (SP)
SW A3, 0x34 (SP)

SRL AT, A2, 8
ANDI S0, AT, 0xFF

SRL AT, A2, 24
ANDI S1, AT, 0xFF

MOVE S2, A0
MOVE S3, A1

SETU AT, 36
MULTU A3, AT
NOP
MFLO AT
NOP
ADDU AT, A0, AT
SW AT, 0x10 (SP)

@@loop:
	SETU AT, 1
	BEQ S0, AT, @@half_heart
	NOP
		ADDIU S0, S0, -2
		BEQ S1, AT, @@fh_half
		ADDIU S1, S1, -1
		BGTZ S1, @@fh_full
		ADDIU S1, S1, -1
			LI.U A0, icon_heart_empty
			B @@draw_heart
			LI.L A0, icon_heart_empty
		@@fh_full:
			LI.U A0, icon_heart_full
			B @@draw_heart
			LI.L A0, icon_heart_full
		@@fh_half:
			LI.U A0, icon_heart_half
			B @@draw_heart
			LI.L A0, icon_heart_half
	@@half_heart:
		BGTZ S1, @@hh_full
		ADDIU S0, S0, -1
			LI.U A0, icon_half_heart_empty
			B @@draw_heart
			LI.L A0, icon_half_heart_empty
		@@hh_full:
			LI A0, icon_half_heart_full
	@@draw_heart:
	MOVE A1, S2
	MOVE A2, S3
	JAL render_icon
	SETU A3, ICON_SIZE_8x8 | ICON_SCALE_x4
	
	ADDIU S2, S2, 36
	LW AT, 0x10 (SP)
	SLTU AT, S2, AT
	BNE AT, R0, @@endif_next_line
	NOP
		LW S2, 0x28 (SP)
		ADDIU S3, S3, 32
	@@endif_next_line:
	
	BGTZ S0, @@loop
	NOP

LW RA, 0x24 (SP)
LW S0, 0x20 (SP)
LW S1, 0x1C (SP)
LW S2, 0x18 (SP)
LW S3, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x28

