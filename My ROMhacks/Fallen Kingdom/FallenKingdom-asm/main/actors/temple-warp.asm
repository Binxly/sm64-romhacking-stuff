beh_water_temple_instant_warp_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_COLLISION bb_level_22_object_Instant_Warp_collision
BHV_SET_FLOAT o_collision_distance, 285
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC process_collision
BHV_LOOP_END

@loop:
	LW T0, g_current_obj_ptr
	LI.S F5, 200
	L.S F4, o_y (T0)
	ADD.S F4, F4, F5
	L.S F5, (g_mario + m_y)
	C.LE.S F5, F4
	SETS AT, -1
	BC1F @@return
	SW AT, o_intangibility_timer (T0)
	SW R0, o_intangibility_timer (T0)
	@@return:
	JR RA
	NOP
