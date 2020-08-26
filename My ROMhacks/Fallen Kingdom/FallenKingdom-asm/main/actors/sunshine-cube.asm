@_despawn_timer equ 0xF4
@_turn_data_ptr equ 0xF8

@RISE_SPEED equ float( 7 )

beh_sunshine_cube_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO | OBJ_ALWAYS_ACTIVE | OBJ_AUTO_MOVE_Y
BHV_SET_COLLISION bb_level_4_object_Cube_collision
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_collision_distance, 1024
BHV_SET_INT @_despawn_timer, 0
BHV_SET_WORD @_turn_data_ptr, @turn_table
BHV_STORE_HOME
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC 0x802A2BC4
	BHV_EXEC process_collision
BHV_LOOP_END

@loop:
	LW T0, g_current_obj_ptr
	LW T1, o_state (T0)
	
	LW T2, @_despawn_timer (T0)
	SLTIU AT, T2, 75
	BNE AT, R0, @@endif_blink
		SLTIU AT, T2, 150
		BNE AT, R0, @@endif_reset
			LW AT, o_home_y (T0)
			SW AT, o_y (T0)
			SW R0, o_speed_y (T0)
			SW R0, o_angle_vel_pitch (T0)
			SW R0, o_angle_vel_yaw (T0)
			SW R0, o_angle_vel_roll (T0)
			SW R0, o_face_angle_pitch (T0)
			SW R0, o_face_angle_yaw (T0)
			SW R0, o_face_angle_roll (T0)
			SW R0, @_despawn_timer (T0)
			LHU AT, o_gfx_flags (T0)
			ANDI AT, AT, 0xFFEF
			SH AT, o_gfx_flags (T0)
			SW R0, o_state (T0)
			LI T2, @turn_table
			B @@return
			SW T2, @_turn_data_ptr (T0)
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
		LI T2, @RISE_SPEED
		JR RA
		SW T2, o_speed_y (T0)
	@@endif_idle:
	
	SETU AT, 1
	BNE T1, AT, @@endif_rising
		LW T2, g_mario_obj_ptr
		LW AT, 0x214 (T2)
		BNE T0, AT, @@elseif_off_cube
		LW T2, (g_mario + m_action)
		ANDI AT, T2, 0x800
		BNE AT, R0, @@elseif_off_cube
			LHU AT, o_gfx_flags (T0)
			ANDI AT, AT, 0xFFEF
			SH AT, o_gfx_flags (T0)
			SW R0, @_despawn_timer (T0)
		@@elseif_off_cube:
			LW AT, @_despawn_timer (T0)
			ADDIU AT, AT, 1
			SW AT, @_despawn_timer (T0)
		@@endif_on_cube:
		
		LW AT, o_timer (T0)
		SLTIU AT, 64
		BNE AT, R0, @@return
		
		LW T2, @_turn_data_ptr (T0)
		LI T3, @end_turn_table
		SW R0, o_timer (T0)
		BNE T2, T3, @@endif_reached_goal
			SETU AT, 2
			SW AT, o_state (T0)
			SW R0, o_angle_vel_pitch (T0)
			SW R0, o_angle_vel_yaw (T0)
			SW R0, o_angle_vel_roll (T0)
			B @@return
			SW R0, o_speed_y (T0)
		@@endif_reached_goal:
		
		LHU AT, 0x0 (T2)
		SW AT, o_angle_vel_pitch (T0)
		LHU AT, 0x2 (T2)
		SW AT, o_angle_vel_yaw (T0)
		LHU AT, 0x4 (T2)
		SW AT, o_angle_vel_roll (T0)
		ADDIU T2, T2, 6
		B @@return
		SW T2, @_turn_data_ptr (T0)
	@@endif_rising:
	
	LW AT, @_despawn_timer (T0)
	ADDIU AT, AT, 1
	SW AT, @_despawn_timer (T0)
	
	@@return:
	JR RA
	NOP

.macro @TURN_ENTRY, pitch, yaw, roll
	.halfword (256 * pitch), (256 * yaw), (256 * roll)
.endmacro

@turn_table:
	@TURN_ENTRY 0, 1, 0
	@TURN_ENTRY 1, 1, 0
	@TURN_ENTRY -1, 0, 0
	@TURN_ENTRY 0, 2, 0
	@TURN_ENTRY -1, -1, -1
	@TURN_ENTRY 0, 0, -1
	@TURN_ENTRY 1, 2, 0
	@TURN_ENTRY 0, 1, 0
@end_turn_table:
.halfword 0
.align 4
