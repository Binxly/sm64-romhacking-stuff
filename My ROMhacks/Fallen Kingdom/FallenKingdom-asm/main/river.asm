process_river_current:
	LHU T0, g_level_num
	SETU AT, 0x6
	BNE T0, AT, @@return

	LI T0, g_mario
	LW AT, m_action (T0)
	ANDI AT, AT, 0x2000
	BEQ AT, R0, @@return

	LI.S F5, -3000
	L.S F4, m_y (T0)
	C.LT.S F4, F5
	NOP
	BC1T @@return

	LI.S F4, -12400
	L.S F9, m_z (T0)
	C.LE.S F9, F4
	L.S F8, m_x (T0)
	BC1F @@curve
	LI.S F4, 10
		NOP
		SUB.S F9, F9, F4
		JR RA
		S.S F9, m_z (T0)
	@@curve:
	LI.S F4, 9300
	LI.S F5, -13400
	
	SUB.S F4, F4, F8
	SUB.S F5, F5, F9
	
	MUL.S F6, F4, F4
	MUL.S F7, F5, F5
	ADD.S F6, F6, F7
	LI.S F7, 10
	SQRT.S F6, F6
	DIV.S F6, F6, F7
	DIV.S F4, F4, F6
	DIV.S F5, F5, F6

	ADD.S F8, F8, F5
	SUB.S F9, F9, F4

	S.S F8, m_x (T0)
	S.S F9, m_z (T0)

	@@return:
	JR RA
	NOP

check_rapids_warp:
	LHU T0, g_level_num
	SETU AT, 0x6
	BNE T0, AT, @@return
	
	LBU T0, 0x8033B248
	BNE T0, R0, @@return
	
	LI T0, g_mario
	MTC1 R0, F5
	L.S F4, m_x (T0)
	C.LE.S F4, F5
	LI.S F5, -13500
	BC1T @@return
	L.S F4, m_z (T0)
	C.LE.S F4, F5
	NOP
	BC1F @@return
	NOP
	
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI A0, g_mario
	JAL 0x8024C894
	NOP
	
	SETU A0, 0x5
	SETU A1, 1
	SETU A2, 10
	JAL 0x8024A700
	MOVE A3, R0
	
	MOVE A0, R0
	JAL 0x802497B8
	MOVE A1, R0
	
	SH R0, 0x8033BACC
	
	LW RA, 0x14 (SP)
	ADDIU SP, SP, 0x18
	
	@@return:
	JR RA
	NOP
