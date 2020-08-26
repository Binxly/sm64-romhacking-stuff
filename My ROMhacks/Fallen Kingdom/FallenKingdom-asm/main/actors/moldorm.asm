beh_moldorm_controller_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_EXEC @check_defeated
BHV_SLEEP 1
BHV_SET_INT o_health, 4
BHV_EXEC @spawn_moldorm
BHV_EXEC @update_crystal_texture
BHV_EXEC reset_camera
BHV_LOOP_BEGIN
	BHV_EXEC @controller_loop
BHV_LOOP_END

.definelabel @beh_moldorm_head, (org() - 0x80000000)
BHV_START OBJ_LIST_INTERACTIVE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_AUTO_FACE_FORWARDS_HORIZONTAL | OBJ_ALWAYS_ACTIVE | OBJ_STORE_ANGLE_TO_MARIO
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_INT o_collision_damage, 3
BHV_SET_HITBOX 200, 400, 175
BHV_SET_FLOAT o_y, -1024
BHV_SET_INT o_home_x, 0
BHV_SET_INT o_home_z, 0
BHV_LOOP_BEGIN
	BHV_EXEC @set_visibility
	BHV_EXEC @head_loop
	BHV_EXEC @handle_bully_collision
	BHV_EXEC @check_body_alive
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

.definelabel @beh_moldorm_body, (org() - 0x80000000)
BHV_START OBJ_LIST_INTERACTIVE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE | OBJ_AUTO_FACE_FORWARDS
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_INT o_collision_damage, 2
BHV_SET_HITBOX 200, 400, 175
BHV_LOOP_BEGIN
	BHV_EXEC @set_visibility
	BHV_EXEC @follow_the_leader
	BHV_EXEC @check_body_alive
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

.definelabel @beh_moldorm_tail, (org() - 0x80000000)
BHV_START OBJ_LIST_INTERACTIVE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE | OBJ_AUTO_FACE_FORWARDS
BHV_SET_INTERACTION INT_SOLID
BHV_SET_HITBOX 200, 400, 175
BHV_SET_HURTBOX 300, 400
BHV_LOOP_BEGIN
	BHV_EXEC @set_visibility
	BHV_EXEC @follow_the_leader
	BHV_EXEC @check_damaged
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

.definelabel @beh_falling_rock, (org() - 0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_BILLBOARD
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_HITBOX 75, 150, 0
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_gravity, -4
BHV_SET_INT o_collision_damage, 2
BHV_SET_FLOAT o_y, 2400
BHV_EXEC obj_update_floor
BHV_LOOP_BEGIN
	BHV_EXEC @rock_loop
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

.definelabel @beh_flame, (org() - 0x80000000)
BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_BILLBOARD
BHV_SCALE 1120
BHV_SET_INTERACTION INT_FLAME
BHV_SET_HITBOX 40, 80, 40
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_PHYSICS 0, -300, 0, 0, 0, 0
BHV_SET_RANDOM_SHORT o_move_angle_yaw, 0, 0
BHV_SET_FLOAT o_speed_h, 24
BHV_EXEC @set_flame_speed_y
BHV_EXEC decompose_speed
BHV_LOOP_BEGIN
	BHV_EXEC @flame_loop
	BHV_SET_INT o_interaction_status, 0
	BHV_ADD_INT o_animation_state, 1
BHV_LOOP_END

.definelabel @beh_victory_lift, (org() - 0x80000000)
BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_COLLISION bb_level_8_object_Victory_Lift_collision
BHV_SET_INT o_intangibility_timer, 60
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_collision_distance, 0x7FFF
BHV_SET_FLOAT o_x, 0
BHV_SET_FLOAT o_y, -1557
BHV_SET_FLOAT o_z, 2750
BHV_SLEEP 60
BHV_REPEAT_BEGIN 87
	BHV_ADD_FLOAT o_y, 11
	BHV_EXEC @victory_lift_rising
	BHV_EXEC process_collision
BHV_REPEAT_END
BHV_EXEC @victory_lift_risen
BHV_LOOP_BEGIN
	BHV_EXEC process_collision
BHV_LOOP_END

/* Common properties */
@_controller equ 0xF4

/* Controller properties */
@_head equ 0xF8
@_invisible equ 0xFC
@_invulnerable equ 0xFD
@_straighten equ 0xFE
@_flames_active equ 0xFF
@_idle_timer equ 0x100
@_crawl_counter equ 0x102
@_next_state equ 0x104

/* Constants */
@BODY_SEGMENTS equ 3
@ARENA_RADIUS equ 1500

@ROCKFALL_DURATION equ 300
@EXPECTED_BOMBS_PER_ROCKFALL equ 2.5
@EXPECTED_BULLYS_PER_ROCKFALL equ 1.0
@EXPECTED_SHROOMS_PER_ROCKFALL equ 0.5

@BOMB_SPAWN_CHANCE equ int((@EXPECTED_BOMBS_PER_ROCKFALL * 2.0 / @ROCKFALL_DURATION) * 0x10000)
@BULLY_SPAWN_CHANCE equ int((@EXPECTED_BULLYS_PER_ROCKFALL * 2.0 / @ROCKFALL_DURATION) * 0x10000)
@SHROOM_SPAWN_CHANCE equ int((@EXPECTED_SHROOMS_PER_ROCKFALL * 2.0 / @ROCKFALL_DURATION) * 0x10000)

@FAST_MOVE_SPEED equ 40
@SLOW_MOVE_SPEED equ 20
@FAST_HOMING_STRENGTH equ 0x120
@SLOW_HOMING_STRENGTH equ 0x140

@ERUPTION_INTENSITY equ 15
@ERUPTION_DURATION equ (@ERUPTION_INTENSITY << 3)

moldorm_defeated:
.word 0

@check_defeated:
	LW T0, (global_vars + gv_env_flags)
	LI T1, FLAG_FIRE_BOSS
	AND T0, T0, T1
	BEQ T0, R0, @@return
		SETU T0, 1
		SW T0, moldorm_defeated
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
		MOVE A0, T0
		LI A2, @beh_victory_lift
		J spawn_object
		SETU A1, 97
	@@return:
	JR RA
	NOP

@update_crystal_texture:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LI T1, @@texture_table
	LW AT, o_health (T0)
	SLL AT, AT, 2
	ADDU T1, T1, AT
	JAL segmented_to_virtual
	LW A0, 0x0 (T1)
	SW V0, 0x10 (SP)
	
	LI.U A0, bb_level_8_object_Moldorm__Tail__Crystal_texture_pointer
	JAL segmented_to_virtual
	LI.L A0, bb_level_8_object_Moldorm__Tail__Crystal_texture_pointer
	
	LW AT, 0x10 (SP)
	SW AT, 0x0 (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@texture_table:
	.word bb_level_8_object_Extra_Textures_Cracks__Heavy__texture_data
	.word bb_level_8_object_Extra_Textures_Cracks__Heavy__texture_data
	.word bb_level_8_object_Extra_Textures_Cracks__Medium__texture_data
	.word bb_level_8_object_Extra_Textures_Cracks__Light__texture_data
	.word bb_level_8_object_Moldorm__Tail__Crystal_texture_data

@spawn_moldorm:
	ADDIU SP, SP, 0xFFE0
	SW RA, 0x1C (SP)
	SW S0, 0x18 (SP)
	SW S1, 0x14 (SP)
	SW S2, 0x10 (SP)
	
	LW S0, g_current_obj_ptr
	SW S0, @_controller (S0)
	
	SETU AT, 1
	SB AT, @_invisible (S0)
	SB AT, @_invulnerable (S0)
	SB AT, @_straighten (S0)
	SB R0, @_flames_active (S0)
	
	SETU AT, 100
	SH AT, @_idle_timer (S0)
	SH R0, @_crawl_counter (S0)
	LI T0, @act_submerged
	SW T0, o_state (S0)
	LI T0, @act_eruption
	SW T0, @_next_state (S0)
	
	MOVE A0, S0
	LI A2, @beh_moldorm_head
	JAL spawn_object
	SETU A1, 93

	SW V0, @_head (S0)
	SW S0, @_controller (V0)
	MOVE S1, V0
	
	MOVE S2, R0
	@@loop:
		MOVE A0, S1
		LI A2, @beh_moldorm_body
		JAL spawn_object
		SETU A1, 94

		SB S2, o_arg0 (V0)
		SW S0, @_controller (V0)
		SW S1, o_parent (V0)
		MOVE S1, V0
		
		SLTIU AT, S2, @BODY_SEGMENTS
		BNE AT, R0, @@loop
		ADDIU S2, S2, 1
		
	MOVE A0, S1
	LI A2, @beh_moldorm_tail
	JAL spawn_object
	SETU A1, 95
	
	SW S0, @_controller (V0)
	SW S1, o_parent (V0)
	
	MOVE A0, R0
	SETU A1, 15
	JAL set_music
	MOVE A2, R0
	
	LI T0, float( 60 )
	SW T0, g_camera_fov
	
	LW S2, 0x10 (SP)
	LW S1, 0x14 (SP)
	LW S0, 0x18 (SP)
	LW RA, 0x1C (SP)
	JR RA
	ADDIU SP, SP, 0x20
	
@controller_loop:
	LW T0, g_current_obj_ptr
	SB R0, @_straighten (T0)
	LI T1, @act_dying
	LW AT, o_state (T0)
	BNE T1, AT, @@return
		LW AT, o_timer (T0)
		SB R0, @_flames_active (T0)
		SLTIU AT, ((@BODY_SEGMENTS + 2) * 20)
		BNE AT, R0, @@return
			MOVE A0, T0
			SH R0, o_active_flags (T0)
			LI A2, @beh_victory_lift
			J spawn_object
			SETU A1, 97
	@@return:
	JR RA
	NOP
	
	
@head_loop:
	ADDIU SP, SP, 0xFFE0
	SW RA, 0x1C (SP)
	SW S0, 0x18 (SP)
	SW S1, 0x14 (SP)
	
	LW S0, g_current_obj_ptr
	LW S1, @_controller (S0)
	LW T0, o_state (S1)
	JALR T0
	NOP
	
	LW S1, 0x14 (SP)
	LW S0, 0x18 (SP)
	LW RA, 0x1C (SP)
	JR RA
	ADDIU SP, SP, 0x20

@act_eruption:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	SETU AT, 1
	SB AT, @_invisible (S1)
	SB AT, @_invulnerable (S1)
	SB AT, @_flames_active (S1)
	
	JAL shake_screen
	SETU A0, 1
	
	LW T0, o_timer (S1)
	SLTIU AT, T0, @ERUPTION_DURATION
	BNE AT, R0, @@endif_done
		LI T1, @act_submerged
		SW T1, o_state (S1)
		LI T1, @act_fast_enter_init
		SW T1, @_next_state (S1)
		SETU AT, 73
		SH AT, @_idle_timer (S1)
		B @@return
		SH R0, @_crawl_counter (S1)
	@@endif_done:
	
	ANDI AT, T0, 0x7
	BNE AT, R0, @@return
	
	LUI A0, 0x300C
	JAL play_sound
	ORI A0, A0, 0x8081
	
	MOVE A0, S1
	LI A2, @beh_flame
	JAL spawn_object
	SETU A1, 0xCB
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	JR RA
	NOP

@act_submerged:
	SETU AT, 1
	SB AT, @_invisible (S1)
	SB AT, @_invulnerable (S1)
	LW T1, o_timer (S1)
	LHU AT, @_idle_timer (S1)
	SLTU AT, T1, AT
	BNE AT, R0, @@return
		LW AT, @_next_state (S1)
		SW AT, o_state (S1)
	@@return:
	JR RA
	NOP

@act_fast_enter_init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI T0, float( @FAST_MOVE_SPEED )
	SW T0, o_speed_h (S0)
	
	LI T0, float( 100 )
	SW T0, o_speed_y (S0)

	SB R0, @_invisible (S1)
	SB R0, @_invulnerable (S1)
	
	SETU AT, @FAST_HOMING_STRENGTH
	SW AT, o_angle_vel_yaw (S1)
	
	SETU AT, 1
	JAL get_random_short
	SB AT, @_straighten (S1)
	SW V0, o_move_angle_yaw (S0)
	JAL angle_to_unit_vector
	MOVE A0, V0
	
	LI.S F4, (@ARENA_RADIUS + (@FAST_MOVE_SPEED * 32))
	MUL.S F0, F0, F4
	MUL.S F1, F1, F4
	NEG.S F0, F0
	NEG.S F1, F1
	S.S F0, o_x (S0)
	S.S F1, o_z (S0)
	LI T0, float( -800 )
	SW T0, o_y (S0)
	
	LI T0, @act_enter_arena
	SW T0, o_state (S1)
	
	LUI A0, 0x5705
	JAL play_sound
	ORI A0, A0, 0xC081
	
	JAL decompose_speed
	NOP
	
	JAL @act_enter_arena
	NOP
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@act_slow_enter_init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI T0, float( @SLOW_MOVE_SPEED )
	SW T0, o_speed_h (S0)
	
	LI T0, float( 75 )
	SW T0, o_speed_y (S0)

	SB R0, @_invisible (S1)
	SB R0, @_invulnerable (S1)
	
	SETU AT, @SLOW_HOMING_STRENGTH
	SW AT, o_angle_vel_yaw (S1)
	
	SETU AT, 1
	JAL get_random_short
	SB AT, @_straighten (S1)
	SW V0, o_move_angle_yaw (S0)
	JAL angle_to_unit_vector
	MOVE A0, V0
	
	LI.S F4, (@ARENA_RADIUS + (@SLOW_MOVE_SPEED * 16))
	MUL.S F0, F0, F4
	MUL.S F1, F1, F4
	NEG.S F0, F0
	NEG.S F1, F1
	S.S F0, o_x (S0)
	S.S F1, o_z (S0)
	LI T0, float( -200 )
	SW T0, o_y (S0)
	
	LI T0, @act_enter_arena
	SW T0, o_state (S1)
	
	LUI A0, 0x5705
	JAL play_sound
	ORI A0, A0, 0xC081
	
	JAL decompose_speed
	NOP
	
	JAL @act_enter_arena
	NOP
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@act_enter_arena:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI.S F5, 4
	L.S F4, o_speed_y (S0)
	SUB.S F4, F4, F5
	JAL move_simple
	S.S F4, o_speed_y (S0)
	
	L.S F12, o_speed_h (S0)
	L.S F14, o_speed_y (S0)
	JAL atan2s
	NEG.S F14, F14
	SW V0, o_face_angle_pitch (S0)
	
	MTC1 R0, F5
	L.S F4, o_speed_y (S0)
	C.LT.S F4, F5
	LI.S F5, 175
	BC1F @@return
	L.S F4, o_y (S0)
	C.LE.S F4, F5
	NOP
	BC1F @@return
	LI T0, @act_crawl
	SW T0, o_state (S1)
	SW R0, o_face_angle_pitch (S0)
	S.S F5, o_y (S0)
	SW R0, o_speed_y (S0)
	JAL shake_screen
	SETU A0, 1
	LUI A0, 0x5068
	JAL play_sound
	ORI A0, A0, 0x8081
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@act_crawl:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, o_angle_to_mario (S0)
	JAL turn_move_angle_towards_target_angle
	LW A1, o_angle_vel_yaw (S1)
	
	JAL decompose_speed_and_move
	NOP
	
	JAL obj_xz_dist_from_home
	NOP
	
	LI.S F4, @ARENA_RADIUS
	C.LT.S F0, F4
	LI T1, @act_exit_arena
	BC1T @@return
	NOP
	SW T1, o_state (S1)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@act_exit_arena:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI.S F5, 4
	L.S F4, o_speed_y (S0)
	SUB.S F4, F4, F5
	JAL move_simple
	S.S F4, o_speed_y (S0)
	
	L.S F12, o_speed_h (S0)
	L.S F14, o_speed_y (S0)
	JAL atan2s
	NEG.S F14, F14
	SW V0, o_face_angle_pitch (S0)
	
	LI.S F5, (-1200 - (400 * @BODY_SEGMENTS))
	L.S F4, o_y (S0)
	C.LE.S F4, F5
	LI T1, @act_submerged
	BC1F @@return
	SETU AT, 1
	SB AT, @_invisible (S1)
	SB AT, @_invulnerable (S1)
	SW T1, o_state (S1)
	SETU AT, 45
	SH AT, @_idle_timer (S1)
	LHU T0, @_crawl_counter (S1)
	ADDIU T0, T0, 1
	SH T0, @_crawl_counter (S1)
	SLTIU AT, T0, 3
	BEQ AT, R0, @@endif_fast
		LI T1, @act_fast_enter_init
		B @@return
		SW T1, @_next_state (S1)
	@@endif_fast:
	SLTIU AT, T0, 4
	BEQ AT, R0, @@endif_slow
		LI T1, @act_slow_enter_init
		B @@return
		SW T1, @_next_state (S1)
	@@endif_slow:
	
	SB R0, @_flames_active (S1)
	LI T0, @act_rockfall
	SW T0, @_next_state (S1)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@act_rockfall:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL shake_screen
	SETU A0, 1
	
	SETU AT, 1
	SB AT, @_invisible (S1)
	SB AT, @_invulnerable (S1)
	
	LW T1, o_timer (S1)
	SLTIU AT, T1, @ROCKFALL_DURATION
	BNE AT, R0, @@endif_done
		LI T2, @act_submerged
		SW T2, o_state (S1)
		LI T2, @act_eruption
		SW T2, @_next_state (S1)
		SETU AT, 60
		B @@return
		SH AT, @_idle_timer (S1)
	@@endif_done:
	
	ANDI AT, T1, 0x1F
	BNE AT, R0, @@endif_spawn_over_mario
		MOVE A0, S1
		LI A2, @beh_falling_rock
		JAL spawn_object
		SETU A1, 96
		
		LI T0, g_mario
		LW AT, m_x (T0)
		SW AT, o_x (V0)
		LW AT, m_z (T0)
		B @@return
		SW AT, o_z (V0)
	@@endif_spawn_over_mario:
	
	ANDI AT, T1, 0x1
	BNE AT, R0, @@return
	
	MOVE A0, S1
	LI A2, @beh_falling_rock
	JAL spawn_object
	SETU A1, 96
	
	LI.S F12, @ARENA_RADIUS
	JAL get_random_point
	SW V0, 0x10 (SP)
	
	LW T0, 0x10 (SP)
	S.S F0, o_x (T0)
	S.S F1, o_z (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@act_dying:
	JR RA
	NOP

@set_visibility:
	LW T0, g_current_obj_ptr
	LW T1, @_controller (T0)
	LBU T2, @_invisible (T1)
	ANDI T2, T2, 0x1
	SLL T2, T2, 4
	SW T2, o_intangibility_timer (T0)
	LHU AT, o_gfx_flags (T0)
	OR AT, AT, T2
	ORI T2, T2, 0xFFEF
	AND AT, AT, T2
	JR RA
	SH AT, o_gfx_flags (T0)
	
@follow_the_leader:
	ADDIU SP, SP, 0xFFE0
	SW RA, 0x1C (SP)
	
	LW T0, g_current_obj_ptr
	LW T1, @_controller (T0)
	
	LBU AT, @_straighten (T1)
	BEQ AT, R0, @@endif_straighten
		LW T1, o_parent (T0)
		LW A0, o_face_angle_pitch (T1)
		LW A1, o_move_angle_yaw (T1)
		SW A0, o_face_angle_pitch (T0)
		JAL pitch_and_yaw_to_unit_vector
		SW A1, o_move_angle_yaw (T0)
		B @@set_position
		NOP
	@@endif_straighten:
	
	LW T1, o_parent (T0)
	L.S F12, o_x (T1)
	L.S F13, o_y (T1)
	L.S F14, o_z (T1)
	JAL unit_vector_from_object_to_point
	MOVE A0, T0
	
	S.S F0, 0x10 (SP)
	S.S F1, 0x14 (SP)
	S.S F2, 0x18 (SP)
	JAL vector_to_yaw_and_pitch
	ADDIU A0, SP, 0x10
	
	LW T0, g_current_obj_ptr
	SW V0, o_move_angle_yaw (T0)
	SW V1, o_face_angle_pitch (T0)
	
	L.S F0, 0x10 (SP)
	L.S F1, 0x14 (SP)
	L.S F2, 0x18 (SP)
	
	@@set_position:
	LI.S F4, 300
	LW T0, g_current_obj_ptr
	MUL.S F0, F0, F4
	MUL.S F1, F1, F4
	MUL.S F2, F2, F4
	LW T1, o_parent (T0)
	L.S F4, o_x (T1)
	L.S F5, o_y (T1)
	L.S F6, o_z (T1)
	SUB.S F4, F4, F0
	SUB.S F5, F5, F1
	SUB.S F6, F6, F2
	S.S F4, o_x (T0)
	S.S F5, o_y (T0)
	S.S F6, o_z (T0)
	
	@@return:
	LW RA, 0x1C (SP)
	JR RA
	ADDIU SP, SP, 0x20

@handle_bully_collision:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LUI A1, 0x1300
	JAL colliding_with_type
	ORI A1, A1, 0x362C
	
	BEQ V0, R0, @@return
	SW V0, 0x10 (SP)
	
	; YEEEEEEEEEEEEEEEEET
	LW T0, g_current_obj_ptr
	LW A0, o_move_angle_yaw (T0)
	JAL angle_to_unit_vector
	SW A0, o_move_angle_yaw (V0)
	
	LI.S F4, 100
	LW T0, 0x10 (SP)
	MUL.S F0, F0, F4
	MUL.S F1, F1, F4
	S.S F4, o_speed_h (T0)
	S.S F0, o_speed_x (T0)
	S.S F4, o_speed_y (T0)
	S.S F1, o_speed_z (T0)
	
	LI A0, 0x961C0081
	JAL set_sound
	ADDIU A1, T0, 0x54
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@check_body_alive:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LW T0, g_current_obj_ptr
	LW T1, @_controller (T0)
	
	LW T2, o_state (T1)
	LI T3, @act_dying
	BNE T2, T3, @@return
	
	LBU T2, o_arg0 (T0)
	SETU AT, (@BODY_SEGMENTS + 1)
	SUBU T2, AT, T2
	SETU AT, 20
	MULTU T2, AT
	NOP
	MFLO T2
	LW AT, o_timer (T1)
	SLTU AT, AT, T2
	BNE AT, R0, @@return
	
	MOVE A0, T0
	SETU A1, 0xCD
	LI A2, beh_explosion
	JAL spawn_object
	SH R0, o_active_flags (T0)
	
	LW T0, g_current_obj_ptr
	LBU AT, o_arg0 (T0)
	BNE AT, R0, @@return

	MOVE A0, R0
	SETU A1, 6
	JAL set_music
	MOVE A2, R0
	
	LI T0, float( 45 )
	SW T0, g_camera_fov
	
	LI T0, 1
	SW T0, moldorm_defeated
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@check_damaged:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LW T0, @_controller (A0)
	LBU AT, @_invulnerable (T0)
	BNE AT, R0, @@return
	
	LI.U A1, beh_explosion
	JAL colliding_with_type
	LI.L A1, beh_explosion
	
	BEQ V0, R0, @@return
	NOP
	
	LW AT, o_timer (V0)
	SLTIU AT, AT, 3
	BEQ AT, R0, @@return
	
	LW T0, g_current_obj_ptr
	LW T1, @_controller (T0)
	
	SETU AT, 1
	SB AT, @_invulnerable (T1)
	
	LW AT, o_health (T1)
	ADDIU AT, AT, -1
	BNE AT, R0, @@endif_dead
	SW AT, o_health (T1)
		LUI A0, 0x5706
		JAL create_sound_spawner
		ORI A0, A0, 0xFF81
		
		MOVE A0, R0
		MOVE A1, R0
		JAL set_music
		MOVE A2, R0
		
		LW T0, g_current_obj_ptr
		LW T1, @_controller (T0)
		LI T2, @act_dying
		SW T2, o_state (T1)
		
		SH R0, o_active_flags (T0)
		MOVE A0, T0
		LI A2, beh_explosion
		JAL spawn_object
		SETU A1, 0xCD
		
		B @@return
		NOP
	@@endif_dead:
	
	LI T2, float( @FAST_MOVE_SPEED )
	LW AT, @_head (T1)
	SW T2, o_speed_h (AT)
	SETU T2, @FAST_HOMING_STRENGTH
	SW T2, o_angle_vel_yaw (T1)
	
	LW AT, o_health (T1)
	JAL @update_crystal_texture
	SW AT, o_health (T0)
	
	LW A0, g_current_obj_ptr
	LI A2, beh_super_shroom
	JAL late_spawn_object
	SETU A1, 0xD4
	LUI AT, 0x428C
	SW AT, o_speed_y (V0)
	
	LUI A0, 0x9704
	JAL play_sound
	ORI A0, A0, 0xFF81
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@rock_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL obj_move_standard
	MOVE A0, R0
	
	LW T0, g_current_obj_ptr
	LW AT, o_move_flags (T0)
	ANDI AT, AT, (MF_JUST_LANDED | MF_GROUNDED)
	BEQ AT, R0, @@return
	
	LW T0, g_current_obj_ptr
	SH R0, o_active_flags (T0)
	
	LI.U A0, @rock_particles
	JAL spawn_particles
	LI.L A0, @rock_particles
	
	LUI A0, 0x3044
	JAL play_sound
	ORI A0, A0, 0x0081
	
	JAL get_random_short
	NOP
	
	LW A0, g_current_obj_ptr
	
	SLTIU AT, V0, @SHROOM_SPAWN_CHANCE
	BEQ AT, R0, @@endif_spawn_shroom
		LI A2, beh_super_shroom
		JAL late_spawn_object
		SETU A1, 0xD4
		LUI AT, 0x428C
		B @@return
		SW AT, o_speed_y (V0)
	@@endif_spawn_shroom:
	
	SLTIU AT, V0, (@BULLY_SPAWN_CHANCE + @SHROOM_SPAWN_CHANCE)
	BEQ AT, R0, @@endif_spawn_bully
		LI A2, 0x1300362C
		JAL late_spawn_object
		SETU A1, 0x56
		B @@return
		NOP
	@@endif_spawn_bully:
		
	SLTIU AT, V0, (@BOMB_SPAWN_CHANCE + @BULLY_SPAWN_CHANCE + @SHROOM_SPAWN_CHANCE)
	BEQ AT, R0, @@return
		LI A2, beh_bobomb
		JAL late_spawn_object
		SETU A1, 0xBC
		SETU AT, 1
		SB AT, o_arg3 (V0)
		
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@set_flame_speed_y:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL get_random_float
	NOP
	
	LI.S F4, 0.960546069
	LI.S F5, 0.039453931
	MUL.S F4, F0, F4
	ADD.S F4, F4, F5
	SQRT.S F4, F4
	
	LI.S F5, 73.125
	LI.S F6, 18.125
	MUL.S F4, F4, F5
	ADD.S F4, F4, F6
	
	LW T0, g_current_obj_ptr
	S.S F4, o_speed_y (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@flame_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LW T1, o_state (T0)
	
	BNE T1, R0, @@endif_falling
	NOP
		JAL obj_update_floor
		NOP
		JAL obj_move_standard
		MOVE A0, R0
		LW T0, g_current_obj_ptr
		LW AT, o_move_flags (T0)
		ANDI AT, AT, (MF_JUST_LANDED | MF_GROUNDED)
		BEQ AT, R0, @@return
		SETU AT, 1
		SW AT, o_state (T0)
		JAL 0x802A04C0
		SETU A0, 0x90
		B @@return
		NOP
	@@endif_falling:
	
	SETU AT, 1
	BNE T1, AT, @@endif_active
		LW AT, o_parent (T0)
		LBU AT, @_flames_active (AT)
		BNE AT, R0, @@return
		SETU AT, 2
		B @@return
		SW AT, o_state (T0)
	@@endif_active:
	
	LW AT, o_timer (T0)
	SLTIU AT, AT, 40
	BNE AT, R0, @@endif_despawn
	NOP
		B @@return
		SH R0, o_active_flags (T0)
	@@endif_despawn:
	
	LI.S F5, 0.28
	L.S F4, o_scale_x (T0)
	SUB.S F4, F4, F5
	S.S F4, o_scale_x (T0)
	S.S F4, o_scale_y (T0)
	
	LI.S F5, 1
	L.S F4, o_hitbox_radius (T0)
	SUB.S F4, F4, F5
	S.S F4, o_hitbox_radius (T0)
	ADD.S F4, F4, F4
	S.S F4, o_hitbox_height (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@rock_particles:
.byte 0 ; behaviour argument
.byte 3 ; number of particles
.byte 96 ; modelId
.byte 0 ; vertical offset
.byte 10 ; base horizontal velocity
.byte 5 ; random horizontal velocity range
.byte 20 ; base vertical velocity
.byte 18 ; random vertical velocity range
.byte -4 ; gravity
.byte 0 ; drag
.align 4
.word float( 5.0 ) ; base size
.word float( 1.25 ) ; random size range

@victory_lift_rising:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL shake_screen
	SETU A0, 1
	
	LUI A0, 0x4E18
	JAL play_sound
	ORI A0, A0, 0x8001
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@victory_lift_risen:
	LUI A0, 0x8E49
	J play_sound
	ORI A0, A0, 0xC081
