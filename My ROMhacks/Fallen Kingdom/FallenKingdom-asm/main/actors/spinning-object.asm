beh_spinning_object_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_EXEC @init
BHV_LOOP_BEGIN
	BHV_EXEC 0x802A2BC4
	BHV_EXEC process_collision
BHV_LOOP_END

@init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LW T0, g_current_obj_ptr
	LI T1, @collision_table
	
	LBU AT, o_arg0 (T0)
	SLL AT, AT, 2
	ADDU T1, T1, AT
	
	JAL segmented_to_virtual
	LW A0, 0x0 (T1)
	
	LW T0, g_current_obj_ptr
	SW V0, o_collision_pointer (T0)
	
	LBU AT, o_arg1 (T0)
	MTC1 AT, F4
	LI.S F5, 100
	
	LH AT, o_arg2 (T0)
	SW AT, o_angle_vel_yaw (T0)
	
	CVT.S.W F4, F4
	MUL.S F4, F4, F5
	S.S F4, o_collision_distance (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@collision_table:
.word bb_level_4_object_Wooden_Star_collision
.word bb_level_4_object_Bamboo_Spinner_collision
