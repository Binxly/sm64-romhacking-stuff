tutorial_level_loop:
LHU T0, g_level_num
SETU AT, 0x1A
BNE T0, AT, @return

LW T0, g_mario_obj_ptr
LW T0, o_timer (T0)
ANDI T1, T0, 0xF
BNE T1, R0, @endif_switch_light_texture
ANDI T0, T0, 0x3F
	SRL T0, T0, 0x2
	ANDI T0, T0, 0xC
	LI T1, @light_texture_table
	ADDU T0, T0, T1

	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	JAL segmented_to_virtual
	LW A0, 0x0 (T0)
	SW V0, 0x10 (SP)
	LI A0, light_texture
	JAL segmented_to_virtual
	NOP
	MOVE A0, V0
	LW A1, 0x10 (SP)
	JAL wordcopy
	SETU A2, 0x200
	LW RA, 0x14 (SP)
	ADDIU SP, SP, 0x18
@endif_switch_light_texture:
LI T0, g_mario
LH T1, m_health (T0)
SLTI AT, 0x800
BEQ AT, R0, @handle_checkpoints
ADDIU T1, T1, 0x10
SH T1, m_health (T0)
@handle_checkpoints:
J run_tutorial_void_check
NOP
@return:
JR RA
NOP

@light_texture_table:
.word light_texture_1
.word light_texture_2
.word light_texture_3
.word light_texture_4
