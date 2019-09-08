@o_wind_speed_x equ 0xF4
@o_wind_speed_z equ 0xF8
@o_target_x equ 0xFC
@o_target_z equ 0x100
@o_phase equ 0x104
@o_advance_phase equ 0x105
@o_angle_to_target equ 0x106

/* Additional Functions */
@play_sound_on_stomp equ 0x802C6CA0
@is_being_ground_pounded equ 0x802A3754

@skip_phase_zero:
.word 0

/* Behaviour Init */
beh_festive_whomp_init:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LUI AT, 0x8036
LW S0, 0x1160 (AT)

LW AT, @skip_phase_zero
SB AT, @o_phase (S0)

SB R0, @o_advance_phase (S0)

LUI AT, 0xC080
SW AT, o_gravity (S0)

ORI AT, R0, 0xA
SW AT, o_health (S0)

LI AT, @state_inactive
SW AT, o_state (S0)

ORI A1, R0, 0x46
LI A2, (beh_whomp_shadow_script-0x80000000)
JAL spawn_object
SLL A0, S0, 0x0
SW R0, 0x144 (V0)

ORI AT, R0, 0x2
SW AT, 0x180 (S0)

LUI A1, 0x3FFA
JAL scale_object
SLL A0, S0, 0x0

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

/* Behaviour Loop */
beh_festive_whomp_loop:
ADDIU SP, SP, 0xFFD8
SW RA, 0x24 (SP)
SW S0, 0x20 (SP)
SW S1, 0x1C (SP)
SW S2, 0x18 (SP)

LUI AT, 0x8036
LW S0, 0x1160 (AT)
LW S1, 0x1158 (AT)
LI S2, g_mario

; jump to state code
LW AT, o_state (S0)
JR AT
NOP

@state_inactive:
	ORI A0, R0, 0x1
	JAL 0x8029F514 ; not sure what exactly this function does, but calling it this way makes the animation stop looping
	LUI A1, 0x3F80

	LBU AT, @o_phase (S0)
	BEQ AT, R0, @endif_delete_wrapping_paper
	NOP
		@delete_wrapping_paper:
		LI A0, 0x130014E0
		JAL get_nearest_object_with_behaviour
		NOP
		BEQ V0, R0, @endif_delete_wrapping_paper
		NOP
		JAL mark_object_for_deletion
		SLL A0, V0, 0x0
		B @delete_wrapping_paper
		NOP
	@endif_delete_wrapping_paper:
	
	LUI AT, 0x443B
	MTC1 AT, F5
	L.S F4, o_distance_to_mario (S0)
	C.LE.S F4, F5
	NOP
	BC1F @end
	LI AT, @state_talking
	SW AT, o_state (S0)
	
	B @end
	NOP
	
@state_wrapped_up:
	; advance phase and talk if all wrapping paper is destroyed
	LI A0, 0x130014E0
	JAL get_nearest_object_with_behaviour
	NOP
	
	BNE V0, R0, @end
	LBU AT, @o_phase (S0)
	ADDIU AT, AT, 0x1
	SB AT, @o_phase (S0)
	
	LI AT, @state_talking
	SW AT, o_state (S0)
	
	B @end
	NOP

@state_run_to_mario:
	; turn towards Mario
	LW A0, o_angle_to_mario (S0)
	JAL turn_move_angle_towards_target_angle
	ORI A1, R0, 0x200
	LW AT, o_move_angle_yaw (S0)
	SW AT, o_face_angle_yaw (S0)
	
	; accelerate speed up to 20
	LUI AT, 0x41A0
	MTC1 AT, F5
	L.S F4, o_speed_h (S0)
	C.LT.S F4, F5
	LUI AT, 0x3F80
	BC1F @endif_accelerating
	MTC1 AT, F5
		NOP
		ADD.S F4, F4, F5
		S.S F4, o_speed_h (S0)
	@endif_accelerating:
	
	; move and animate
	JAL decompose_speed_and_move
	NOP
	JAL @play_sound_on_stomp
	NOP
	
	; transition state if close to Mario and enough time has passed
	LW T0, o_timer (S0)
	BLT T0, 0x4B, @end
	LUI AT, 0x43C8
	MTC1 AT, F5
	L.S F4, o_distance_to_mario (S0)
	C.LE.S F4, F5
	LUI T0, 0x4316 ; initial jump speed = 150
	BC1F @end
	LI AT, @state_starting_jump
	SW AT, o_state (S0)
	SW T0, o_speed_y (S0)
	SW R0, o_speed_x (S0)
	SW R0, o_speed_z (S0)
	SW R0, o_speed_h (S0)
	
	B @end
	SW R0, o_speed_h (S0)

@state_starting_jump:
	; if phase != 1, blow wind
	LBU T0, @o_phase (S0)
	ORI AT, R0, 0x1
	BEQ T0, AT, @skip_wind_1
		NOP
		JAL @blow_wind
		NOP
	@skip_wind_1:
	
	; wait for walking animation to end
	ORI A0, R0, 0x1
	JAL 0x8029F514 ; not sure what exactly this function does, but calling it this way makes the animation stop looping
	LUI A1, 0x3F80
	
	JAL is_animation_playing
	NOP
    
    BNE V0, R0, @end
	
	LI AT, @state_jumping
	SW AT, o_state (S0)
	B @end
	SW R0, o_timer (S0)
	
@state_jumping:
	; if phase != 1, blow wind
	LBU T0, @o_phase (S0)
	ORI AT, R0, 0x1
	BEQ T0, AT, @skip_wind_2
		NOP
		JAL @blow_wind
		NOP
	@skip_wind_2:
	
	; wait 8 frames before jumping
	LW T0, o_timer (S0)
	ORI AT, R0, 0x8
	BLE T0, AT, @end
	NOP
    
	; become intangible
	LUI AT, 0x8000
	SW AT, o_intangibility_timer (S0)

	; move and apply gravity
	MTC1 R0, F6
	L.S F4, o_speed_y (S0)
	L.S F5, o_y (S0)
	ADD.S F5, F4, F5
	S.S F5, o_y (S0)
	L.S F5, o_gravity (S0)
	ADD.S F4, F4, F5
	S.S F4, o_speed_y (S0)
	
	; transition state if speed <= 0
	C.LE.S F4, F6
	BC1F @end_skip_collision
	LI AT, @state_falling
	SW AT, o_state (S0)
	B @end_skip_collision
	SW R0, o_intangibility_timer (S0)

@state_falling:
	; if phase != 1, blow wind
	LBU T0, @o_phase (S0)
	ORI AT, R0, 0x1
	BEQ T0, AT, @skip_wind_3
		NOP
		JAL @blow_wind
		NOP
	@skip_wind_3:
	
	; slowly rotate to face Mario
	LW AT, o_face_angle_yaw (S0)
	SW AT, o_move_angle_yaw (S0)
	LW A0, o_angle_to_mario (S0)
	JAL turn_move_angle_towards_target_angle
	ORI A1, R0, 0x100
	LW AT, o_move_angle_yaw (S0)
	SW AT, o_face_angle_yaw (S0)
	
	; pitch forwards
	LW T0, o_face_angle_pitch (S0)
	ORI T1, R0, 0x4000
	BGE T0, T1, @endif_pitch_forwards
	SW T1, o_face_angle_pitch (S0)
		ADDIU T0, T0, 0x200
		SW T0, o_face_angle_pitch (S0)
	@endif_pitch_forwards:

	; move horizontally towards Mario
	JAL sin_u16
	LW A0, o_face_angle_yaw (S0)
	S.S F0, 0x14 (SP)
	JAL cos_u16
	LW A0, o_face_angle_yaw (S0)
	LUI AT, 0x43D7
	MTC1 AT, F4
	L.S F1, 0x14 (SP)
	MUL.S F0, F0, F4
	MUL.S F1, F1, F4
	L.S F4, o_x (S0)
	L.S F5, o_z (S0)
	ADD.S F6, F4, F1
	ADD.S F7, F5, F0
	L.S F4, m_x (S2)
	L.S F5, m_z (S2)
	SUB.S F14, F4, F6
	JAL atan2s
	SUB.S F12, F5, F7
	SLL V0, V0, 0x10
	SRA V0, V0, 0x10
	SW V0, o_move_angle_yaw (S0)
	LUI AT, 0x41A0
	JAL decompose_speed_and_move
	SW AT, o_speed_h (S0)
	
	; fall and apply gravity
	LUI AT, 0xC28C
	MTC1 AT, F6
	L.S F4, o_speed_y (S0)
	L.S F5, o_y (S0)
	ADD.S F5, F4, F5
	C.LE.S F4, F6
	S.S F5, o_y (S0)
	BC1T @at_terminal_velocity
	L.S F5, o_gravity (S0)
		ADD.S F4, F4, F5
		S.S F4, o_speed_y (S0)
		B @endif_term_vel
		NOP
	@at_terminal_velocity:
		S.S F6, o_speed_y (S0)
	@endif_term_vel:
	
	; bring Mario down if colliding with him
	JAL pull_mario_down
	NOP
	
	; if in phase 3, drop minions
	LBU T0, @o_phase (S0)
	ORI AT, R0, 0x3
	BNE T0, AT, @end_spawn_minion
	LI AT, 0x46034000
		MTC1 AT, F6
		L.S F4, o_y (S0)
		L.S F5, o_home_y (S0)
		SUB.S F4, F4, F5
		C.LE.S F4, F6
		NOP
		BC1T @end_spawn_minion
		LW T0, o_timer (S0)
			ORI AT, R0, 0x1E
			DIVU T0, AT
			MFHI T0
			NOP
			BNE T0, R0, @end_spawn_minion
				SLL A0, S0, 0x0
				LI A2, (beh_whomp_minion_script-0x80000000)
				JAL spawn_object
				ORI A1, R0, 0x67
	@end_spawn_minion:

	; transition state if hit ground
	L.S F4, o_y (S0)
	L.S F5, o_home_y (S0)
	C.LE.S F4, F5
	NOP
	BC1F @end
	NOP
	LW T0, m_ceiling_ptr (S2)
	BEQ T0, R0, @faceplant
	NOP
	LW T0, t_object (T0)
	BNE T0, S0, @faceplant
	ORI AT, 0xC
	SB AT, m_hurt_counter (S2)
	LUI A0, 0x200A
	JAL play_sound_2
	ORI A0, A0, 0xC081
	
	@faceplant:
	LI AT, @state_faceplanted
	SW AT, o_state (S0)
	SW R0, o_speed_y (S0)
	S.S F5, o_y (S0)
	SW R0, o_speed_x (S0)
	SW R0, o_speed_z (S0)
	SW R0, o_speed_h (S0)
	
	; play sound and shake screen
	JAL shake_screen
	ORI A0, R0, 0x1
	LUI A0, 0x3044
	JAL play_sound_2
	ORI A0, A0, 0xC081
	
	SB R0, @o_advance_phase (S0)
	B @end
	SW R0, o_timer (S0)

@state_faceplanted:
	JAL @is_being_ground_pounded
	NOP
	BEQ V0, R0, @not_ground_pounded
	LW T0, o_health (S0)
		ADDIU T0, T0, 0xFFFF
		SW T0, o_health (S0)
		
		; advance phase is health is even
		ANDI T1, T0, 0x1
		BNE T1, R0, @endif_advance_phase
			LBU T1, @o_phase (S0)
			ADDIU T1, T1, 0x1
			SB T1, @o_phase (S0)
			SB T1, @o_advance_phase (S0)
		@endif_advance_phase:
		
		JAL update_healthbar
		SLL A0, T0, 0x0
		
		LUI A0, 0x935A
		JAL play_sound_2
		ORI A0, A0, 0xC081
		
		LUI A0, 0x5147
		JAL play_sound_2
		ORI A0, A0, 0xC081
		
		LI AT, @state_getting_up
		B @end
		SW AT, o_state (S0)
		
	@not_ground_pounded:
	LW T0, o_timer (S0)
	ORI AT, R0, 0x4B
	BNE T0, AT, @end
	LI AT, @state_getting_up
	B @end
	SW AT, o_state (S0)

@state_getting_up:
	; set speed to make Mario slide off
	LW AT, o_face_angle_yaw (S0)
	SW AT, o_move_angle_yaw (S0)
	LUI T0, 0xC1C8
	JAL decompose_speed
	SW T0, o_speed_h (S0)
	
	; get up
	LW T0, o_face_angle_pitch (S0)
	BLEZ T0, @back_upright
	ADDIU T0, T0, 0xFE80
		B @end
		SW T0, o_face_angle_pitch (S0)
		
	; change state when upright
	@back_upright:
	SW R0, o_face_angle_pitch (S0)
	SW R0, o_speed_h (S0)
	SW R0, o_speed_x (S0)
	SW R0, o_speed_z (S0)
	LBU AT, @o_advance_phase (S0)
	BEQ AT, R0, @loop_phase
		LI AT, @state_talking
		SW AT, o_state (S0)
		B @end
		SB R0, @o_advance_phase (S0)

@state_set_target:
	LBU T0, @o_phase (S0)
	ORI AT, R0, 0x4
	BNE T0, AT, @endif_start_phase_4
		; set target to the center of the arena
		LW AT, o_home_x (S0)
		SW AT, @o_target_x (S0)
		LW AT, o_home_z (S0)
		JAL obj_angle_to_home
		SW AT, @o_target_z (S0)
		SH V0, @o_angle_to_target (S0)
		LW AT, o_face_angle_yaw (S0)
		SW AT, o_move_angle_yaw (S0)
		LI AT, @state_turning_to_target
		B @end
		SW AT, o_state (S0)
	@endif_start_phase_4:
	; set target to be the opposite side of the stage as Mario
	L.S F4, m_x (S2)
	L.S F5, m_z (S2)
	L.S F6, o_home_x (S0)
	L.S F7, o_home_z (S0)
	SUB.S F4, F6, F4
	SUB.S F5, F7, F5
	MUL.S F6, F4, F4
	MUL.S F7, F5, F5
	ADD.S F12, F6, F7
	S.S F4, 0x14 (SP)
	JAL sqrt
	S.S F5, 0x10 (SP)
	L.S F5, 0x10 (SP)
	L.S F4, 0x14 (SP)
	LUI AT, 0x449C
	MTC1 AT, F6
	DIV.S F4, F4, F0
	DIV.S F5, F5, F0
	MUL.S F4, F4, F6
	MUL.S F5, F5, F6
	L.S F6, o_home_x (S0)
	L.S F7, o_home_z (S0)
	ADD.S F4, F4, F6
	ADD.S F5, F5, F7
	S.S F4, @o_target_x (S0)
	S.S F5, @o_target_z (S0)
	L.S F6, o_x (S0)
	L.S F7, o_z (S0)
	SUB.S F14, F4, F6
	JAL atan2s
	SUB.S F12, F5, F7
	SH V0, @o_angle_to_target (S0)
	LW AT, o_face_angle_yaw (S0)
	SW AT, o_move_angle_yaw (S0)
	LI AT, @state_turning_to_target
	B @end
	SW AT, o_state (S0)

@state_turning_to_target:
	JAL @play_sound_on_stomp
	NOP

	LH A0, @o_angle_to_target (S0)
	JAL turn_move_angle_towards_target_angle
	ORI A1, R0, 0x280
	LW AT, o_move_angle_yaw (S0)
	SW AT, o_face_angle_yaw (S0)
	
	BEQ V0, R0, @end
		LI AT, @state_running_to_target
		SW AT, o_state (S0)
		SW R0, o_timer (S0)
		
	SW R0, o_speed_x (S0)
	SW R0, o_speed_y (S0)
	B @end
	SW R0, o_speed_h (S0)

@state_running_to_target:
	; accelerate speed up to 20
	LUI AT, 0x41A0
	MTC1 AT, F5
	L.S F4, o_speed_h (S0)
	C.LT.S F4, F5
	LUI AT, 0x3F80
	BC1F @endif_accelerating_2
	MTC1 AT, F5
		NOP
		ADD.S F4, F4, F5
		S.S F4, o_speed_h (S0)
	@endif_accelerating_2:
	
	JAL decompose_speed_and_move
	NOP
	JAL @play_sound_on_stomp
	NOP
	
	; if near the target, transition phase
	LUI AT, 0x43C8
	MTC1 AT, F7
	L.S F5, @o_target_x (S0)
	L.S F4, o_x (S0)
	SUB.S F4, F5, F4
	MUL.S F4, F4, F4
	L.S F6, @o_target_z (S0)
	L.S F5, o_z (S0)
	SUB.S F5, F6, F5
	MUL.S F5, F5
	ADD.S F4, F4, F5
	
	C.LE.S F4, F7
	NOP
	BC1F @endif_near_target
		@near_target:
		LW AT, @o_target_x (S0)
		SW AT, o_x (S0)
		LW AT, @o_target_z (S0)
		SW AT, o_z (S0)
		
		LBU T0, @o_phase (S0)
		ORI AT, R0, 0x4
		BNE T0, AT, @dramatic_turn
			LW AT, o_home_x (S0)
			SW AT, o_x (S0)
			LW AT, o_home_z (S0)
			SW AT, o_z (S0)
			LI AT, @state_spinning
			SW AT, o_state (S0)
			SW R0, o_speed_x (S0)
			SW R0, o_speed_y (S0)
			B @end
			SW T0, o_timer (S0)
	
		@dramatic_turn:
		L.S F4, o_x (S0)
		L.S F5, o_home_x (S0)
		SUB.S F14, F5, F4
		L.S F4, o_z (S0)
		L.S F5, o_home_z (S0)
		JAL atan2s
		SUB.S F12, F5, F4
		SLL V0, V0, 0x10
		SRA V0, V0, 0x10
		SH V0, @o_angle_to_target (S0)
		
		SW R0, o_speed_x (S0)
		SW R0, o_speed_y (S0)
		LI AT, @state_turning_around
		B @end
		SW AT, o_state (S0)
	@endif_near_target:
	
	; timeout in case something goes wrong and the target is missed
	LW T1, o_timer (S0)
	ORI AT, R0, 0x96
	BEQ T1, AT, @near_target
	NOP
	B @end
	NOP

@state_turning_around:
	LH A0, @o_angle_to_target (S0)
	JAL turn_move_angle_towards_target_angle
	ORI A1, R0, 0x300
	LW AT, o_move_angle_yaw (S0)
	SW AT, o_face_angle_yaw (S0)
	
	BEQ V0, R0, @end
		LI AT, @state_waiting
		SW AT, o_state (S0)
		SW R0, o_timer (S0)
		JAL cos_u16
		LW A0, o_face_angle_yaw (S0)
		S.S F0, 0x14 (SP)
		JAL sin_u16
		LW A0, o_face_angle_yaw (S0)
		LUI AT, 0x41C0 ; wind speed = 24
		MTC1 AT, F4
		L.S F1, 0x14 (SP)
		MUL.S F0, F0, F4
		MUL.S F1, F1, F4
		S.S F0, @o_wind_speed_x (S0)
		S.S F1, @o_wind_speed_z (S0)
		
		B @end
		NOP

@state_waiting:
	; blow wind
	JAL @blow_wind
	NOP
	
	; stop animation
	ORI A0, R0, 0x1
	JAL 0x8029F514 ; not sure what exactly this function does, but calling it this way makes the animation stop looping
	LUI A1, 0x3F80
	
	; breath fire on frame 30. In phase 3 also breath fire on frames 75
	LW T0, o_timer (S0)
	LBU T1, @o_phase (S0)
	ORI AT, R0, 0x3
	BNE T1, AT, @endif_phase_3_fire
		ORI AT, R0, 0x4B
		BEQ T0, AT, @breath_fire
	@endif_phase_3_fire:
	ORI AT, R0, 0x1E
	BNE T0, AT, @endif_breath_fire
		@breath_fire:
		SLL A0, S0, 0x0
		LI A2, 0x13001984
		JAL spawn_object
		ORI A1, R0, 0xCB
		LUI AT, 0x4397
		MTC1 AT, F5
		L.S F4, o_y (S0)
		ADD.S F4, F4, F5
		S.S F4, o_y (V0)
		SW V0, 0x14 (SP)
		JAL angle_to_unit_vector
		LW A0, o_face_angle_yaw (S0)
		LUI AT, 0x4348
		MTC1 AT, F6
		LW V0, 0x14 (SP)
		L.S F4, o_x (S0)
		L.S F5, o_z (S0)
		MUL.S F0, F0, F6
		MUL.S F1, F1, F6
		ADD.S F4, F4, F0
		ADD.S F5, F5, F1
		S.S F4, o_x (V0)
		S.S F5, o_z (V0)
		LUI AT, 0x41F0
		SW AT, o_speed_h (V0)
		ORI AT, R0, 0x1
		SW AT, 0x144 (V0)
	@endif_breath_fire:
	
	LW T0, o_timer (S0)
	ORI AT, R0, 0x5A
	BNE T0, AT, @end
		LI AT, @state_super_jump
		SW AT, o_state (S0)
		LUI AT, 0x4316 ; initial jump speed = 150
		SW AT, o_speed_y (S0)
		B @end
		SW R0, o_timer (S0)

@state_spinning:
	ORI A0, R0, 0x1
	JAL 0x8029F514 ; not sure what exactly this function does, but calling it this way makes the animation stop looping
	LUI A1, 0x3F80
	
	LW T0, o_face_angle_yaw (S0)
	SLL T0, T0, 0x10
	LW AT, o_timer (S0)
	SLL AT, AT, 0x14
	ADDU T0, T0, AT
	SRA T0, T0, 0x10
	SW T0, o_face_angle_yaw (S0)
	
	; offset forwards 100 pixels
	JAL angle_to_unit_vector
	SLL A0, T0, 0x0
	LUI AT, 0x42C8
	MTC1 AT, F6
	L.S F4, o_home_x (S0)
	L.S F5, o_home_z (S0)
	MUL.S F0, F0, F6
	MUL.S F1, F1, F6
	ADD.S F4, F4, F0
	ADD.S F5, F5, F1
	S.S F4, o_x (S0)
	S.S F5, o_z (S0)
	
	; pull Mario in
	LHU AT, g_is_invulnerable
	BNE AT, R0, @endif_suction
	NOP
		JAL angle_to_unit_vector
		LW A0, o_angle_to_mario (S0)
		LW AT, o_timer (S0)
		MTC1 AT, F4
		LI AT, 0x41666666
		MTC1 AT, F5
		CVT.S.W F4, F4
		DIV.S F4, F4, F5
		MUL.S F0, F0, F4
		MUL.S F1, F1, F4
		L.S F4, m_x (S2)
		L.S F5, m_z (S2)
		SUB.S F4, F4, F0
		SUB.S F5, F5, F1
		S.S F4, m_x (S2)
		S.S F5, m_z (S2)
	@endif_suction:
	
	LW T0, o_timer (S0)
	BEQ T0, R0, @endif_play_swoosh_sound
	ORI T1, R0, 0x73
	BLT T0, T1, @endif_swoosh_timer
	ORI T2, R0, 0x73
		ORI T1, R0, 0xE6
		BLT T0, T1, @endif_swoosh_timer
		ORI T2, R0, 0x14
			ORI T1, R0, 0x15A
			BLT T0, T1, @endif_swoosh_timer
			ORI T2, R0, 0xA
				ORI T1, R0, 0x1CD
				BLT T0, T1, @endif_swoosh_timer
				ORI T2, R0, 0x8
					ORI T2, R0, 0x4
	@endif_swoosh_timer:
	DIVU T0, T2
	MFHI AT
	NOP
	BNE AT, R0, @endif_play_swoosh_sound
		LUI A0, 0x5007
		JAL play_sound_2
		ORI A0, A0, 0x8081
	@endif_play_swoosh_sound:
	
	ORI AT, R0, 0x240
	BNE T0, AT, @endif_done_spinning
	NOP
		; spawn dust clouds
		SW S3, 0x14 (SP)
		SLL S3, R0, 0x0
		@spawn_dust_loop:
			ORI A1, R0, 0x96
			LI A2, 0x13003558
			JAL spawn_object
			SLL A0, S0, 0x0
			
			SLL AT, S3, 0x10
			SRA AT, AT, 0x10
			SW AT, o_move_angle_yaw (V0)
			SW AT, o_face_angle_yaw (V0)
			
			LUI AT, 0x4220
			SW AT, o_speed_h (V0)
			
			ADDIU S3, S3, 0x1000
			ORI AT, R0, 0xF000
		BNE S3, AT, @spawn_dust_loop
		
		LI AT, @state_super_jump
		SW AT, o_state (S0)
		B @end
		LW S3, 0x14 (SP)
	@endif_done_spinning:
	
	ORI T1, R0, 0xD0
	BLT T0, T1, @end
	NOP
		; knockback Mario if within 300 units
		LUI AT, 0x4396
		MTC1 AT, F5
		L.S F4, o_distance_to_mario (S0)
		C.LE.S F4, F5
		NOP
		BC1F @end_skip_collision
			SLL A0, S2, 0x0
			JAL take_damage_and_knockback
			SLL A1, S0, 0x0
			B @end_skip_collision
			SW R0, o_interaction_status (S0)
			
@state_super_jump:
	LBU T0, @o_phase (S0)
	ORI AT, R0, 0x4
	BEQ T0, AT, @skip_wind_4
		NOP
		JAL @blow_wind
		NOP
	@skip_wind_4:

	LUI AT, 0x8000
	SW AT, o_intangibility_timer (S0)

	LUI AT, 0x4316 ; jump speed = 150
	SW AT, o_speed_y (S0)
	MTC1 AT, F5
	L.S F4, o_y (S0)
	ADD.S F4, F4, F5
	S.S F4, o_y (S0)
	
	LBU T0, @o_phase (S0)
	ORI AT, R0, 0x4
	BEQ T0, AT, @ultra_jump
	ORI AT, R0, 0x3
		BNE T0, AT, @endif_phase_3_jump
		ORI AT, R0, 0x30
			ORI AT, R0, 0x6C
		@endif_phase_3_jump:
		LW T0, o_timer (S0)
		BNE T0, AT, @end
			LI AT, @state_jumping
			B @end
			SW AT, o_state (S0)
	@ultra_jump:
	LW T0, o_timer (S0)
	ORI T1, R0, 0x6E
	BLT T0, T1, @endif_superjump_peak
	NOP
		JAL @meteor_swarm
		NOP
	@endif_superjump_peak:
	ORI AT, R0, 0xAA
	BNE T0, AT, @end
		LI AT, @state_super_fall
		SW AT, o_state (S0)
		SW R0, o_speed_y (S0)
		B @end
		SW R0, o_timer (S0)

@state_super_fall:
	L.S F4, o_y (S0)
	L.S F5, o_home_y (S0)
	LI AT, 0x46034000
	MTC1 AT, F6
	SUB.S F4, F4, F5
	C.LE.S F4, F6
	NOP
	BC1T @endif_should_spawn_meteors
	NOP
		JAL @meteor_swarm
		NOP
	@endif_should_spawn_meteors:
	
	; slowly rotate to face Mario
	LW AT, o_face_angle_yaw (S0)
	SW AT, o_move_angle_yaw (S0)
	LW A0, o_angle_to_mario (S0)
	JAL turn_move_angle_towards_target_angle
	ORI A1, R0, 0xC0
	LW AT, o_move_angle_yaw (S0)
	SW AT, o_face_angle_yaw (S0)
	
	; pitch forwards
	ORI AT, R0, 0x4000
	SW AT, o_face_angle_pitch (S0)

	; move horizontally towards Mario
	JAL angle_to_unit_vector
	LW A0, o_face_angle_yaw (S0)
	LUI AT, 0x43D7
	MTC1 AT, F6
	L.S F4, o_x (S0)
	L.S F5, o_z (S0)
	MUL.S F0, F0, F6
	MUL.S F1, F1, F6
	ADD.S F0, F4, F0
	ADD.S F1, F5, F1
	
	L.S F4, m_x (S2)
	L.S F5, m_z (S2)
	SUB.S F14, F4, F0
	JAL atan2s
	SUB.S F12, F5, F1
	
	SW V0, o_move_angle_yaw (S0)
	LUI AT, 0x4170
	JAL decompose_speed_and_move
	SW AT, o_speed_h (S0)
	
	; fall
	LUI AT, 0xC28C
	MTC1 AT, F5
	SW AT, o_speed_y (S0)
	L.S F4, o_y (S0)
	ADD.S F4, F4, F5
	S.S F4, o_y (S0)
	
	; if on the ground, transition state
	L.S F5, o_home_y (S0)
	C.LE.S F4, F5
	NOP
	BC1F @endif_final_crash
		LI AT, @state_super_faceplant
		SW AT, o_state (S0)
		S.S F5, o_y (S0)
		SW R0, o_speed_y (S0)
		SW R0, o_speed_h (S0)
		SW R0, o_speed_x (S0)
		SW R0, o_speed_z (S0)
		SW R0, o_timer (S0)
		SW R0, o_health (S0)
		
		JAL update_healthbar
		SLL A0, R0, 0x0
		
		LUI A0, 0x905A
		JAL play_sound_2
		ORI A0, A0, 0xC081
		
		LUI A0, 0x302F
		JAL play_sound_2
		ORI A0, A0, 0xC081
		
		; particle effect
		ORI A0, R0, 0x28
		ORI A1, R0, 0x8A
		LUI A2, 0x40C0
		JAL 0x802AE0CC
		ORI A3, R0, 0x4

		; stop music
		ORI A0, R0, 0x0
		SLL A1, R0, 0x0
		JAL set_music
		SLL A2, R0, 0x0
		
		LW T0, @o_phase (S0)
		ADDIU T0, T0, 0x1
		SW T0, @o_phase (S0)
		
		B @end
		NOP
	@endif_final_crash:
	
	; bring Mario down if colliding with him
	JAL pull_mario_down
	NOP
	
	B @end
	NOP

@state_super_faceplant:
	LW AT, o_timer (S0)
	SLTI AT, AT, 0x1F
	BEQ AT, R0, @endif_mega_shake
	NOP
		JAL shake_screen
		ORI A0, R0, 0x1
	@endif_mega_shake:
	
	; Play sound when ground pounded
	JAL @is_being_ground_pounded
	NOP
	BEQ V0, R0, @not_being_bullied
		LUI A0, 0x905A
		JAL play_sound_2
		ORI A0, A0, 0xC001
	@not_being_bullied:

	LW T0, m_action (S2)
	LI AT, 0x00020339
	BNE T0, AT, @endif_mario_megasquished
	NOP
		SW R0, m_health (S2)
		
		; FIXME: this is triggering a GAME OGRE
		
		; trigger death warp
		SLL A0, S2, 0x0
		JAL level_trigger_warp
		ORI A1, R0, 0x12
		
		; set Mario's state
		SLL A0, S2, 0x0
		ORI A1, R0, 0x1300
		JAL set_mario_action
		SLL A2, R0, 0x0
	@endif_mario_megasquished:
	
	LW T0, o_timer (S0)
	ORI AT, R0, 0x3C
	BNE T0, AT, @end
		LBU AT, @o_phase (S0)
		ADDIU AT, AT, 0x1
		SB AT, @o_phase (S0)
		LI AT, @state_talking
		SW AT, o_state (S0)
		
	B @end
	NOP

@state_dead:
	; Play sound when ground pounded
	JAL @is_being_ground_pounded
	NOP
	BEQ V0, R0, @end
	
	LUI A0, 0x905A
	JAL play_sound_2
	ORI A0, A0, 0xC001
	
	B @end
	NOP
	
@state_talking:
	ORI A0, R0, 0x2
	ORI A1, R0, 0x1
	ORI A2, R0, 0xA2
	ORI A3, R0, 0x7B
	LBU T0, @o_phase (S0)
	BEQ T0, R0, @endif_phase_zero
		ORI T1, R0, 0x1
		SW T1, @skip_phase_zero
	@endif_phase_zero:
	
	JAL obj_show_dialog
	ADDU A3, A3, T0
	BEQ V0, R0, @end
	NOP
		LBU T0, @o_phase (S0)
		ORI AT, R0, 0x1
		BNE T0, AT, @endif_phase_one_start
		NOP
			LW A0, o_health (S0)
			JAL show_healthbar
			SLL A1, A0, 0x0
			
			ORI A0, R0, 0x0
			ORI A1, R0, 0x7
			JAL set_music
			SLL A2, R0, 0x0
		@endif_phase_one_start:
		
		LW T0, o_health (S0)
		BNE T0, R0, @loop_phase
			; spawn star
			LUI AT, 0x4396
			MTC1 AT, F4
			L.S F14, o_home_y (S0)
			ADD.S F14, F14, F4
			L.S F12, o_home_x (S0)
			JAL spawn_star
			LW A2, o_home_z (S0)
			B @set_state
			NOP
		
		@loop_phase:
		LBU AT, @o_phase (S0)
		BEQ AT, R0, @set_state
		NOP
			JAL set_animation
			SLL A0, R0, 0x0
			SW R0, o_timer (S0)
			
			LUI A1, 0x4000
			JAL scale_object
			SLL A0, S0, 0x0
		
		@set_state:
		LI T0, @state_loop_table
		LBU AT, @o_phase (S0)
		SLL AT, AT, 0x2
		ADDU T0, T0, AT
		LW T0, 0x0 (T0)
		B @end
		SW T0, o_state (S0)

@end:
JAL process_collision
NOP

@end_skip_collision:
SW R0, 0x118 (S0)

; Prevent the whomp from leaving the area (must be within 1400 units of home)
JAL obj_xz_dist_from_home
NOP
LUI AT, 0x44AF
MTC1 AT, F4
NOP
C.LE.S F0, F4
NOP
BC1T @endif_far_from_home
	L.S F12, o_home_x (S0)
	L.S F13, o_home_z (S0)
	JAL unit_vector_from_object_to_point_2d
	SLL A0, S0, 0x0
	LUI AT, 0x44AF
	MTC1 AT, F6
	L.S F4, o_home_x (S0)
	L.S F5, o_home_z (S0)
	MUL.S F0, F0, F6
	MUL.S F1, F1, F6
	SUB.S F4, F4, F0
	SUB.S F5, F5, F1
	S.S F4, o_x (S0)
	S.S F5, o_z (S0)
@endif_far_from_home:

LW RA, 0x24 (SP)
LW S0, 0x20 (SP)
LW S1, 0x1C (SP)
LW S2, 0x18 (SP)
JR RA
ADDIU SP, SP, 0x28

/* Blow Wind Helper Function */
@blow_wind:
LW T0, m_action (S2)
LI AT, 0x008008A9
BEQ T0, AT, @play_wind_sound

; TODO: wind particles

L.S F4, m_x (S2)
L.S F5, m_z (S2)
L.S F6, @o_wind_speed_x (S0)
L.S F7, @o_wind_speed_z (S0)
ADD.S F4, F4, F6
ADD.S F5, F5, F7
S.S F4, m_x (S2)
S.S F5, m_z (S2)
@play_wind_sound:
LUI A0, 0x4010
ORI A0, A0, 0x8001
J set_sound
SLL A1, S1, 0x0

@meteor_swarm:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LW AT, o_timer (S0)
ANDI AT, AT, 0x1
BEQ AT, R0, @meteor_swarm_return
	ORI A1, R0, 0xB4
	LI A2, (beh_meteor_script-0x80000000)
	JAL spawn_object
	SLL A0, S0, 0x0

@meteor_swarm_return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@state_loop_table:
.word @state_wrapped_up
.word @state_run_to_mario
.word @state_set_target
.word @state_set_target
.word @state_set_target
.word @state_dead

/* Explode Whomp Helper Function */
explode_whomp:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

JAL play_sound_2
NOP

L.S F4, o_scale_y (S0)
LUI AT, 0x42C8
MTC1 AT, F5
SLL A0, R0, 0x0
MUL.S F4, F4, F5
MFC1 A2, F4
JAL 0x802AAE8C
SLL A1, R0, 0x0

ORI A0, R0, 0x14
ORI A1, R0, 0x8A
LUI A2, 0x4040
JAL 0x802AE0CC
ORI A3, R0, 0x4

JAL mark_object_for_deletion
SLL A0, S0, 0x0

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

/* Midair Crush Helper Function */
; prevent Mario from being able to phase through the falling whomp by
; ground pounding (drag Mario down with the whomp!)
pull_mario_down:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LW T0, g_current_obj_ptr
LI T1, g_mario

LW T2, m_ceiling_ptr (T1)
BEQ T2, R0, @crush_helper_return
NOP
	LW T2, t_object (T2)
	BNE T2, T0, @crush_helper_return
		LUI AT, 0x4320
		MTC1 AT, F6
		L.S F4, m_y (T1)
		L.S F5, o_y (T0)
		SUB.S F4, F5, F4
		C.LE.S F4, F6
		LUI AT, 0x428C
		MTC1 AT, F4
		BC1F @crush_helper_return
		SUB.S F4, F5, F4
		S.S F4, m_y (T1)
		L.S F5, o_home_y (T0)
		C.LT.S F4, F5
		NOP
		BC1F @crush_helper_return
		NOP
		S.S F5, m_y (T1)
@crush_helper_return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
