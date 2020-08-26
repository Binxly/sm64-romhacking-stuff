beh_bombiwa_impl:
; BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_FLOAT o_render_distance, 10000
BHV_SET_INTERACTION INT_SOLID
BHV_SET_HITBOX 112, 250, 0
BHV_SET_HURTBOX 150, 250
BHV_SET_INT o_intangibility_timer, 0
BHV_EXEC @check_spawn_flags
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

.definelabel @debris_spawner, (org() - 0x80000000)
BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_SPAWN_OBJECT 40, @debris, 0
BHV_SPAWN_OBJECT 40, @debris, 0
BHV_SPAWN_OBJECT 40, @debris, 0
BHV_DELETE
BHV_END

.definelabel @debris, (org() - 0x80000000)
BHV_START OBJ_LIST_PARTICLES
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_AUTO_MOVE_XZ | OBJ_AUTO_MOVE_Y
BHV_SET_RANDOM_SHORT o_face_angle_yaw, 0, 0
BHV_SET_RANDOM_SHORT o_face_angle_pitch, 0, 0
BHV_SET_RANDOM_SHORT o_face_angle_roll, 0, 0
BHV_SET_RANDOM_SHORT o_move_angle_yaw, 0, 0
BHV_SET_RANDOM_FLOAT o_speed_h, 8, 4
BHV_SET_RANDOM_FLOAT o_speed_y, 24, 24
BHV_SCALE 50
BHV_REPEAT_BEGIN 45
	BHV_ADD_FLOAT o_speed_y, -2
BHV_REPEAT_END
BHV_DELETE
BHV_END

@check_spawn_flags:
	LW T0, g_current_obj_ptr
	LW T1, o_arg0 (T0)
	BEQ T1, R0, @@return
	LW T2, (global_vars + gv_env_flags)
	AND AT, T2, T1
	BEQ AT, R0, @@return
	NOP
		SH R0, o_active_flags (T0)
	@@return:
	JR RA
	NOP
	
@loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LI.U A1, beh_explosion
	JAL colliding_with_type
	LI.L A1, beh_explosion
	
	BEQ V0, R0, @@return
	
	LW A0, g_current_obj_ptr
	LI A2, @debris_spawner
	JAL spawn_object
	MOVE A1, R0
	
	LW T0, g_current_obj_ptr
	SH R0, o_active_flags (T0)
	LW T0, o_arg0 (T0)
	BEQ T0, R0, @@return
	LI T1, global_vars
	LW AT, gv_env_flags (T1)
	OR AT, AT, T0
	JAL save_game
	SW AT, gv_env_flags (T1)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	

	
