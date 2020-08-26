.definelabel beh_rapids_bomb, (org() - 0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_MODEL 0xB3
BHV_SCALE 70
BHV_SET_HITBOX 84, 168, 84
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_INT o_collision_damage, 3
BHV_LOOP_BEGIN
	BHV_EXEC @bomb_loop
BHV_LOOP_END

.definelabel beh_rapids_bouncing_bomb, (org() - 0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_MODEL 0xB3
BHV_SCALE 70
BHV_SET_HITBOX 84, 168, 84
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_INT o_collision_damage, 3
BHV_SET_FLOAT o_speed_x, 15
BHV_LOOP_BEGIN
	BHV_EXEC @bounce
	BHV_EXEC @bomb_loop
BHV_LOOP_END

.definelabel beh_rapids_stake, (org() - 0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_MODEL 26
BHV_SET_HITBOX 75, 550, 0
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_INT o_collision_damage, 2
BHV_END

.definelabel beh_rapids_grate, (org() - 0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_MODEL 33
BHV_SET_INT o_collision_damage, 2
BHV_LOOP_BEGIN
	BHV_EXEC @grate_loop
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

.definelabel beh_rapids_log, (org() - 0x80000000)
BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_MODEL 30
BHV_SET_COLLISION bb_level_5_object_Log_collision
BHV_SET_FLOAT o_collision_distance, 500
BHV_LOOP_BEGIN
	BHV_EXEC @log_loop
	BHV_EXEC process_collision
BHV_LOOP_END

.definelabel beh_rapids_goal, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_MODEL 40
BHV_END

@bomb_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LW AT, o_interaction_status (A0)
	BEQ AT, R0, @@return
	
	LI A2, beh_explosion
	JAL spawn_object
	SETU A1, 0xCD
	
	LW T0, g_current_obj_ptr
	SH R0, o_active_flags (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@grate_loop:
	LI A0, g_mario
	LW A1, g_current_obj_ptr
	L.S F4, o_z (A1)
	L.S F5, m_z (A0)
	SUB.S F4, F5, F4
	LI.S F5, 50
	ABS.S F4, F4
	C.LT.S F4, F5
	LI.S F5, 325
	BC1F @@return
	L.S F4, o_y (A1)
	ADD.S F5, F4, F5
	L.S F4, m_y (A0)
	C.LT.S F4, F5
	NOP
	BC1F @@return
	NOP
		J 0x8024D998
		SW A1, 0x78 (A0)
	@@return:
	JR RA
	NOP

@log_loop:
	LI A0, g_mario
	LW A1, g_current_obj_ptr
	L.S F4, o_z (A1)
	L.S F5, m_z (A0)
	SUB.S F4, F5, F4
	LI.S F5, 150
	ABS.S F4, F4
	C.LT.S F4, F5
	LI.S F5, 32
	BC1F @@return
	L.S F4, o_y (A1)
	SUB.S F5, F4, F5
	L.S F4, m_y (A0)
	C.LT.S F4, F5
	LI.S F6, 230
	BC1F @@return
	L.S F5, o_y (A1)
	SUB.S F5, F5, F6
	C.LE.S F4, F5
	NOP
	BC1T @@return
	SETU AT, 1
		SW AT, o_collision_damage (A1)
		SETS AT, -1
		SW AT, o_intangibility_timer (A1)
		J 0x8024D998
		SW A1, 0x78 (A0)
	@@return:
	JR RA
	NOP

@bounce:
	LW T0, g_current_obj_ptr
	LI.S F5, 216
	L.S F4, o_x (T0)
	ABS.S F4, F4
	C.LT.S F4, F5
	L.S F5, o_speed_x (T0)
	BC1T @@endif_bounce
	NEG.S F4, F5
		S.S F4, o_speed_x (T0)
	@@endif_bounce:
	L.S F4, o_x (T0)
	L.S F5, o_speed_x (T0)
	ADD.S F4, F4, F5
	JR RA
	S.S F4, o_x (T0)
