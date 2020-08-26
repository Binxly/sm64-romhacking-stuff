mario_idle_shim:
	LHU T0, g_level_num
	SETU AT, 0x8
	BEQ T0, AT, @act_panting_hot
	NOP
	@@endif_hot_environment:
	J 0x80260CB4
	NOP
	
@act_panting_hot:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL 0x802608B0
	NOP
	
	BEQ V0, R0, @@endif_cancel
	NOP
		B @@return
		SETU V0, 1
	@@endif_cancel:
	
	
	LI A0, g_mario
	LW AT, m_action_arg (A0)
	ANDI AT, AT, 1
	BEQ AT, R0, @@endif_against_wall
	SETU A1, 0xBA
		SETU AT, 0x7E
	@@endif_against_wall:
	
	JAL set_mario_animation
	NOP
	
	LI A0, g_mario
	LW T0, 0x98 (A0)
	SETU AT, 0x2
	JAL 0x80255A34
	SB AT, 0x05 (T0)
	
	MOVE V0, R0
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
