beh_slide_fall_timer_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_STORE_DISTANCE_TO_MARIO | OBJ_ALWAYS_ACTIVE
BHV_SET_COLLISION bb_level_7_object_Moving_Death_Plane_collision
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_collision_distance, 2048
BHV_SLEEP 1
BHV_EXEC @save_respawn
BHV_LOOP_BEGIN
	BHV_EXEC @move
	BHV_EXEC @set_respawn
BHV_LOOP_END

@save_respawn:
	LW T0, g_current_obj_ptr
	LI A0, (g_mario + m_position)
	J copy_vector
	ADDIU A1, T0, 0xF4
	
@move:
	LW T0, g_current_obj_ptr
	LI T1, g_mario
	
	LW AT, m_x (T1)
	SW AT, o_x (T0)
	
	LW AT, m_z (T1)
	SW AT, o_z (T0)
	
	LW AT, m_action (T1)
	ANDI AT, AT, 0x800
	BNE AT, R0, @@return
		LI.S F5, 3952
		L.S F4, m_y (T1)
		SUB.S F4, F4, F5
		S.S F4, o_y (T0)
	
	@@return:
	J process_collision
	NOP

@set_respawn:
	LW T0, g_current_obj_ptr
	LI A1, bbp_9f5317da4fb645b89267ec1bc50d9aad_respawn_location
	J copy_vector
	ADDIU A0, T0, 0xF4
