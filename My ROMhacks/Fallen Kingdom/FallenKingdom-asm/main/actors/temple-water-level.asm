beh_temple_water_level_impl:
; BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_LOOP_BEGIN
	BHV_EXEC @water_level_loop
BHV_LOOP_END

@water_level_loop:
	LW T0, 0x80361188
	MTC1 T0, F4
	LW T0, g_current_obj_ptr
	CVT.S.W F4, F4
	JR RA
	S.S F4, o_y (T0)
