@_sink_counter equ 0xF4

beh_sinking_platform_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_COLLISION bb_level_8_object_Sinking_Platform_collision
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 15000
BHV_SET_FLOAT o_collision_distance, 2048
BHV_SET_INT @_sink_counter, 0
BHV_STORE_HOME
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC process_collision
BHV_LOOP_END

@SINKING_SPEED equ 2
@RISING_SPEED equ 0.5

@loop:
	LW T0, g_current_obj_ptr
	LW T1, g_mario_obj_ptr
	
	LW AT, 0x214 (T1)
	BNE T0, AT, @@off_platform
	
	LW T1, (g_mario + m_action)
	ANDI T1, T1, 0x800
	BNE T1, R0, @@off_platform
	
	SETU AT, 4
	SW AT, @_sink_counter (T0)
	
	@@on_platform:
	LI.S F5, @SINKING_SPEED
	L.S F4, o_y (T0)
	SUB.S F4, F4, F5
	B @@return
	S.S F4, o_y (T0)
	
	@@off_platform:
	LW AT, @_sink_counter (T0)
	BEQ AT, R0, @@endif_still_sinking
		ADDIU AT, AT, -1
		B @@on_platform
		SW AT, @_sink_counter (T0)
	@@endif_still_sinking:
	
	LI.S F5, @RISING_SPEED
	L.S F4, o_y (T0)
	ADD.S F4, F4, F5
	L.S F5, o_home_y (T0)
	MIN.S F4, F4, F5
	S.S F4, o_y (T0)
	
	@@return:
	JR RA
	NOP
	
