beh_locked_door_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_collision_distance, 1000
BHV_SET_COLLISION 0x0301CE78
BHV_SET_INT o_intangibility_timer, 0
BHV_EXEC @door_init
BHV_LOOP_BEGIN
	BHV_EXEC @door_loop
	BHV_EXEC process_collision
BHV_LOOP_END

.definelabel @beh_real_fake_door, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_END

@door_init:
	ADDIU SP, SP, 0xFFE0
	SW RA, 0x1C (SP)
	
	LW A0, g_current_obj_ptr
	LW T0, (global_vars + gv_env_flags)
	LW AT, o_arg0 (A0)
	AND AT, T0, AT
	BEQ AT, R0, @@endif_unlocked
		SETU A1, 31
		LI A2, 0x13000B0C
		JAL spawn_object
		SH R0, o_active_flags (A0)
		B @@return
		SW R0, o_arg0 (V0)
	@@endif_unlocked:
		
	SW A0, 0x10 (SP)
	MOVE A0, R0
	SETU A1, -77
	MOVE A2, R0
	MOVE A3, R0
	SETU AT, 31
	SW AT, 0x14 (SP)
	LI T0, @beh_real_fake_door
	JAL 0x8029EF64
	SW T0, 0x18 (SP)
	
	LW T0, g_current_obj_ptr
	SW V0, 0xF4 (T0)
		
	@@return:
	LW RA, 0x1C (SP)
	JR RA
	ADDIU SP, SP, 0x20

@door_loop:
	LI T1, key_info
	LW AT, k_state (T1)
	BNE AT, R0, @@return
	LW T0, g_current_obj_ptr
	LI.S F5, 500
	L.S F4, o_distance_to_mario (T0)
	C.LE.S F4, F5
	NOP
	BC1F @@return
	SETU AT, KEY_UNLOCKING
	SW AT, k_state (T1)
	SW T0, k_door (T1)
	@@return:
	JR RA
	NOP
	
unlock_door:
	; a0 = door
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW A0, 0x10 (SP)
	
	SH R0, o_active_flags (A0)
	
	LI T0, global_vars
	LW T1, gv_env_flags (T0)
	LW AT, o_arg0 (A0)
	OR T1, T1, AT
	JAL save_game
	SW T1, gv_env_flags (T0)

	LW A0, 0x10 (SP)
	LW AT, 0xF4 (A0)
	SH R0, o_active_flags (AT)
	LI A2, 0x13000B0C
	JAL spawn_object
	SETU A1, 31
	
	LI A0, 0x7022FF81
	JAL set_sound
	ADDIU A1, V0, 0x54
	
	SW R0, (key_info + k_state)
	
	; todo: spawn particles?
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
