@ROLL_SPEED equ 0xC0
@MOVE_SPEED equ float( 12.5 )

@_despawn_timer equ 0xF4

; TODO: jump inertia

beh_wooden_cog_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO | OBJ_ALWAYS_ACTIVE
BHV_SET_COLLISION bb_level_4_object_Long_Wooden_Cog_collision
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_collision_distance, 778
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_INT @_despawn_timer, 0
BHV_STORE_HOME
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC decompose_speed_and_move
	BHV_EXEC process_collision
BHV_LOOP_END

@loop:
	LW T0, g_current_obj_ptr
	LW T1, o_state (T0)
	
	LW T2, o_angle_vel_pitch (T0)
	LW AT, o_face_angle_pitch (T0)
	ADDU AT, AT, T2
	SHORT AT, AT
	SW AT, o_face_angle_pitch (T0)
	
	LW T2, @_despawn_timer (T0)
	SLTIU AT, T2, 75
	BNE AT, R0, @@endif_blink
		SLTIU AT, T2, 150
		BNE AT, R0, @@endif_reset
			LW AT, o_home_x (T0)
			SW AT, o_x (T0)
			LW AT, o_home_z (T0)
			SW AT, o_z (T0)
			SW R0, o_speed_h (T0)
			SW R0, o_angle_vel_pitch (T0)
			SW R0, o_face_angle_pitch (T0)
			SW R0, @_despawn_timer (T0)
			LHU AT, o_gfx_flags (T0)
			ANDI AT, AT, 0xFFEF
			SH AT, o_gfx_flags (T0)
			B @@return
			SW R0, o_state (T0)
		@@endif_reset:
		ANDI AT, T2, 0x1
		BEQ AT, R0, @@endif_invisible
		LHU AT, o_gfx_flags (T0)
			ORI AT, AT, 0x10
			B @@process_states
			SH AT, o_gfx_flags (T0)
		@@endif_invisible:
			ANDI AT, AT, 0xFFEF
			B @@process_states
			SH AT, o_gfx_flags (T0)
	@@endif_blink:
	LHU AT, o_gfx_flags (T0)
	ANDI AT, AT, 0xFFEF
	B @@process_states
	SH AT, o_gfx_flags (T0)
			
	@@process_states:
	BNE T1, R0, @@endif_idle
		LW T2, g_mario_obj_ptr
		LW AT, 0x214 (T2)
		BNE T0, AT, @@return
		LW T2, (g_mario + m_action)
		ANDI AT, T2, 0x800
		BNE AT, R0, @@return
		SETU AT, 1
		SW AT, o_state (T0)
		LI T2, @MOVE_SPEED
		SW T2, o_speed_h (T0)
		SETU AT, @ROLL_SPEED
		B @@return
		SW AT, o_angle_vel_pitch (T0)
	@@endif_idle:
	
	SETU AT, 1
	BNE T1, AT, @@endif_moving
		LBU T2, o_arg0 (T0)
		SLL T2, T2, 5
		LW AT, o_timer (T0)
		SLTU AT, AT, T2
		BNE AT, R0, @@endif_reached_end
			SETU AT, 2
			SW AT, o_state (T0)
			SW R0, o_speed_h (T0)
			B @@return
			SW R0, o_angle_vel_pitch (T0)
		@@endif_reached_end:
	
		LW T2, g_mario_obj_ptr
		LW AT, 0x214 (T2)
		BNE T0, AT, @@endif_moving
		LW T2, (g_mario + m_action)
		ANDI AT, T2, 0x800
		BNE AT, R0, @@endif_moving
		NOP
			B @@return
			SW R0, @_despawn_timer (T0)
	@@endif_moving:
	
	LW AT, @_despawn_timer (T0)
	ADDIU AT, AT, 1
	SW AT, @_despawn_timer (T0)
	
	@@return:
	JR RA
	NOP
	
