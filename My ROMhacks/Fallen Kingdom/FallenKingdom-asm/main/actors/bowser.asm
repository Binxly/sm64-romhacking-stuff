@_action_arg equ 0xF4
@_prev_state equ 0xF8
@_jump_distance equ 0xFc
@_target_angle equ 0x100
@_laugh_cooldown equ 0x102

@FIGHT_DURATION equ 7000

beh_bowser_impl:
; BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_ANGLE_TO_MARIO | OBJ_STORE_DISTANCE_TO_MARIO | OBJ_ALWAYS_ACTIVE
BHV_SET_WORD o_animation_pointer, 0x060577E0
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_HITBOX 200, 384, 0
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_INT o_interaction_arg, IA_BIG_KNOCKBACK
BHV_SET_INT o_collision_damage, 3
BHV_SET_PHYSICS 0, -400, -70, 1000, 1000, 200
BHV_SET_INT o_opacity, 0xFF
BHV_SET_WORD o_state, @act_intro
BHV_EXEC @bowser_init
BHV_LOOP_BEGIN
	BHV_EXEC @bowser_loop
BHV_LOOP_END

.definelabel @beh_star, (org() - 0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_HITBOX 95, 190, 0
BHV_SET_INT o_collision_damage, 2
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_EXEC horizontally_billboard
BHV_SET_FLOAT o_y, 9400
BHV_REPEAT_BEGIN 60
	BHV_ADD_FLOAT o_y, -50
	BHV_SET_INT o_interaction_status, 0
BHV_REPEAT_END
BHV_EXEC @star_crash
BHV_DELETE
BHV_END

.definelabel @beh_fireball, (org() - 0x80000000)
BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE | OBJ_AUTO_MOVE_XZ
BHV_BILLBOARD
BHV_SCALE 0
BHV_SET_INT o_intangibility_timer, 0
BHV_ADD_FLOAT o_y, 80
BHV_SET_FLOAT o_speed_h, 25
BHV_REPEAT_BEGIN 15
	BHV_EXEC @scale_fireball
	BHV_ADD_INT o_animation_state, 1
	BHV_SET_INT o_interaction_status, 0
BHV_REPEAT_END
BHV_REPEAT_BEGIN 135
	BHV_ADD_INT o_animation_state, 1
	BHV_SET_INT o_interaction_status, 0
BHV_REPEAT_END
BHV_DELETE
BHV_END

.definelabel @beh_timer, (org() - 0x80000000)
BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_REPEAT_BEGIN @FIGHT_DURATION
	BHV_EXEC @timer_loop
BHV_REPEAT_END
BHV_EXEC @spawn_orbs
BHV_SLEEP 45
BHV_EXEC @flash_start
BHV_SLEEP 20
BHV_EXEC @flash_end
BHV_SLEEP 15
BHV_EXEC @spawn_vivian_trigger
BHV_DELETE
BHV_END

.definelabel @beh_orb, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_AUTO_MOVE_XZ | OBJ_ALWAYS_ACTIVE
BHV_BILLBOARD
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_speed_h, 25
BHV_SET_FLOAT o_speed_y, 0
BHV_ADD_FLOAT o_y, 100
BHV_SLEEP 30
BHV_SET_INT o_timer, 0
BHV_ADD_INT o_flags, -OBJ_AUTO_MOVE_XZ
BHV_REPEAT_BEGIN 20
	BHV_EXEC @homing_orb
BHV_REPEAT_END
BHV_DELETE
BHV_END

.definelabel @beh_grab_hitbox, (org() - 0x80000000)
BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE | OBJ_HOLDABLE
BHV_SET_INTERACTION INT_GRABBABLE
BHV_SET_HITBOX 150, 100, 0
BHV_SET_INT o_intangibility_timer, 0
BHV_END

.definelabel @beh_win_trigger, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_LOOP_BEGIN
	BHV_EXEC @check_end_game
BHV_LOOP_END

@ANIM_IDLE equ 0xC
@ANIM_ROAR equ 0xB
@ANIM_WALK equ 0xD
@ANIM_JUMPSQUAT equ 0x9
@ANIM_JUMP equ 0x17
@ANIM_LAND equ 0x18
@ANIM_BREATH_FIRE equ 0x6
@ANIM_SLASH equ 0xA
@ANIM_RUN equ 0x13
@ANIM_SKID equ 0x15
@ANIM_FLAIL equ 0x2

@NUM_JUMP_ATTACKS equ 4
@RUN_SPEED equ 25
@CHASE_HOMING_SPEED equ 0x280
@JUMP_POWER equ 70

@SLASH_MOVE_SPEED equ 40
@SLASH_REACT_TIME equ 25

@bowser_fight_timer:
.word 0

@bowser_init:
	SW R0, @bowser_fight_timer
	LW T0, g_current_obj_ptr
	LHU AT, o_active_flags (T0)
	ORI AT, AT, AF_DITHERED_ALPHA
	SH AT, o_active_flags (T0)
	SH R0, @_laugh_cooldown (T0)
	SETU T0, 96
	SB T0, (g_mario + m_heal_counter)
	SETU T0, 6
	SH T0, (global_vars + sv_level)
	J set_animation
	SETU A0, 0xC

@bowser_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)
	
	LW S0, g_current_obj_ptr
	
	LW T0, o_state (S0)
	LI T1, @act_defeated
	SLTU AT, T0, T1
	BEQ AT, R0, @@done_laugh_check
	LH T0, @_laugh_cooldown (S0)
	BEQ T0, R0, @@endif_positive
		ADDIU T0, T0, -1
		B @@done_laugh_check
		SH T0, @_laugh_cooldown (S0)
	@@endif_positive:
		LBU AT, (g_mario + m_hurt_counter)
		BNE AT, R0, @@laugh
		LI A1, beh_explosion
		JAL colliding_with_type
		MOVE A0, S0
		BEQ V0, R0, @@done_laugh_check
		@@laugh:
		LUI A0, 0x9038
		JAL play_sound
		ORI A0, A0, 0xBF81
		SETU AT, 100
		SH AT, @_laugh_cooldown (S0)
	@@done_laugh_check:
	
	LW T0, o_state (S0)
	LI T1, @act_slash
	BEQ T0, T1, @@endif_outside_arena
	LI T1, @act_grabbed
	SLTU AT, T0, T1
	BEQ AT, R0, @@endif_outside_arena
	
	L.S F4, o_x (S0)
	L.S F5, o_z (S0)
	MUL.S F6, F4, F4
	MUL.S F7, F5, F5
	ADD.S F6, F6, F7
	LI.S F7, 1300
	SQRT.S F6, F6
	C.LE.S F6, F7
	NOP
	BC1T @@endif_outside_arena
	NOP
		DIV.S F6, F7, F6
		MUL.S F4, F4, F6
		MUL.S F5, F5, F6
		S.S F4, o_x (S0)
		S.S F5, o_z (S0)
	@@endif_outside_arena:
	
	LW T0, o_state (S0)
	LW T1, @_prev_state (S0)
	BEQ T0, T1, @@endif_state_transition
		SW T0, @_prev_state (S0)
		LW T1, 0x0 (T0)
		BEQ T1, R0, @@endif_state_transition
		NOP
		JALR T1
		NOP
		LW T0, o_state (S0)
	@@endif_state_transition:
	ADDIU T0, T0, 4
	JALR T0
	NOP
	
	SW R0, o_interaction_status (S0)
	
	LW S0, 0x10 (SP)
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@act_intro:
	.word 0
	LW AT, o_timer (S0)
	SLTIU AT, 128
	BNE AT, R0, @@return
		LI T0, @act_roar
		SW T0, o_state (S0)
		LI T0, @act_talk
		SW T0, @_action_arg (S0)
	@@return:
	JR RA
	NOP
	
@act_talk:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, (g_mario + m_action)
	LI T1, 0x20001306
	BEQ T0, T1, @@return
		LI T0, @act_turn1
		SW T0, o_state (S0)
		SW R0, @_action_arg (S0)
		
		MOVE A0, S0
		LI A2, @beh_timer
		JAL spawn_object
		MOVE A1, R0
		
		LW A0, g_mario_obj_ptr
		LI A2, float( 250 )
		JAL spawn_vivian
		SETU A1, 50

	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		J set_animation
		SETU A0, @ANIM_IDLE
	
@act_roar:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL check_done_animation
	NOP
	
	BEQ V0, R0, @@return
	LW AT, @_action_arg (S0)
	SW AT, o_state (S0)
	SW R0, @_action_arg (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		JAL set_animation
		SETU A0, @ANIM_ROAR
		
		LUI A0, 0x9004
		JAL play_sound
		ORI A0, A0, 0xFF81
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
	
@act_turn1:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI A0, 0x50030081
	SETU A1, 20
	JAL @play_sound_on_frames
	SETU A2, 40
	
	LW A0, o_face_angle_yaw (S0)
	LW A1, o_angle_to_mario (S0)
	JAL turn_angle
	SETU A2, 0x960
	SW V0, o_face_angle_yaw (S0)
	
	LW AT, o_timer (S0)
	SLTIU AT, 5
	BNE AT, R0, @@return
	
	LW T0, o_angle_to_mario (S0)
	BEQ T0, V0, @@next_state
	
	LW AT, o_timer (S0)
	SLTIU AT, 15
	BNE AT, R0, @@return
	
	@@next_state:
	LI T0, @act_jumpsquat
	SW T0, o_state (S0)
	
	LW AT, o_distance_to_mario (S0)
	SW AT, @_jump_distance (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		LI.S F5, 250
		L.S F4, o_distance_to_mario (S0)
		C.LT.S F4, F5
		LI.U T0, @act_turn2
		BC1F @@endif_random_jump
			LI.L T0, @act_turn2
			SW T0, o_state (S0)
		@@endif_random_jump:
		J set_animation
		SETU A0, @ANIM_WALK
		
@act_turn2:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI A0, 0x50030081
	SETU A1, 20
	JAL @play_sound_on_frames
	SETU A2, 40
	
	LW A0, o_face_angle_yaw (S0)
	LH A1, @_target_angle (S0)
	JAL turn_angle
	SETU A2, 0x960
	SW V0, o_face_angle_yaw (S0)
	
	LH T0, @_target_angle (S0)
	BNE T0, V0, @@return
	
	LI T0, @act_jumpsquat
	SW T0, o_state (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		LI.S F12, 1300
		JAL get_random_point
		NOP
		
		MUL.S F4, F0, F0
		MUL.S F5, F1, F1
		ADD.S F4, F4, F5
		SQRT.S F4, F4
		S.S F4, @_jump_distance (S0)
		
		MOV.S F14, F0
		JAL atan2s
		MOV.S F12, F1
		
		SH V0, @_target_angle (S0)
		
		JAL set_animation
		SETU A0, @ANIM_WALK
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
	
@act_jumpsquat:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL check_done_animation
	NOP
	
	BEQ V0, R0, @@return
	LI T0, @act_jump
	SW T0, o_state (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		J set_animation
		SETU A0, @ANIM_JUMPSQUAT
	
@act_jump:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL move_simple
	NOP
	
	L.S F4, o_speed_y (S0)
	L.S F5, o_gravity (S0)
	ADD.S F4, F4, F5
	S.S F4, o_speed_y (S0)
	
	LI.S F5, 6400
	L.S F4, o_y (S0)
	C.LE.S F4, F5
	NOP
	BC1F @@return
	LI T0, @act_land
	SW T0, o_state (S0)
	S.S F5, o_y (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		LI T0, float( @JUMP_POWER )
		SW T0, o_speed_y (S0)
		
		JAL set_animation
		SETU A0, @ANIM_JUMP
		
		LI.S F5, 35
		L.S F4, @_jump_distance (S0)
		DIV.S F4, F4, F5
		S.S F4, o_speed_h (S0)
		LW AT, o_face_angle_yaw (S0)
		JAL decompose_speed
		SW AT, o_move_angle_yaw (S0)
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
	
@act_land:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL check_done_animation
	NOP
	
	BEQ V0, R0, @@return
	LW T0, @_action_arg (S0)
	ADDIU T0, T0, 1
	SW T0, @_action_arg (S0)
	SLTIU AT, T0, @NUM_JUMP_ATTACKS
	BEQ AT, R0, @@fireball_phase
		LI.U T0, @act_turn1
		B @@change_state
		LI.L T0, @act_turn1
	@@fireball_phase:
		LI T0, @act_turn3
		SW R0, @_action_arg (S0)
	@@change_state:
	SW T0, o_state (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		JAL set_animation
		SETU A0, @ANIM_LAND
		
		LUI A0, 0x5003
		JAL play_sound
		ORI A0, A0, 0xFF81
		
		JAL shake_screen
		SETU A0, 1
		
		MOVE A0, S0
		LI A2, 0x130011D0
		JAL spawn_object
		SETU A1, 0x68
		
		LI T0, float( 6400 )
		SW T0, o_y (V0)
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
	
@act_turn3:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI A0, 0x50030081
	SETU A1, 20
	JAL @play_sound_on_frames
	SETU A2, 40
	
	LW A0, o_face_angle_yaw (S0)
	LH A1, @_target_angle (S0)
	JAL turn_angle
	SETU A2, 0x240
	SW V0, o_face_angle_yaw (S0)
	
	LH T0, @_target_angle (S0)
	BNE T0, V0, @@return
	
	LI T0, @act_inhale
	SW T0, o_state (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		L.S F14, o_x (S0)
		L.S F12, o_z (S0)
		MUL.S F4, F14, F14
		MUL.S F5, F12, F12
		ADD.S F4, F4, F5
		SQRT.S F4, F4
		S.S F4, @_jump_distance (S0)
		NEG.S F12, F12
		JAL atan2s
		NEG.S F14, F14
		SH V0, @_target_angle (S0)
		
		JAL set_animation
		SETU A0, @ANIM_WALK
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
	
@act_inhale:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, o_face_angle_yaw (S0)
	LW A1, o_angle_to_mario (S0)
	JAL turn_angle
	SETU A2, 0x200
	SW V0, o_face_angle_yaw (S0)
	
	LHU T0, o_animation_frame (S0)
	SETU AT, 52
	BNE T0, AT, @@return
	
	LI T0, @act_fireball1
	SW T0, o_state (S0)
	SW R0, @_action_arg (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		LUI A0, 0x5008
		JAL play_sound
		ORI A0, A0, 0xFF81
		
		JAL set_animation
		SETU A0, @ANIM_BREATH_FIRE
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
	
@act_fireball1:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL check_done_animation
	NOP
	
	LW A0, o_face_angle_yaw (S0)
	LW A1, o_angle_to_mario (S0)
	JAL turn_angle
	SETU A2, 0x200
	SW V0, o_face_angle_yaw (S0)
	
	BEQ V0, R0, @@return
	
	LW AT, @_action_arg (S0)
	ADDIU AT, AT, 1
	SW AT, @_action_arg (S0)
	
	SLTIU AT, AT, 5
	BEQ AT, R0, @@done
		LI T0, @act_fireball2
		SW T0, o_state (S0)
		B @@return
		SH R0, o_animation_frame (S0)
	@@done:
		LI T0, @act_fadeout
		SW T0, o_state (S0)
		SW R0, @_action_arg (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		ADDIU SP, SP, 0xFFE0
		SW RA, 0x1C (SP)
		SW S1, 0x18 (SP)
		
		LW AT, o_face_angle_yaw (S0)
		ADDIU AT, AT, 0xD000
		SH AT, @_target_angle (S0)
		
		JAL angle_to_unit_vector
		LW A0, o_face_angle_yaw (S0)
		
		LI.S F6, 160
		L.S F4, o_x (S0)
		L.S F5, o_z (S0)
		MUL.S F0, F0, F6
		MUL.S F1, F1, F6
		ADD.S F4, F0, F4
		ADD.S F5, F1, F5
		S.S F4, 0x10 (SP)
		S.S F5, 0x14 (SP)
		
		MOVE S1, R0
		@@loop:
			LUI A0, 0x5007
			JAL play_sound
			ORI A0, A0, 0xC081
			
			MOVE A0, S0
			LI A2, @beh_fireball
			JAL spawn_object
			SETU A1, 144
			
			LW AT, 0x10 (SP)
			SW AT, o_x (V0)
			LW AT, 0x14 (SP)
			SW AT, o_z (V0)
			
			LH AT, @_target_angle (S0)
			SW AT, o_move_angle_yaw (V0)
			
			ADDIU S1, S1, 1
			LH T0, @_target_angle (S0)
			ADDIU T0, T0, 0x1000
			SLTIU AT, S1, 5
			BNE AT, R0, @@loop
			SH T0, @_target_angle (S0)
		
		LW S1, 0x18 (SP)
		LW RA, 0x1C (SP)
		JR RA
		ADDIU SP, SP, 0x20
	
@act_fireball2:
	.word 0
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, o_face_angle_yaw (S0)
	LW A1, o_angle_to_mario (S0)
	JAL turn_angle
	SETU A2, 0x200
	SW V0, o_face_angle_yaw (S0)
	
	LH AT, o_animation_frame (S0)
	ADDIU AT, AT, 1
	SH AT, o_animation_frame (S0)
	
	SLTIU AT, AT, 52
	BNE AT, R0, @@return
	
	LI T0, @act_fireball1
	SW T0, o_state (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@act_fadeout:
	.word @@state_init
	LW AT, o_opacity (S0)
	ADDIU AT, AT, -5
	SW AT, o_opacity (S0)
	BNE AT, R0, @@return
		LI T0, @act_invisible
		SW T0, o_state (S0)
		SW R0, @_action_arg (S0)
	@@return:
	JR RA
	NOP
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		JAL set_animation
		SETU A0, @ANIM_IDLE
		
		LUI A0, 0x5066
		JAL play_sound
		ORI A0, A0, 0xF081
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
	
@act_invisible:
	.word @@state_init
	LW AT, o_timer (S0)
	SLTIU AT, AT, 60
	BNE AT, R0, @@return
	LW AT, @_action_arg (S0)
	ADDIU AT, AT, 1
	SW AT, @_action_arg (S0)
	SLTIU AT, AT, 5
	BEQ AT, R0, @@fadein
		LI T0, @act_slash
		B @@return
		SW T0, o_state (S0)
	@@fadein:
		LI T0, @act_fadein
		SW T0, o_state (S0)
	@@return:
	JR RA
	NOP
	
	@@state_init:
		SW R0, o_opacity (S0)
		SW R0, o_interaction (S0)
		J 0x802A04C0
		MOVE A0, R0
	
@act_slash:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL move_simple
	NOP
	
	LW T0, o_timer (S0)
	SLTIU AT, T0, 5
	BEQ AT, R0, @@endif_fade_in
		LW AT, o_opacity (S0)
		ADDIU AT, AT, 51
		B @@return
		SW AT, o_opacity (S0)
	@@endif_fade_in:
	
	SLTIU AT, T0, ( (2 * @SLASH_REACT_TIME) - 5 )
	BNE AT, R0, @@endif_fade_out
		LW AT, o_opacity (S0)
		ADDIU AT, AT, -51
		SW AT, o_opacity (S0)
	@@endif_fade_out:
	
	SLTIU AT, T0, (2 * @SLASH_REACT_TIME)
	BNE AT, R0, @@return
	
	LI T0, @act_invisible
	SW T0, o_state (S0)
	LI T0, float( 6400 )
	SW T0, o_y (S0)
	SW R0, o_opacity (S0)
		
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		LI T0, INT_DAMAGE
		SW T0, o_interaction (S0)
		
		JAL 0x802A04C0
		SETU A0, 100
		
		LUI A0, 0x5066
		JAL play_sound
		ORI A0, A0, 0xF081
		
		JAL set_animation
		SETU A0, @ANIM_SLASH
		SH R0, o_animation_frame (S0)
		
		JAL get_random_short
		SW R0, o_speed_y (S0)
		
		ANDI AT, V0, 0x3
		BNE AT, R0, @@endif_infront
			LH T0, (g_mario + m_angle_yaw)
			ADDIU T0, T0, 0x8000
			SHORT V0, T0
		@@endif_infront:
		
		SW V0, o_face_angle_yaw (S0)
		SW V0, o_move_angle_yaw (S0)
		
		JAL angle_to_unit_vector
		MOVE A0, V0
		
		LI.S F4, ( @SLASH_MOVE_SPEED * @SLASH_REACT_TIME )
		LI T0, g_mario
		MUL.S F0, F0, F4
		MUL.S F1, F1, F4
		L.S F4, m_x (T0)
		L.S F5, m_z (T0)
		SUB.S F4, F4, F0
		SUB.S F5, F5, F1
		S.S F4, o_x (S0)
		S.S F5, o_z (S0)
		
		LI T0, float( @SLASH_MOVE_SPEED )
		JAL decompose_speed
		SW T0, o_speed_h (S0)
		
		LI.S F5, 150
		LI.S F6, 6400
		L.S F4, (g_mario + m_y)
		SUB.S F4, F4, F5
		MAX.S F4, F4, F6
		ADD.S F5, F5, F5
		ADD.S F5, F5, F6
		MIN.S F4, F4, F5
		S.S F4, o_y (S0)
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
	
@act_fadein:
	.word @@state_init
	LW AT, o_opacity (S0)
	ADDIU AT, AT, 5
	SW AT, o_opacity (S0)
	SLTIU AT, AT, 0xFF
	BNE AT, R0, @@return
		LI T0, @act_roar
		SW T0, o_state (S0)
		LI T0, @act_chase
		SW T0, @_action_arg (S0)
	
	@@return:
	JR RA
	NOP
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		SW R0, o_opacity (S0)
		LI T0, float( 6400 )
		SW T0, o_y (S0)
		SW R0, o_x (S0)
		SW R0, o_z (S0)
		
		LI T0, g_mario
		L.S F14, m_x (T0)
		JAL atan2s
		L.S F12, m_z (T0)
		
		SW V0, o_face_angle_yaw (S0)
		
		LI T0, INT_SOLID
		SW T0, o_interaction (S0)
		
		JAL 0x802A04C0
		SETU A0, 100
		
		JAL set_animation
		SETU A0, @ANIM_IDLE
		
		LUI A0, 0x5066
		JAL play_sound
		ORI A0, A0, 0xF081
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
	
@act_chase:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI A0, 0x50038081
	SETU A1, 8
	JAL @play_sound_on_frames
	SETU A2, 17
	
	LW A0, o_face_angle_yaw (S0)
	LW A1, o_angle_to_mario (S0)
	JAL turn_angle
	SETU A2, @CHASE_HOMING_SPEED
	
	SW V0, o_face_angle_yaw (S0)
	JAL decompose_speed
	SW V0, o_move_angle_yaw (S0)
	JAL move_simple
	NOP
	
	LW AT, o_timer (S0)
	ANDI AT, AT, 0x1
	BEQ AT, R0, @@endif_spawn_star
		MOVE A0, S0
		LI A2, @beh_star
		JAL spawn_object
		SETU A1, 26
		SW V0, 0x10 (SP)
		
		LI.S F12, 1400
		JAL get_random_point
		NOP
		
		LW V0, 0x10 (SP)
		S.S F0, o_x (V0)
		S.S F1, o_z (V0)
	@@endif_spawn_star:
	
	LW AT, o_timer (S0)
	SLTIU AT, AT, 450
	BNE AT, R0, @@return
		LI T0, @act_skid
		SW T0, o_state (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		SETU AT, 0xFF
		SW AT, o_opacity (S0)
		LI T0, INT_DAMAGE
		SW T0, o_interaction (S0)
		LI T0, float( @RUN_SPEED )
		SW T0, o_speed_h (S0)
		SW R0, o_speed_y (S0)
		J set_animation
		SETU A0, @ANIM_RUN
	
@act_skid:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LH AT, o_animation_frame (S0)
	SLTIU AT, AT, 0x10
	BNE AT, R0, @@endif_freeze_animation
		SETU AT, 9
		SH AT, o_animation_frame (S0)
	@@endif_freeze_animation:
	
	LI.S F5, (@RUN_SPEED / 15.0)
	L.S F4, o_speed_h (S0)
	SUB.S F4, F4, F5
	JAL decompose_speed
	S.S F4, o_speed_h (S0)
	JAL move_simple
	NOP
	
	LW AT, o_timer (S0)
	SLTIU AT, AT, 15
	BNE AT, R0, @@return
		LI T0, @act_turn1
		SW T0, o_state (S0)
		SW R0, @_action_arg (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		LUI A0, 0x502A
		JAL play_sound
		ORI A0, A0, 0xC881
		
		JAL set_animation
		SETU A0, @ANIM_SKID
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
	
@act_defeated:
	.word @@state_init
	SH R0, o_animation_frame (S0)
	LW AT, @_action_arg (S0)
	LW AT, o_held_state (AT)
	BEQ AT, R0, @@return
		LI T0, @act_grabbed
		SW T0, o_state (S0)
	@@return:
	JR RA
	NOP
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		JAL 0x802A04C0
		SETU A0, 100
		
		LI T0, INT_SOLID
		SW T0, o_interaction (S0)
		
		SETU AT, 0xFF
		SW AT, o_opacity (S0)
		
		LI T0, float( 6400 )
		SW T0, o_y (S0)
		SW R0, o_x (S0)
		SW R0, o_z (S0)
		
		LW AT, o_angle_to_mario (S0)
		ADDIU AT, AT, 0x8000
		SHORT AT, AT
		SW AT, o_face_angle_yaw (S0)
		SW AT, o_move_angle_yaw (S0)
		
		SW R0, o_speed_x (S0)
		SW R0, o_speed_y (S0)
		SW R0, o_speed_z (S0)
		SW R0, o_speed_h (S0)
		
		JAL set_animation
		SETU A0, @ANIM_FLAIL
		
		LUI A0, 0x5006
		JAL play_sound
		ORI A0, A0, 0xFF81
		
		MOVE A0, S0
		LI A2, @beh_grab_hitbox
		JAL spawn_object
		MOVE A1, R0
		SW V0, @_action_arg (S0)
		
		JAL angle_to_unit_vector
		LW A0, o_angle_to_mario (S0)
		
		LI.S F4, 300
		MUL.S F0, F0, F4
		MUL.S F1, F1, F4
		LW T0, @_action_arg (S0)
		S.S F0, o_x (T0)
		S.S F1, o_z (T0)
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
	
@act_grabbed:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, (g_mario + m_action)
	SETU AT, 0x392
	BNE T0, AT, @@endif_thrown
		LI T0, @act_yeet
		B @@return
		SW T0, o_state (S0)
	@@endif_thrown:
	
	LH A0, (g_mario + m_angle_yaw)
	JAL angle_to_unit_vector
	SW A0, o_face_angle_yaw (S0)
	
	LI T0, g_mario
	LI.S F6, 300
	L.S F4, m_x (T0)
	L.S F5, m_z (T0)
	MUL.S F0, F0, F6
	MUL.S F1, F1, F6
	ADD.S F4, F4, F0
	ADD.S F5, F5, F1
	S.S F4, o_x (S0)
	S.S F5, o_z (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		LUI A0, 0x5005
		JAL play_sound
		ORI A0, A0, 0xC081
		
		LI A0, g_mario
		SETU A1, 0x390
		JAL set_mario_action
		MOVE A2, R0
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
	
@act_yeet:
	.word @@state_init
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, o_angle_to_mario (S0)
	ADDIU T0, T0, 0x8000
	SHORT T0, T0
	LW T1, (g_mario + m_area)
	LW T1, 0x24 (T1)
	SH T0, 0x3A (T1)
	
	JAL move_simple
	NOP
	
	LI.S F5, 1
	L.S F4, o_speed_y (S0)
	SUB.S F4, F4, F5
	S.S F4, o_speed_y (S0)
	
	LW AT, o_timer (S0)
	SLTIU AT, 100
	BNE AT, R0, @@return
		LI T0, @act_star_ko
		SW T0, o_state (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@state_init:
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		SW R0, (g_mario + m_held_object)
		
		LUI A0, 0x5206
		JAL play_sound
		ORI A0, A0, 0xFF81
		
		LW AT, @_action_arg (S0)
		SH R0, o_active_flags (AT)
		
		LI T0, float( 75 )
		SW T0, o_speed_y (S0)
		LI T0, float( 90 )
		SW T0, o_speed_h (S0)
		
		LW AT, o_face_angle_yaw (S0)
		JAL decompose_speed
		SW AT, o_move_angle_yaw (S0)
		
		LW RA, 0x14 (SP)
		JR RA
		ADDIU SP, SP, 0x18
		
@act_star_ko:
	.word 0
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI.S F5, 0.05
	L.S F4, o_scale_x (S0)
	JAL 0x8029F430
	SUB.S F12, F4, F5
	
	LW AT, o_timer (S0)
	SLTIU AT, AT, 19
	BNE AT, R0, @@return
		LW A0, g_mario_obj_ptr
		LI A2, 0x003677B8
		JAL spawn_object
		MOVE A1, R0
		
		LI T0, ((20 << 24) | (15 << 16) | (10 << 8) | 30 )
		SW T0, o_arg0 (V0)
		
		LI T0, float( 6400 )
		SW T0, o_y (V0)
		SW R0, o_x (V0)
		SW R0, o_z (V0)
		SW R0, o_face_angle_yaw (V0)
		SW R0, o_face_angle_pitch (V0)
		SW R0, o_face_angle_roll (V0)
		
		SH R0, o_active_flags (S0)
		
		LW A0, g_mario_obj_ptr
		LI A2, @beh_win_trigger
		JAL spawn_object
		MOVE A1, R0
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

bowser_cutscene_shim:
	LW T0, g_mario_obj_ptr
	LW AT, o_timer (T0)
	SLTIU AT, 5
	BEQ AT, R0, @@skip
		LW A0, 0x8032DDCC
		LW A0, 0x24 (A0)
		J 0x8028C13C
		SETU A1, 144
	@@skip:
	JR RA
	NOP

@play_sound_on_frames:
	LHU AT, o_animation_frame (S0)
	BEQ AT, A1, @@play_sound
	NOP
	BEQ AT, A2, @@play_sound
	NOP
	JR RA
	NOP
	@@play_sound:
	J play_sound
	NOP

shockwave_shim:
	LH T8, (g_mario + m_iframes)
	BNE T8, R0, @@skip
		LW.U T8, g_mario_obj_ptr
		J 0x802AF9A8
		LW.L T8, g_mario_obj_ptr
	@@skip:
	J 0x802AF9BC
	NOP
	
mario_hit_by_shockwave:
	LI A0, g_mario
	LBU AT, m_hurt_counter (A0)
	ADDIU AT, AT, 8
	SB AT, m_hurt_counter (A0)
	SETU AT, 45
	SH AT, m_iframes (A0)
	LI A1, 0x00020338
	J set_mario_action
	MOVE A2, R0

@scale_fireball:
	LW T0, g_current_obj_ptr
	LI.S F5, 1
	L.S F4, o_scale_x (T0)
	ADD.S F4, F4, F5
	S.S F4, o_scale_x (T0)
	S.S F4, o_scale_y (T0)
	LI A1, @@fireball_hitbox
	J set_object_hitbox
	MOVE A0, T0
	
@@fireball_hitbox:
.word INT_FLAME ; interaction
.byte 6 ; downOffset
.byte 0 ; collision damage
.byte 0 ; health
.byte 0 ; loot coins
.halfword 12 ; hitbox radius
.halfword 12 ; hitbox height
.halfword 12 ; hurtbox radius
.halfword 12 ; hurtbox height

@star_crash:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI.U A0, @@star_particles
	JAL spawn_particles
	LI.L A0, @@star_particles
	
	LUI A0, 0x3044
	JAL play_sound
	ORI A0, A0, 0x0081
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@@star_particles:
.byte 0 ; behaviour argument
.byte 5 ; number of particles
.byte 26 ; modelId
.byte 0 ; vertical offset
.byte 10 ; base horizontal velocity
.byte 5 ; random horizontal velocity range
.byte 20 ; base vertical velocity
.byte 18 ; random vertical velocity range
.byte -4 ; gravity
.byte 0 ; drag
.align 4
.word float( 2.0 ) ; base size
.word float( 0.5 ) ; random size range

@timer_loop:
	LW T0, g_current_obj_ptr
	LW T0, o_timer (T0)
	SW.U T0, @bowser_fight_timer
	JR RA
	SW.L T0, @bowser_fight_timer
	
@spawn_orbs:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)
	
	SW R0, @bowser_fight_timer
	MOVE S0, R0
	
	@@loop:
		LW A0, g_mario_obj_ptr
		LI A2, @beh_orb
		LI A1, @@orb_models
		ADDU A1, A1, S0
		JAL spawn_object
		LBU A1, 0x0 (A1)
		
		SW R0, o_face_angle_pitch (V0)
		SW R0, o_face_angle_yaw (V0)
		SW R0, o_face_angle_roll (V0)
		
		SETU AT, 0x3333
		MULTU AT, S0
		ADDIU S0, S0, 1
		MFLO AT
		SLTIU T0, S0, 5
		SHORT AT, AT
		BNE T0, R0, @@loop
		SW AT, o_move_angle_yaw (V0)
		
	LUI A0, 0x3D0E
	JAL play_sound
	ORI A0, A0, 0xFF81
	
	LW S0, 0x10 (SP)
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
	@@orb_models:
	.byte 42, 43, 49, 50, 51
	.align 4

render_talisman_metre:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LHU T0, g_level_num
	SETU AT, 0x22
	BNE T0, AT, @@return
	
	LW T0, @bowser_fight_timer
	BEQ T0, R0, @@return
	
	SETU AT, 295
	MULTU T0, AT
	NOP
	MFLO T0
	SETU AT, @FIGHT_DURATION
	DIVU T0, AT

	MFLO A2
	SETU A0, 148
	ADDIU A2, A2, -1
	SETU A1, 116
	JAL create_draw_rect_command
	SETU A3, 23
	
	LI T0, @@green_bar
	SW V0, 0x0 (T0)
	SW V1, 0x4 (T0)

	LI.U A0, @@talisman_metre_dl
	JAL exec_display_list
	LI.L A0, @@talisman_metre_dl
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
.definelabel @@talisman_metre_dl, (org() - 0x80000000)
	G_RDPPIPESYNC
	G_SET_CYCLE_TYPE G_CYC_FILL
	G_SETFILLCOLOR 0xFFFFFFFF
	G_FILLRECT 144, 112, 447, 143
	G_SETFILLCOLOR 0x00010001
	G_FILLRECT 148, 116, 443, 139
	G_SETFILLCOLOR_RGBA5551 0, 15, 0, 1
	@@green_bar: G_NOOP
	G_RDPFULLSYNC
	G_SET_CYCLE_TYPE G_CYC_1CYCLE
	G_RDPFULLSYNC
	G_ENDDL
	
@homing_orb:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI.U A0, beh_bowser
	JAL get_nearest_object_with_behaviour
	LI.L A0, beh_bowser
	
	LW T0, g_current_obj_ptr
	LW T1, o_timer (T0)
	SETU AT, 21
	SUBU AT, AT, T1
	MTC1 AT, F4
	ADDIU AT, AT, -1
	MTC1 AT, F5
	CVT.S.W F4, F4
	CVT.S.W F5, F5
	LI.S F6, 1
	DIV.S F4, F5, F4
	SUB.S F4, F6, F4
	
	L.S F5, o_x (V0)
	L.S F6, o_x (T0)
	NOP
	SUB.S F5, F5, F6
	MUL.S F5, F5, F4
	ADD.S F5, F6, F5
	S.S F5, o_x (T0)
	
	LI.S F7, 200
	L.S F5, o_y (V0)
	L.S F6, o_y (T0)
	ADD.S F5, F5, F7
	SUB.S F5, F5, F6
	MUL.S F5, F5, F4
	ADD.S F5, F6, F5
	S.S F5, o_y (T0)
	
	L.S F5, o_z (V0)
	L.S F6, o_z (T0)
	NOP
	SUB.S F5, F5, F6
	MUL.S F5, F5, F4
	ADD.S F5, F6, F5
	S.S F5, o_z (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@flash_start:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	SETU A0, 1
	SETU A1, 5
	SETU A2, 0xFF
	SETU A3, 0xFF
	JAL play_transition
	SW A2, 0x10 (SP)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@flash_end:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	SETU A0, 0
	SETU A1, 15
	SETU A2, 0xFF
	SETU A3, 0xFF
	JAL play_transition
	SW A2, 0x10 (SP)
	
	LI.U A0, beh_bowser
	JAL get_nearest_object_with_behaviour
	LI.L A0, beh_bowser
	
	LI T0, @act_defeated
	SW T0, o_state (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@spawn_vivian_trigger:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_mario_obj_ptr
	LI A2, 0x003677B8
	JAL spawn_object
	MOVE A1, R0
	
	LI T0, ((19 << 24) | (15 << 16) | (10 << 8))
	SW T0, o_arg0 (V0)
	
	LI T0, float( 6400 )
	SW T0, o_y (V0)
	SW R0, o_x (V0)
	SW R0, o_z (V0)
	SW R0, o_face_angle_yaw (V0)
	SW R0, o_face_angle_pitch (V0)
	SW R0, o_face_angle_roll (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@check_end_game:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LUI A0, 0x0036
	JAL get_nearest_object_with_behaviour
	ORI A0, A0, 0x77B8
	BNE V0, R0, @@return
	
	LI.U A0, beh_vivian
	JAL get_nearest_object_with_behaviour
	LI.L A0, beh_vivian
	BNE V0, R0, @@return
	
	SETU A0, 0x1F
	SETU A1, 1
	SETU A2, 10
	JAL 0x8024A700
	MOVE A3, R0
	MOVE A0, R0
	JAL 0x802497B8
	MOVE A1, R0
	LUI T0, 0x8034
	SH R0, 0xBACC (T0)
	LHU AT, 0xC848 (T0)
	ANDI AT, AT, 0x7FFF
	SH AT, 0xC848 (T0)
	
	LW T0, g_current_obj_ptr
	SH R0, o_active_flags (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
