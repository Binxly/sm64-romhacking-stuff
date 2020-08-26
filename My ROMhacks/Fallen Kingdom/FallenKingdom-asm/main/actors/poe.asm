beh_poe_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_ANGLE_TO_MARIO | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_INTERACTION INT_TEXT
BHV_SET_INT o_interaction_arg, IA_SIGN
BHV_SET_FLOAT o_render_distance, 10000
BHV_DROP_TO_FLOOR
BHV_SET_HITBOX 200, 200, 0
BHV_LOOP_BEGIN
	BHV_EXEC @set_visible
	BHV_EXEC @turn_and_set_text
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

@set_visible:
	LW T0, g_current_obj_ptr
	LBU AT, (global_vars + gv_items)
	ANDI AT, AT, ITEM_LENS
	BEQ AT, R0, @@endif_visible
	LHU AT, o_gfx_flags (T0)
		ANDI AT, AT, 0xFFEF
		SH AT, o_gfx_flags (T0)
		SW R0, o_intangibility_timer (T0)
		LUI AT, 0x42DC
		MTC1 AT, F12
		J 0x802A390C
		L.S F14, o_hitbox_height (T0)
	@@endif_visible:
		ORI AT, AT, 0x10
		SH AT, o_gfx_flags (T0)
		SETS AT, -1
		JR RA
		SW AT, o_intangibility_timer (T0)

@turn_and_set_text:
	LW T0, g_current_obj_ptr
	LW AT, o_angle_to_mario (T0)
	SW AT, o_face_angle_yaw (T0)
	SW AT, o_move_angle_yaw (T0)
	
	LBU AT, o_arg0 (T0)
	BEQ AT, R0, @@return
		LHU T1, (global_vars + gv_shrooms)
		ANDI AT, T1, SHROOM_BOTW
		BEQ AT, R0, @@endif_shroom_collected
			SETU AT, 22
			B @@return
			SW AT, o_param2 (T0)
		@@endif_shroom_collected:
		LHU T1, 0x8033B26C
		SLTIU AT, T1, 0x726
		ADDIU AT, AT, 18
		SW AT, o_param2 (T0)
	@@return:
	JR RA
	NOP
