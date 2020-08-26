@ROLL_SPEED equ 0xC0

beh_rotating_block_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO | OBJ_AUTO_MOVE_XZ
BHV_SET_COLLISION bb_level_4_object_Wood_Block_collision
BHV_SET_FLOAT o_collision_distance, 3175
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INT o_angle_vel_roll, @ROLL_SPEED
BHV_LOOP_BEGIN
	BHV_ADD_INT o_move_angle_roll, @ROLL_SPEED
	BHV_ADD_INT o_face_angle_roll, @ROLL_SPEED
	BHV_EXEC process_collision
BHV_LOOP_END
