beh_slide_goal_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_LIST_DEFAULT
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@loop:
	LW T0, g_current_obj_ptr
	LW AT, o_state (T0)
	BEQ AT, R0, @@endif_timer_stopped
		LBU T1, 0x8033B25E
		BEQ T1, R0, @@return
		NOP
		B @@return
		SW R0, o_state (T0)
	@@endif_timer_stopped:
	
	LI T1, g_mario
	L.S F4, m_x (T1)
	L.S F5, o_x (T0)
	C.LT.S F4, F5
	L.S F4, m_y (T1)
	BC1T @@return
	L.S F5, o_y (T0)
	C.LE.S F4, F5
	LUI AT, 0x8033
	BC1F @@return
	SETU A0, 2
	SB R0, 0xDA98 (AT)
	SETU AT, 1
	J 0x802495E0
	SW AT, o_state (T0)
	
	@@return:
	JR RA
	NOP
