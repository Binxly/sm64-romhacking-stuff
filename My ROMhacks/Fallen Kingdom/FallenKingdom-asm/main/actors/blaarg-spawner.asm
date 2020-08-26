beh_blaarg_spawner_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_EXEC @check_completed
BHV_LOOP_BEGIN
	BHV_EXEC @trigger_loop
BHV_LOOP_END

.definelabel @beh_gate, (org() - 0x80000000)
BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_COLLISION bb_level_8_object_Gate_collision
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 5000
BHV_SET_FLOAT o_collision_distance, 1200
BHV_ADD_FLOAT o_y, 1100
BHV_REPEAT_BEGIN 10
	BHV_ADD_FLOAT o_y, -100
	BHV_EXEC process_collision
BHV_REPEAT_END
BHV_LOOP_BEGIN
	BHV_EXEC @gate_loop
	BHV_EXEC process_collision
BHV_LOOP_END

@_gate1 equ 0xF4
@_gate2 equ 0xF8

@check_completed:
	LBU T0, (global_vars + gv_items)
	ANDI T0, T0, ITEM_BOMBS
	BEQ T0, R0, @@return
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@return:
	JR RA
	NOP
	
@trigger_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LW T0, g_current_obj_ptr
	LW AT, o_state (T0)
	BNE AT, R0, @@triggered
		LW A0, g_mario_obj_ptr
		JAL get_dist_2d
		MOVE A1, T0
		
		LI.S F4, 1375
		LW T0, (g_mario + m_action)
		C.LE.S F0, F4
		ANDI T1, T0, 0x800
		BC1F @@return
		LI T2, ACT_NOP
		BNE T1, R0, @@return
		LW T1, g_current_obj_ptr
		BEQ T0, T2, @@return
		SETU AT, 1
		B @@trigger_fight
		SW AT, o_state (T1)
	@@triggered:

	LI.U A0, beh_blaarg
	JAL get_nearest_object_with_behaviour
	LI.L A0, beh_blaarg
	
	BEQ V0, R0, @@won_fight
	LW A0, g_current_obj_ptr
	JAL get_dist_2d
	MOVE A1, V0
	
	LI.S F4, 2048
	NOP
	C.LE.S F0, F4
	NOP
	BC1T @@return
	NOP
	
	@@won_fight:
	LW T0, g_current_obj_ptr
	SETU AT, 1
	LW T1, @_gate1 (T0)
	SW AT, o_state (T1)
	LW T1, @_gate2 (T0)
	SW AT, o_state (T1)
	SH R0, o_active_flags (T0)
	
	MOVE A0, R0
	SETU A1, 6
	JAL set_music
	MOVE A2, R0
	
	JAL 0x803220F0
	NOP
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@@trigger_fight:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	MOVE A0, R0
	SETU A1, 10
	JAL set_music
	MOVE A2, R0
	
	LW A0, g_current_obj_ptr
	LI.S F5, 875
	L.S F4, o_z (A0)
	JAL @@spawn_blaargs
	ADD.S F12, F4, F5
	
	LW A0, g_current_obj_ptr
	LI.S F5, 875
	L.S F4, o_z (A0)
	JAL @@spawn_blaargs
	SUB.S F12, F4, F5
	
	LW A0, g_current_obj_ptr
	LI A2, @beh_gate
	JAL spawn_object
	SETU A1, 51
	LI T0, float( 9923 )
	SW T0, o_x (V0)
	LI T0, float( 7758 )
	SW T0, o_z (V0)
	SETS AT, 0xC000
	SW AT, o_face_angle_yaw (V0)
	
	LW A0, g_current_obj_ptr
	SW V0, @_gate1 (A0)
	
	LI A2, @beh_gate
	JAL spawn_object
	SETU A1, 51
	LI T0, float( 6862 )
	SW T0, o_x (V0)
	LI T0, float( 5758 )
	SW T0, o_z (V0)
	SETS AT, 0x4000
	SW AT, o_face_angle_yaw (V0)
	
	LW T0, g_current_obj_ptr
	SW V0, @_gate2 (T0)
	
	LW RA, 0x14 (SP)
	B @@return
	ADDIU SP, SP, 0x18
	
@@spawn_blaargs:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	SW A0, 0x18 (SP)
	S.S F12, 0x1C (SP)
	
	LI T0, float( 750 )
	SW T0, 0x10 (SP)
	
	LW A0, 0x18 (SP)
	LI A2, beh_blaarg
	JAL spawn_object
	SETU A1, 33
	L.S F4, o_x (V0)
	L.S F5, 0x10 (SP)
	ADD.S F4, F4, F5
	S.S F4, o_x (V0)
	LW AT, 0x1C (SP)
	SW AT, o_z (V0)
	SETS AT, 0xC000
	SW AT, o_face_angle_yaw (V0)
	
	LW A0, 0x18 (SP)
	LI A2, beh_blaarg
	JAL spawn_object
	SETU A1, 33
	L.S F4, o_x (V0)
	L.S F5, 0x10 (SP)
	SUB.S F4, F4, F5
	S.S F4, o_x (V0)
	LW AT, 0x1C (SP)
	SW AT, o_z (V0)
	SETS AT, 0x4000
	SW AT, o_face_angle_yaw (V0)
	/*
	LW A0, 0x18 (SP)
	LI A2, beh_blaarg
	JAL spawn_object
	SETU A1, 33
	L.S F5, 0x10 (SP)
	L.S F4, 0x1C (SP)
	ADD.S F4, F4, F5
	S.S F4, o_z (V0)
	SETS AT, 0x8000
	SW AT, o_face_angle_yaw (V0)
	
	LW A0, 0x18 (SP)
	LI A2, beh_blaarg
	JAL spawn_object
	SETU A1, 33
	L.S F5, 0x10 (SP)
	L.S F4, 0x1C (SP)
	SUB.S F4, F4, F5
	S.S F4, o_z (V0)
	*/
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@gate_loop:
	LW T0, g_current_obj_ptr
	
	LW AT, o_state (T0)
	BEQ AT, R0, @@return
	
	LW AT, o_timer (T0)
	SLTIU AT, AT, 20
	BNE AT, R0, @@endif_raised
	NOP
		B @@return
		SH R0, o_active_flags (T0)
	@@endif_raised:
	
	LI.S F5, 50
	L.S F4, o_y (T0)
	ADD.S F4, F4, F5
	S.S F4, o_y (T0)
	
	@@return:
	JR RA
	NOP
	
