beh_boo_platform_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_COLLISION bb_level_4_object_Boo_Platform_collision
BHV_SET_INT o_intangibility_timer, 0
BHV_SPAWN_OBJECT 0, @beh_boo_ring, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_collision_distance, 1680
BHV_LOOP_BEGIN
	BHV_EXEC process_collision
BHV_LOOP_END

.definelabel @beh_boo_ring, (org() - 0x80000000)
BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_REPEAT_BEGIN 5
	BHV_SPAWN_OBJECT 0x54, @beh_boo, 0
	BHV_SLEEP 40
BHV_REPEAT_END
BHV_DELETE
BHV_END

.definelabel @beh_boo, (org() - 0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_INTERACTION INT_DAMAGE
BHV_OR_FLAGS o_interaction_arg, IA_BIG_KNOCKBACK
BHV_SET_INT o_collision_damage, 1
BHV_SET_INT o_intangibility_timer, 0
BHV_SCALE 200
BHV_SET_FLOAT o_gfx_y_offset, 105
BHV_SET_HITBOX 140, 160, 0
BHV_SET_INT o_opacity, 0xC0
BHV_STORE_HOME
BHV_EXEC @load_angle_offset
BHV_LOOP_BEGIN
	BHV_ADD_INT o_face_angle_yaw, 0x111
	BHV_EXEC @position_boo
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

@load_angle_offset:
	LW T0, g_current_obj_ptr
	LW AT, o_parent (T0)
	LW AT, o_parent (AT)
	LHU AT, o_arg0 (AT)
	JR RA
	SW AT, o_face_angle_yaw (T0)

@position_boo:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	
	LW A0, o_face_angle_yaw (T0)
	JAL angle_to_unit_vector
	ADDIU A0, A0, 0xC000

	LI.S F4, 300
	LW T0, g_current_obj_ptr
	MUL.S F0, F0, F4
	MUL.S F1, F1, F4
	L.S F4, o_home_x (T0)
	L.S F5, o_home_z (T0)
	ADD.S F4, F4, F0
	ADD.S F5, F5, F1
	S.S F4, o_x (T0)
	S.S F5, o_z (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
