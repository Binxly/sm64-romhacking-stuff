beh_metal_lava_platform_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_COLLISION bb_level_8_object_Metal_Platform_collision
BHV_SET_FLOAT o_render_distance, 15000
BHV_SET_FLOAT o_collision_distance, 2048
BHV_SET_INT o_intangibility_timer, 0
BHV_SLEEP_VAR o_arg0
BHV_LOOP_BEGIN
	BHV_REPEAT_BEGIN 90
		BHV_ADD_FLOAT o_y, -5
		BHV_EXEC process_collision
	BHV_REPEAT_END
	BHV_REPEAT_BEGIN 45
		BHV_EXEC process_collision
	BHV_REPEAT_END
	BHV_REPEAT_BEGIN 90
		BHV_ADD_FLOAT o_y, 5
		BHV_EXEC process_collision
	BHV_REPEAT_END
	BHV_REPEAT_BEGIN 44
		BHV_EXEC process_collision
	BHV_REPEAT_END
	BHV_EXEC process_collision
BHV_LOOP_END
