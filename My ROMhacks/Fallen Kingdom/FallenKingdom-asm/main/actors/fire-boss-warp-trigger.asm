beh_fire_boss_warp_trigger_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_STORE_DISTANCE_TO_MARIO | OBJ_ALWAYS_ACTIVE
BHV_SET_COLLISION bb_level_8_object_Boss_Warp_Trigger_collision
BHV_SET_FLOAT o_collision_distance, 2000
BHV_SET_INT o_intangibility_timer, 0
BHV_LOOP_BEGIN
	BHV_EXEC process_collision
BHV_LOOP_END