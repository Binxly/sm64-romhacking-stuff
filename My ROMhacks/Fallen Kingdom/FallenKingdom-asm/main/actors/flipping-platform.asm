beh_flipping_platform_spawner_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_ADD_FLOAT o_x, -2000
BHV_ADD_FLOAT o_z, -2000
BHV_REPEAT_BEGIN 5
	BHV_REPEAT_BEGIN 5
		BHV_SPAWN_OBJECT 0, @beh_flipping_platform, 0
		BHV_ADD_INT o_face_angle_yaw, 0x4000
		BHV_ADD_FLOAT o_x, 1000
	BHV_REPEAT_END
	BHV_ADD_FLOAT o_x, -5000
	BHV_ADD_FLOAT o_z, 1000
BHV_REPEAT_END
BHV_DELETE
BHV_END

.definelabel @beh_flipping_platform, (org() - 0x80000000)
BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_COLLISION bb_level_4_object_Flip_Board__Red__collision
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_collision_distance, 2500
BHV_SET_INT o_angle_vel_pitch, 0x100
BHV_SET_RANDOM_SHORT o_face_angle_pitch, 0, 0
BHV_EXEC @set_model
BHV_LOOP_BEGIN
	BHV_ADD_INT o_face_angle_pitch, 0x100
	BHV_EXEC process_collision
BHV_LOOP_END

@set_model:
	LW T0, g_current_obj_ptr
	LW T0, o_face_angle_yaw (T0)
	ANDI T0, T0, 0x4000
	SRL T0, T0, 14
	J 0x802A04C0
	ADDIU A0, T0, 81
