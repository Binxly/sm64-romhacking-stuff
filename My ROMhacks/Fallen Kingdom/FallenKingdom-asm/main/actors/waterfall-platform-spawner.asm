beh_waterfall_platform_spawner_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_EXEC @set_timer_offset
BHV_LOOP_BEGIN
	BHV_EXEC @spawner_loop
BHV_LOOP_END

.definelabel @beh_waterfall_platform, (org() - 0x80000000)
BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 5250
BHV_SET_FLOAT o_collision_distance, 505
BHV_SET_FLOAT o_speed_z, -5
BHV_SET_INT o_face_angle_yaw, 0x8000
BHV_SET_COLLISION bb_level_22_object_Platform_collision
BHV_REPEAT_BEGIN 160
	BHV_ADD_FLOAT o_z, -5
	BHV_EXEC process_collision
BHV_REPEAT_END
BHV_REPEAT_BEGIN 498
	BHV_ADD_FLOAT o_z, -5
	BHV_ADD_FLOAT o_y, -5
	BHV_EXEC process_collision
BHV_REPEAT_END
BHV_OR_FLAGS o_flags, OBJ_AUTO_MOVE_Y
BHV_SET_FLOAT o_speed_y, -5
BHV_SET_INT o_speed_z, 0
BHV_REPEAT_BEGIN 17
	BHV_ADD_FLOAT o_speed_y, -4
	BHV_EXEC process_collision
BHV_REPEAT_END
BHV_SET_FLOAT o_speed_y, -70
BHV_REPEAT_BEGIN 4
	BHV_EXEC process_collision
BHV_REPEAT_END
BHV_SET_INT o_intangibility_timer, -1
BHV_REPEAT_BEGIN 31
BHV_REPEAT_END
BHV_DELETE
BHV_END

@set_timer_offset:
	LW T0, g_current_obj_ptr
	LBU AT, o_arg0 (T0)
	JR RA
	SW AT, o_timer (T0)

@spawner_loop:
	LW A0, g_current_obj_ptr
	LW AT, o_timer (A0)
	SLTIU AT, AT, 240
	BNE AT, R0, @@return
		SETU A1, 82
		LI A2, @beh_waterfall_platform
		J spawn_object
		SW R0, o_timer (A0)
	@@return:
	JR RA
	NOP
