beh_stalactite_large_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_COLLISION bb_level_8_object_Stalactite__Large__collision
BHV_SET_INTERACTION 0
BHV_SET_HITBOX 300, 500, 200
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_collision_distance, 2048
BHV_SET_FLOAT o_gravity, -4
BHV_EXEC @init
BHV_EXEC @store_floor_height
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_SET_INT o_move_flags, 0
	BHV_EXEC process_collision
BHV_LOOP_END

@_floor_height equ 0xF4

@init:
	LW T0, g_current_obj_ptr
	LW T1, (global_vars + gv_env_flags)
	LBU AT, o_arg0 (T0)
	SLL AT, AT, 24
	AND T1, T1, AT
	BEQ T1, R0, @@return
		SETU AT, 2
		J @drop_to_floor
		SW AT, o_state (T0)
	@@return:
	JR RA
	NOP
	
@store_floor_height:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW.U A0, g_current_obj_ptr
	JAL 0x80381470
	LW.L A0, g_current_obj_ptr
	
	LW T0, g_current_obj_ptr
	S.S F0, @_floor_height (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@drop_to_floor:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW.U A0, g_current_obj_ptr
	JAL 0x80381470
	LW.L A0, g_current_obj_ptr
	
	LW T0, g_current_obj_ptr
	S.S F0, o_y (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LW T1, o_state (T0)
	
	SETU AT, 2
	BEQ T1, AT, @@return
	NOP
	
	BNE T1, R0, @@endif_hanging
		LI A1, beh_explosion
		JAL colliding_with_type
		MOVE A0, T0
		
		BEQ V0, R0, @@return
		LW T0, g_current_obj_ptr
		
		SETU AT, 1
		SW AT, o_state (T0)
		
		; TODO: play sound
		
		B @@return
		NOP
	@@endif_hanging:
	
	L.S F4, o_speed_y (T0)
	L.S F5, o_gravity (T0)
	ADD.S F4, F4, F5
	S.S F4, o_speed_y (T0)
	
	JAL 0x802A12A4
	MOVE A0, R0
	
	LW T0, g_current_obj_ptr
	L.S F4, o_y (T0)
	L.S F5, @_floor_height (T0)
	C.LE.S F4, F5
	NOP
	BC1F @@return
	
	SETU AT, 2
	SW AT, o_state (T0)
	SW R0, o_speed_y (T0)
	S.S F5, o_y (T0)
	SW R0, o_hitbox_radius (T0)
	SW R0, o_hitbox_height (T0)
	
	JAL shake_screen
	SETU A0, 1
	
	JAL @drop_to_floor
	NOP
	
	; todo: play sound
	
	LW T0, g_current_obj_ptr
	LBU AT, o_arg1 (T0)
	BEQ AT, R0, @@return
	
	LI T1, global_vars
	LW T2, gv_env_flags (T1)
	LBU AT, o_arg0 (T0)
	SLL AT, AT, 24
	OR T2, T2, AT
	JAL save_game
	SW T2, gv_env_flags (T1)
	
	JAL 0x803220F0
	NOP
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
