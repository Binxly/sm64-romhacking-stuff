@inertia:
.word 0 :: @x equ 0x0
.word 0 :: @z equ 0x4

handle_inertia:
	; only active in Secret of the Bamboo Forest
	LHU T0, g_level_num
	SETU AT, 0x4
	BNE T0, AT, @@return

	LI T0, g_mario
	L.S F4, m_y (T0)
	L.S F5, m_floor_height (T0)
	SUB.S F4, F4, F5
	LI.S F5, 5
	ABS.S F4, F4
	C.LT.S F4, F5
	LW T2, m_floor_ptr (T0)
	BC1F @@endif_grounded
	NOP
		BEQ T2, R0, @@return
		LI T1, @inertia
		LW T2, t_object (T2)
		BNE T2, R0, @@endif_level_geo
			SW R0, @x (T1)
			B @@return
			SW R0, @z (T1)
		@@endif_level_geo:
		LW AT, o_speed_x (T2)
		SW AT, @x (T1)
		LW AT, o_speed_z (T2)
		B @@return
		SW AT, @z (T1)
	@@endif_grounded:
	
	LI T0, g_mario
	LI T1, @inertia
	
	LI.S F8, 0.98
	
	L.S F4, m_x (T0)
	L.S F5, m_z (T0)
	
	L.S F6, @x (T1)
	L.S F7, @z (T1)
	
	ADD.S F4, F4, F6
	ADD.S F5, F5, F7
	
	MUL.S F6, F6, F8
	MUL.S F7, F7, F8
	
	S.S F4, m_x (T0)
	S.S F5, m_z (T0)
	
	S.S F6, @x (T1)
	S.S F7, @z (T1)
	
	@@return:
	JR RA
	NOP
	
