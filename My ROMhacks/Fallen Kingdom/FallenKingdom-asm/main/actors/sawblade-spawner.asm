beh_sawblade_spawner_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_COMPUTE_MATRIX_TRANSFORM | OBJ_ALWAYS_ACTIVE
BHV_LOOP_BEGIN
	BHV_EXEC @spawner_loop
BHV_LOOP_END

.definelabel @beh_sawblade,(org()-0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_RELATIVE_TO_PARENT | OBJ_ALWAYS_ACTIVE
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_HITBOX 275, 20, 10
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INT o_collision_damage, 3
BHV_SET_FLOAT o_render_distance, 5500
BHV_SET_WORD o_state, @act_extending
BHV_LOOP_BEGIN
	BHV_EXEC @sawblade_loop
	BHV_ADD_INT o_face_angle_yaw, 0xF380
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

@spawner_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI T0, g_mario
	
	LI.S F5, -4170
	L.S F4, m_z (T0)
	C.LE.S F4, F5
	LI.S F5, 700
	BC1F @@endif_play_sound
	L.S F4, m_y (T0)
	C.LE.S F4, F5
	MTC1 R0, F5
	BC1F @@endif_play_sound
	C.LE.S F4, F5
	NOP
	BC1T @@endif_play_sound
		LUI A0, 0x4018
		JAL play_sound
		ORI A0, A0, 0x8001
	@@endif_play_sound:
	
	LW T0, g_current_obj_ptr
	LW AT, o_timer (T0)
	SLTIU AT, AT, 50
	BNE AT, R0, @@return
	NOP
	
	LW A0, g_current_obj_ptr
	LI A2, @beh_sawblade
	JAL spawn_object
	SETU A1, 92
	
	LW T0, g_current_obj_ptr
	SW R0, o_timer (T0)
	LW AT, o_arg0 (T0)
	SW AT, o_arg0 (V0)
	
	JAL get_random_short
	SW V0, 0x10 (SP)
	
	ANDI AT, V0, 0x1
	BEQ AT, R0, @@endif_lower
		LI T0, float( -375 )
		LW AT, 0x10 (SP)
		SW T0, o_relative_y (AT)
	@@endif_lower:
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@sawblade_loop:
	LW T0, g_current_obj_ptr
	LW AT, o_state (T0)
	JR AT
	NOP

@act_extending:
	LW T0, g_current_obj_ptr
	LI.S F5, 12.5
	L.S F4, o_relative_z (T0)
	ADD.S F4, F4, F5
	S.S F4, o_relative_z (T0)
	LW AT, o_timer (T0)
	SLTIU AT, AT, 22
	BNE AT, R0, @@return
		LI T1, @act_moving
		SW T1, o_state (T0)
	@@return:
	JR RA
	NOP
	
@act_moving:
	LW T0, g_current_obj_ptr
	LHU AT, o_arg0 (T0)
	SLL AT, AT, 16
	MTC1 AT, F5
	L.S F4, o_relative_x (T0)
	SUB.S F4, F4, F5
	S.S F4, o_relative_x (T0)
	LW T1, o_timer (T0)
	LBU AT, o_arg3 (T0)
	SLTU AT, T1, AT
	BNE AT, R0, @@return
		LI T1, @act_retracting
		SW T1, o_state (T0)
	@@return:
	JR RA
	NOP

@act_retracting:
	LW T0, g_current_obj_ptr
	LI.S F5, 12.5
	L.S F4, o_relative_z (T0)
	SUB.S F4, F4, F5
	S.S F4, o_relative_z (T0)
	LW AT, o_timer (T0)
	SLTIU AT, AT, 22
	BNE AT, R0, @@return
		NOP
		SH R0, o_active_flags (T0)
	@@return:
	JR RA
	NOP
