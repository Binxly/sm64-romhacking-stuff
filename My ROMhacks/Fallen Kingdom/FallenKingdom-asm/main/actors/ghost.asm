beh_ghost_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_ANGLE_TO_MARIO | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_INTERACTION INT_TEXT
BHV_SET_INT o_interaction_arg, IA_SIGN
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_DROP_TO_FLOOR
BHV_SET_HITBOX 200, 200, 0
BHV_EXEC @spawn_condition
BHV_LOOP_BEGIN
	BHV_SET_INT o_intangibility_timer, 0
	BHV_EXEC @loop
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

@spawn_condition:
	LI T0, global_vars
	LBU AT, gv_items (T0)
	ANDI AT, AT, ITEM_LENS
	BEQ AT, R0, @@do_not_spawn
	LHU T0, gv_shrooms (T0)
	LW T1, g_current_obj_ptr
	LBU AT, o_arg2 (T1)
	BEQ AT, R0, @@return
	ADDIU T1, AT, 0xFFFF
	SETU AT, 1
	SLLV AT, AT, T1
	AND AT, T0, AT
	BNE AT, R0, @@do_not_spawn
	NOP
	@@return:
	JR RA
	NOP
	@@do_not_spawn:
	LW T0, g_current_obj_ptr
	JR RA
	SH R0, o_active_flags (T0)

@loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)

	LW S0, g_current_obj_ptr

	LUI AT, 0x42DC
	MTC1 AT, F12
	JAL 0x802A390C
	L.S F14, o_hitbox_height (S0)

	LBU AT, o_arg0 (S0)
	BEQ AT, R0, @@endif_grow_with_distance
		L.S F4, o_distance_to_mario (S0)
		LI.S F5, 1000
		LI.S F6, 16000
		MAX.S F4, F4, F5
		MIN.S F4, F4, F6
		LI.S F6, 5000
		SUB.S F4, F4, F5
		LI.S F5, 1
		DIV.S F4, F4, F6
		ADD.S F4, F4, F5
		MFC1 A1, F4
		JAL scale_object
		MOVE A0, S0
	@@endif_grow_with_distance:

	LW A0, o_face_angle_yaw (S0)
	LW A1, o_angle_to_mario (S0)
	JAL turn_angle
	SETU A2, 0x880
	SW V0, o_face_angle_yaw (S0)
	SW V0, o_move_angle_yaw (S0)

	@@return:
	LW S0, 0x10 (SP)
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
