beh_underwater_impl:
; BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_LOOP_BEGIN
	BHV_EXEC @move_to_camera
	BHV_EXEC @update_visibility
BHV_LOOP_END

@move_to_camera:
	LW T0, g_current_obj_ptr
	LI T1, g_camera_state
	
	LW AT, cam_x (T1)
	SW AT, o_x (T0)
	
	LW AT, cam_y (T1)
	SW AT, o_y (T0)
	
	LW AT, cam_z (T1)
	SW AT, o_z (T0)
	
	LH AT, cam_pitch (T1)
	SUBU AT, R0, AT
	SW AT, o_face_angle_pitch (T0)
	
	LH AT, cam_yaw (T1)
	JR RA
	SW AT, o_face_angle_yaw (T0)

@update_visibility:
	LW T0, g_mario_obj_ptr
	BEQ T0, R0, @@set_visibility
	SETU V0, 0x10
	
	LI T0, g_mario

	LW T1, m_action (T0)
	ANDI T1, T1, 0x2000
	BEQ T1, R0, @@set_visibility

	L.S F4, (g_camera_state + cam_y)
	CVT.W.S F4, F4
	MFC1 T1, F4
	LH T0, m_water_level (T0)

	SLT AT, T1, T0
	BEQ AT, R0, @@set_visibility
	NOP
	
	MOVE V0, R0
	
	@@set_visibility:
	LW T0, g_current_obj_ptr
	LHU AT, o_gfx_flags (T0)
	ANDI AT, AT, 0xFFEF
	OR AT, AT, V0
	JR RA
	SH AT, o_gfx_flags (T0)
