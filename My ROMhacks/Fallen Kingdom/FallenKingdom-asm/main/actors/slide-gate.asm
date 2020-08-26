beh_slide_gate_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO | OBJ_ALWAYS_ACTIVE
BHV_SET_COLLISION bb_level_7_object_Gate_collision
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_collision_distance, 750
BHV_SET_INT o_intangibility_timer, 0
BHV_STORE_HOME
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@loop:
	LW T0, g_current_obj_ptr
	LW T1, o_state (T0)
	
	BNE T1, R0, @@endif_on_timer
		LHU T2, 0x8033B26C
		SLTIU AT, T2, 0x726
		BNE AT, R0, @@return
		SETU AT, 1
		B @@return
		SW AT, o_state (T0)
	@@endif_on_timer:
	
	SETU AT, 1
	BNE T1, AT, @@endif_closing
		LI.S F5, 25
		L.S F4, o_y (T0)
		SUB.S F4, F4, F5
		S.S F4, o_y (T0)
		LW AT, o_timer (T0)
		SLTIU AT, AT, 24
		BNE AT, R0, @@return
		SETU AT, 2
		SW AT, o_state (T0)
	@@endif_closing:
	
	LHU T1, 0x8033B26C
	SLTIU AT, T1, 0x726
	BEQ AT, R0, @@return
	LW AT, o_home_y (T0)
	SW AT, o_y (T0)
	SW R0, o_state (T0)
	
	@@return:
	J process_collision
	NOP
