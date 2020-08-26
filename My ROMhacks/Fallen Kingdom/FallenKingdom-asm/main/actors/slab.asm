beh_slab_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO | OBJ_ALWAYS_ACTIVE
BHV_SET_FLOAT o_speed_z, 25
BHV_SET_FLOAT o_render_distance, 7000
BHV_SET_FLOAT o_collision_distance, 1024
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_COLLISION bb_level_22_object_Slab_collision
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC process_collision
BHV_LOOP_END

@loop:
	LW T0, g_current_obj_ptr
	
	L.S F4, o_z (T0)
	L.S F5, o_speed_z (T0)
	ADD.S F4, F4, F5
	S.S F4, o_z (T0)
	
	LW T1, o_timer (T0)
	SETU AT, 111
	BNE T1, AT, @@return
	
	NEG.S F4, F5
	S.S F4, o_speed_z (T0)
	SW R0, o_timer (T0)
	
	@@return:
	JR RA
	NOP
