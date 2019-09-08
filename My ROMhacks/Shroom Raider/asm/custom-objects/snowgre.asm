; Snowgre properties
@_head equ 0xF4
@_left_hand equ 0xF8
@_right_hand equ 0xFC
@_next_action equ 0x100 ; for non-hop actions
@_next_attack equ 0x104 ; attack after ppHop
@_wait_time equ 0x108
@_hop_counter equ 0x10A
@_flash_counter equ 0x10B

; Claw properties
@_current_dist equ 0xF4
@_target_dist equ 0xF8
@_current_angle equ 0xFC
@_target_angle equ 0xFE
@_current_rel_y equ 0x100
@_target_rel_y equ 0x104
@_current_rel_yaw equ 0x108
@_target_rel_yaw equ 0x10A
@_target_pitch equ 0x10C
@_target_roll equ 0x10E

.macro @make_visible, reg
	LHU AT, o_gfx_flags (reg)
	ANDI AT, AT, 0xFFEF
	SH AT, o_gfx_flags (reg)
.endmacro

.macro @make_hidden, reg
	LHU AT, o_gfx_flags (reg)
	ORI AT, AT, 0x10
	SH AT, o_gfx_flags (reg)
.endmacro

.macro @shortify, reg
	SLL reg, reg, 0x10
	SRA reg, reg, 0x10
.endmacro

; Constants (F16 means 16-bit float loaded with LUI)
@AGGRO_RADIUS_F16 equ 0x452C ; 2752
@RISING_SPEED_F16 equ 0x4170 ; 15
@SINKING_SPEED_F16 equ 0x4100 ; 8
@HOP_SPEED_H_F16 equ 0x4248 ; 50
@HOP_SPEED_V_F16 equ 0x4270 ; 60
@HOP_DELAY_U16 equ 10
@TURN_SPEED_U16 equ 0x800
@NUM_HOPS_U8 equ 4


.definelabel beh_snowgre_impl, (org()-0x80000000)
; BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE | OBJ_STORE_ANGLE_TO_MARIO
BHV_SET_FLOAT o_render_distance, 7000
BHV_DROP_TO_FLOOR
BHV_STORE_HOME
BHV_ADD_FLOAT o_y, -1024
BHV_SET_WORD o_state, @action_sinking
BHV_SET_HITBOX 175, 620, 0
BHV_SET_FLOAT o_wall_hitbox_radius, 200
BHV_SET_INTERACTION 0x00000008
BHV_SET_FLOAT o_gravity, -5
BHV_SET_INT o_health, 3
BHV_SET_INT o_collision_damage, 3
BHV_EXEC @snowgre_init
BHV_LOOP_BEGIN
	BHV_EXEC @snowgre_loop
BHV_LOOP_END

@beh_snowgre_head:
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_FLOAT o_render_distance, 7000
BHV_LOOP_BEGIN
	BHV_EXEC @snowgre_head_loop
BHV_LOOP_END

@beh_snowgre_claw:
BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_FLOAT o_render_distance, 7000
BHV_SET_INT o_opacity, 0xCC
BHV_SET_HITBOX 200, 50, 25
BHV_SET_FLOAT o_wall_hitbox_radius, 200
BHV_SET_INTERACTION 0
BHV_SET_INT o_collision_damage, 6
BHV_SET_INT o_intangibility_timer, 0
BHV_LOOP_BEGIN
	BHV_EXEC @snowgre_claw_loop
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END


@beh_icicle_missile:
BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_AUTO_MOVE_XZ
BHV_SET_INTERACTION 0x00000008
BHV_SET_INT o_collision_damage, 6
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_HITBOX 75, 75, 75
BHV_SET_INT o_face_angle_roll, 0x4000
BHV_SET_FLOAT o_speed_h, 60
BHV_SET_INT o_face_angle_pitch, 0
BHV_EXEC @set_missile_angle
BHV_REPEAT_BEGIN 120
	BHV_SET_INT o_interaction_status, 0
	BHV_ADD_INT o_face_angle_roll, 0x800
BHV_REPEAT_END
BHV_DELETE
BHV_END

@beh_frost_breath:
BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_ADD_FLOAT o_y, 72
BHV_BILLBOARD
BHV_EXEC @frost_breath_init
BHV_REPEAT_BEGIN 55
	BHV_ADD_INT o_animation_state, 1
	BHV_EXEC move_simple
	BHV_EXEC @frost_breath_loop
BHV_REPEAT_END
BHV_DELETE
BHV_END

@snowgre_init:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LI A2, (@beh_snowgre_head-0x80000000)
SETU A1, 0x4D
JAL spawn_object
MOVE A0, S0
SW V0, @_head (S0)

LI A2, (@beh_snowgre_claw-0x80000000)
SETU A1, 0x4E
JAL spawn_object
MOVE A0, S0
SW V0, @_left_hand (S0)

LI A2, (@beh_snowgre_claw-0x80000000)
SETU A1, 0x4E
JAL spawn_object
MOVE A0, S0
SW V0, @_right_hand (S0)

JAL @reset_claw_positions
NOP

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@snowgre_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LW T0, o_state (S0)
LI T1, @action_hibernating
BEQ T0, T1, @@endif_snowgre_kill_plane
LI T1, @action_sinking
BEQ T0, T1, @@endif_snowgre_kill_plane
LI T0, g_mario
L.S F4, m_y (T0)
LUI AT, 0x4400
MTC1 AT, F6
L.S F5, o_home_y (S0)
SUB.S F5, F5, F6
C.LT.S F4, F5
NOP
BC1F @@endif_snowgre_kill_plane
NOP
	JAL force_mario_void_out
	NOP
@@endif_snowgre_kill_plane:

LW T0, o_health (S0)
BEQ T0, R0, @@endif_flashing_red
LBU T0, @_flash_counter (S0)
BEQ T0, R0, @@endif_flashing_red
	ADDIU T0, T0, 0xFFFF
	SB T0, @_flash_counter (S0)
	LI.U A0, ogre_lighting
	JAL segmented_to_virtual
	LI.L A0, ogre_lighting
	LBU T0, @_flash_counter (S0)
	ANDI T0, T0, 0x2
	LI A1, @snowgre_lighting_normal
	BEQ T0, R0, @@endif_red
	MOVE A0, V0
		LI A1, @snowgre_lighting_red
	@@endif_red:
	JAL wordcopy
	SETU A2, 0x6
@@endif_flashing_red:

JAL is_mario_dead_or_dying
NOP
BEQ V0, R0, @@endif_mario_is_dead
	LW T0, o_state (S0)
	LI T1, @action_hibernating
	BEQ T0, T1, @@return
	LI T1, @action_sinking
	BEQ T0, T1, @@endif_mario_is_dead
	SW T1, o_state (S0)
	JAL @reset_claw_positions
	NOP
@@endif_mario_is_dead:

LW T0, o_state (S0)
JALR T0

LI T0, g_mario
LUI AT, 0x4320
MTC1 AT, F6
L.S F4, m_y (T0)
L.S F5, o_y (S0)
ADD.S F6, F4, F6
C.LE.S F6, F5
L.S F6, o_hitbox_height (S0)
BC1T @@return
ADD.S F5, F5, F6
C.LE.S F5, F6
LUI AT, 0x4361
BC1T @@return
MTC1 AT, F12
JAL 0x802A3818

@@return:
SW R0, o_interaction_status (S0)
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

/* Snowgre actions */
@action_sinking:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LUI AT, @SINKING_SPEED_F16
	MTC1 AT, F5
	LUI AT, 0x4480
	MTC1 AT, F6
	L.S F4, o_y (S0)
	SUB.S F4, F4, F5
	S.S F4, o_y (S0)
	L.S F5, o_home_y (S0)
	SUB.S F5, F5, F4
	C.LT.S F5, F6
	NOP
	BC1T @@return
	LW AT, o_home_x (S0)
	SW AT, o_x (S0)
	LW AT, o_home_z (S0)
	SW AT, o_z (S0)
	LW T0, @_head (S0)
	LW T1, @_left_hand (S0)
	LW T2, @_right_hand (S0)
	@make_hidden S0
	@make_hidden T0
	@make_hidden T1
	@make_hidden T2
	SETU AT, 0x3
	SW AT, o_health (S0)
	SETU AT, -1
	SW AT, o_intangibility_timer (S0)
	LI T0, @action_hibernating
	SW T0, o_state (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_hibernating:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI T0, g_mario
	L.S F4, m_y (T0)
	L.S F5, o_y (S0)
	C.LT.S F4, F5
	LW.U A0, g_mario_obj_ptr
	BC1T @@return
	LW.L A0, g_mario_obj_ptr
	JAL get_dist_2d
	MOVE A1, S0
	LUI AT, @AGGRO_RADIUS_F16
	MTC1 AT, F4
	C.LE.S F0, F4
	LUI AT, 0x4080
	BC1F @@return
	MTC1 AT, F5
	LI T0, g_mario
	L.S F4, o_home_y (S0)
	SUB.S F5, F4, F5
	L.S F4, m_y (T0)
	C.LT.S F4, F5
	LW T0, @_head (S0)
	BC1T @@return
	LW T1, @_left_hand (S0)
	LW T2, @_right_hand (S0)
	@make_visible S0
	@make_visible T0
	@make_visible T1
	@make_visible T2
	LI T0, @action_rise_up
	SW T0, o_state (S0)
	SW R0, o_intangibility_timer (S0)
	LW AT, o_angle_to_mario (S0)
	SW AT, o_face_angle_yaw (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_rise_up:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LUI AT, @RISING_SPEED_F16
	MTC1 AT, F5
	L.S F4, o_y (S0)
	ADD.S F4, F4, F5
	S.S F4, o_y (S0)
	L.S F5, o_home_y (S0)
	C.LT.S F4, F5
	NOP
	BC1T @@return
	LI T0, @action_jumpsquat
	SW T0, o_state (S0)
	SW R0, o_timer (S0)
	SETU AT, 30
	SH AT, @_wait_time (S0)
	SB R0, @_hop_counter (S0)
	LI T0, @action_hop_init
	SW T0, @_next_action (S0)
	LI T0, @action_begin_icicle_volley
	SW T0, @_next_attack (S0)
	LW AT, o_face_angle_yaw (S0)
	SW AT, o_move_angle_yaw (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_idle:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL @turn_towards_mario
	SETU A0, @TURN_SPEED_U16
	SW V0, o_move_angle_yaw (S0)
	 
	LW T0, o_timer (S0)
	LHU T1, @_wait_time (S0)
	SLT AT, T0, T1
	BNE AT, R0, @@return
	LW AT, @_next_action (S0)
	SW AT, o_state (S0)
	SW R0, o_timer (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_jumpsquat:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, o_timer (S0)
	SLL T0, T0, 0xF
	LHU T1, @_wait_time (S0)
	DIVU T0, T1
	NOP
	MFLO A0
	JAL sin_u16
	NOP
	LUI AT, 0x3E4C
	MTC1 AT, F4
	LUI AT, 0x3F80
	MTC1 AT, F5
	MUL.S F4, F4, F0
	SUB.S F4, F5, F4
	S.S F4, o_scale_y (S0)
	
	LW RA, 0x14 (SP)
	B @action_idle
	ADDIU SP, SP, 0x18
	
@action_hop_init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LB T0, @_hop_counter (S0)
	SETU AT, @NUM_HOPS_U8
	BNE T0, AT, @@endif_done_hopping
		LUI AT, 0x3F80
		SW AT, o_scale_y (S0)
		LW T0, @_next_attack (S0)
		SW T0, o_state (S0)
		SB R0, @_hop_counter (S0)
		LW RA, 0x14 (SP)
		JR T0
		ADDIU SP, SP, 0x18
	@@endif_done_hopping:
	ADDIU T0, T0, 0x1
	SB T0, @_hop_counter (S0)
	LUI A0, 0x504C
	JAL play_sound
	ORI A0, A0, 0x8081
	LUI AT, @HOP_SPEED_H_F16
	SW AT, o_speed_h (S0)
	LUI AT, @HOP_SPEED_V_F16
	SW AT, o_speed_y (S0)
	LW A0, g_mario_obj_ptr
	JAL get_dist_2d
	MOVE A1, S0
	LUI AT, 0x447A
	MTC1 AT, F4
	LI T0, @action_hop
	C.LT.S F0, F4
	SW T0, o_state (S0)
	BC1F @@return
	LUI AT, 0x3F00
	MTC1 AT, F5
	DIV.S F4, F0, F4
	MUL.S F4, F4, F5
	ADD.S F4, F4, F5
	L.S F5, o_speed_h (S0)
	MUL.S F4, F4, F5
	S.S F4, o_speed_h (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	B @action_hop
	ADDIU SP, SP, 0x18
	
	
@action_hop: ; ppHop ppHop ppHop ppHop
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL @snowgre_move_horizontal
	NOP
	JAL @snowgre_move_vertical
	NOP
	
	BEQ V0, R0, @@return
	SETU AT, @HOP_DELAY_U16
	SH AT, @_wait_time (S0)
	LI T0, @action_jumpsquat
	SW T0, o_state (S0)
	LI T0, @action_hop_init
	SW T0, @_next_action (S0)
	SW R0, o_speed_h (S0)
	SW R0, o_timer (S0)
	
	LUI A0, 0x300A
	JAL play_sound
	ORI A0, A0, 0x8081
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@action_begin_icicle_volley:
	LW T0, @_left_hand (S0)
	SETU AT, 0x8
	SW AT, o_interaction (T0)
	SH R0, @_target_rel_yaw (T0)
	SH R0, @_target_angle (T0)
	SETU AT, 0x4000
	SH AT, @_target_pitch (T0)
	LUI AT, 0x432E
	SW AT, @_target_rel_y (T0)
	LUI AT, 0x4389
	SW AT, @_target_dist (T0)
	LW T0, @_right_hand (S0)
	SETU AT, 0xC000
	SH AT, @_target_rel_yaw (T0)
	SH AT, @_target_angle (T0)
	SH AT, @_target_pitch (T0)
	LUI AT, 0x4348
	SW AT, @_target_rel_y (T0)
	SETU AT, 15
	SH AT, @_wait_time (S0)
	LI T0, @action_icicle_volley
	SW T0, @_next_action (S0)
	LI T0, @action_idle
	SW T0, o_state (S0)
	JR RA
	SW R0, o_timer (S0)
	
@action_icicle_volley:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL @turn_towards_mario
	SETU A0, 0x1000
	LW T0, o_timer (S0)
	ANDI T0, T0, 0xF
	BNE T0, R0, @@endif_shoot_missicle
		LI A2, (@beh_icicle_missile-0x80000000)
		LW A0, @_left_hand (S0)
		JAL spawn_object
		SETU A1, 0x4F
	@@endif_shoot_missicle:
	
	LW T0, o_timer (S0)
	SLTI AT, T0, 0xF1
	BNE AT, R0, @@return
		LI T0, @action_begin_frost_breath
		SW T0, @_next_attack (S0)
		LI T0, @action_hop_init
		SW T0, @_next_action (S0)
		LI T0, @action_idle
		SW T0, o_state (S0)
		SETU AT, 20
		JAL @reset_claw_positions
		SH AT, @_wait_time (S0)
		LW T0, @_left_hand (S0)
		SW R0, o_interaction (T0)
		
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_begin_frost_breath:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LUI A0, 0x5008
	JAL play_sound
	ORI A0, A0, 0x8081
	
	LI T0, @action_frost_breath
	SW T0, @_next_action (S0)
	LI T0, @action_idle
	SW T0, o_state (S0)
	SETU AT, 30
	SH AT, @_wait_time (S0)
	SW R0, o_timer (S0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_frost_breath:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL @turn_towards_mario
	SETU A0, 0x800
	
	LUI A0, 0x4010
	JAL play_sound
	ORI A0, A0, 0x8001
	
	LW T0, o_timer (S0)
	ANDI T0, T0, 0x1
	BNE T0, R0, @@return
	LI A2, (@beh_frost_breath-0x80000000)
	SETU A1, 0x91
	JAL spawn_object
	LW A0, @_head (S0)
	
	LW T0, o_timer (S0)
	SLTI AT, T0, 180
	BNE AT, R0, @@return
		LI T0, @action_begin_clawshot
		SW T0, @_next_attack (S0)
		LI T0, @action_hop_init
		SW T0, @_next_action (S0)
		LI T0, @action_idle
		SW T0, o_state (S0)
		SETU AT, 20
		JAL @reset_claw_positions
		SH AT, @_wait_time (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_begin_clawshot:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI T0, @action_clawshot_1
	SW T0, @_next_action (S0)
	LI T0, @action_idle
	SW T0, o_state (S0)
	SETU AT, 10
	SH AT, @_wait_time (S0)
	SW R0, o_timer (S0)
	
	LW T0, @_right_hand (S0)
	SH R0, @_target_angle (T0)
	SH R0, @_target_rel_yaw (T0)
	SH R0, @_target_roll (T0)
	SETU AT, 0x8000
	SH AT, @_target_pitch (T0)
	LUI AT, 0x4300
	SW AT, @_target_rel_y (T0)
	LUI AT, 0x4380
	SW AT, @_target_dist (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_clawshot_1:
	LW T0, @_right_hand (S0)
	SETU AT, 0x8000
	SW AT, o_interaction (T0)
	LUI AT, 0x45CB
	SW AT, @_target_dist (T0)
	LI T0, @action_clawshot_2
	JR T0
	SW T0, o_state (S0)
	
@action_clawshot_2:
	NOP
@action_clawshot_3:
	JR RA
	NOP
	
@action_clawshot_4:
	LI T0, @action_begin_hurricane_spin
	SW T0, @_next_attack (S0)
	LI T0, @action_hop_init
	SW T0, @_next_action (S0)
	LI T0, @action_idle
	SW T0, o_state (S0)
	SETU AT, 15
	SH AT, @_wait_time (S0)
	J @reset_claw_positions
	SW R0, o_timer (S0)
	
@action_begin_hurricane_spin:
	LW T0, @_left_hand (S0)
	LW T1, @_right_hand (S0)
	SETU AT, 0x8
	SW AT, o_interaction (T0)
	SW AT, o_interaction (T1)
	LUI AT, 0x4316
	SW AT, @_target_rel_y (T0)
	SW AT, @_target_rel_y (T1)
	LUI AT, 0x4380
	SW AT, @_target_dist (T0)
	SW AT, @_target_dist (T1)
	SETU AT, 0x8000
	SH AT, @_target_pitch (T0)
	SH AT, @_target_pitch (T1)
	SETU AT, 0x4000
	SH AT, @_target_angle (T0)
	SH AT, @_target_rel_yaw (T0)
	SH AT, @_target_roll (T0)
	SH AT, @_target_roll (T1)
	SETU AT, 0xC000
	SH AT, @_target_angle (T1)
	SH AT, @_target_rel_yaw (T1)
	
	LW AT, o_angle_to_mario (S0)
	SW AT, o_move_angle_yaw (S0)
	LI T0, @action_hurricane_spin
	SW T0, @_next_action (S0)
	LI T0, @action_idle
	SW T0, o_state (S0)
	SETU AT, 20
	SH AT, @_wait_time (S0)
	SW R0, o_angle_vel_pitch (S0)
	JR RA
	SW R0, o_timer (S0)
	
@action_hurricane_spin:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LUI A0, 0x507F
	JAL play_sound
	ORI A0, A0, 0x8001
	
	SETU AT, 0x6
	SW AT, o_collision_damage (S0)
	
	LW T0, o_timer (S0)
	SLTI AT, T0, 215
	BEQ AT, R0, @@slow_down
	LW T0, o_angle_vel_yaw (S0)
		ADDIU T0, T0, 0x30
		MINIU T0, T0, 0x1000
		B @@end_set_spin_speed
		SW T0, o_angle_vel_yaw (S0)
	@@slow_down:
		ADDIU T0, T0, 0xFFD0
		MAX T0, T0, R0
		SW T0, o_angle_vel_yaw (S0)
	@@end_set_spin_speed:
	
	LW T1, o_face_angle_yaw (S0)
	ADDU T0, T0, T1
	@shortify T0
	SW T0, o_face_angle_yaw (S0)
	
	LW A0, o_move_angle_yaw (S0)
	LW A1, o_angle_to_mario (S0)
	JAL turn_angle
	SETU A2, 0x200
	SW V0, o_move_angle_yaw (S0)
	
	LUI AT, 0x432B
	MTC1 AT, F5
	L.S F4, o_angle_vel_yaw (S0)
	CVT.S.W F4, F4
	DIV.S F4, F4, F5
	JAL @snowgre_move_horizontal
	S.S F4, o_speed_h (S0)
	
	BEQ V0, R0, @@endif_bounce
	LW AT, o_angle_to_mario (S0)
		SW AT, o_move_angle_yaw (S0)
	@@endif_bounce:
	
	JAL is_mario_voiding_out
	NOP
	BNE V0, R0, @@done_spinning
	
	LW T0, o_timer (S0)
	SLTI AT, T0, 300
	BNE AT, R0, @@return
		@@done_spinning:
		LI T0, @action_begin_icicle_volley
		SW T0, @_next_attack (S0)
		LI T0, @action_hop_init
		SW T0, @_next_action (S0)
		LI T0, @action_idle
		SW T0, o_state (S0)
		SETU AT, 30
		JAL @reset_claw_positions
		SH AT, @_wait_time (S0)
		LW T0, @_left_hand (S0)
		SW R0, o_interaction (T0)
		LW T0, @_right_hand (S0)
		SW R0, o_interaction (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_begin_death:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL is_mario_voiding_out
	NOP
	BNE V0, R0, @@return
	NOP
	
	LW T0, @_left_hand (S0)
	SW R0, o_interaction (T0)
	LW T0, @_right_hand (S0)
	SW R0, o_interaction (T0)
	
	LI T0, g_mario
	LI T1, 0xC5849B5C
	SW T1, m_x (T0)
	SW T1, o_x (S0)
	LW AT, o_home_y (S0)
	SW AT, m_y (T0)
	SW AT, o_y (S0)
	LUI AT, 0xC440
	MTC1 AT, F5
	L.S F4, o_z (S0)
	C.LE.S F4, F5
	LUI AT, 0xC440
	SW AT, m_z (T0)
	LUI AT, 0x4459
	SW AT, o_z (S0)
	SH R0, m_angle_yaw (T0)
	SETS AT, 0xD000
	SW AT, o_face_angle_yaw (S0)
	MOVE A0, T0
	LI A1, 0x0C400201
	JAL set_mario_action
	MOVE A2, R0
	LI T0, @action_begin_death_2
	SW T0, o_state (S0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_begin_death_2:
	LI T0, @action_death_cutscene_1
	SW T0, o_state (S0)
	SETU T0, 0x4A
	SW T0, g_timestop_flags
	
	LH AT, o_active_flags (S0)
	ORI AT, AT, 0x20
	SH AT, o_active_flags (S0)
	
	LW T0, @_head (S0)
	LH AT, o_active_flags (T0)
	ORI AT, AT, 0x20
	SH AT, o_active_flags (T0)
	
	LW T0, @_left_hand (S0)
	LH AT, o_active_flags (T0)
	ORI AT, AT, 0x20
	SH AT, o_active_flags (T0)
	
	SETU A0, 178
	MOVE A1, S0
	J start_cutscene
	SW R0, o_timer (S0)
	
@action_death_cutscene_1:
	LW T0, o_timer (S0)
	SLTI AT, T0, 60
	BNE AT, R0, @@return 
	LI T0, @action_death_cutscene_2
	SW T0, o_state (S0)
	SW R0, o_timer (S0)
	@@return:
	JR RA
	NOP
	
@action_death_cutscene_2:
	LW T0, o_timer (S0)
	SLTI AT, T0, 80
	BNE AT, R0, @@return 
	LI T0, @action_death_cutscene_3
	SW T0, o_state (S0)
	@@return:
	JR RA
	NOP
	
@action_death_cutscene_3:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, o_timer (S0)
	SLTI AT, T0, 40
	BNE AT, R0, @@return 
	LI T0, @action_death_cutscene_4
	SW T0, o_state (S0)
	LI A2, beh_angry_whomp
	SETU A1, 0x51
	JAL spawn_object
	MOVE A0, S0
	LHU T0, o_active_flags (V0)
	ORI T0, T0, 0x20
	SH T0, o_active_flags (V0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_death_cutscene_4:
	JR RA
	NOP
	
@turn_towards_mario:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

MOVE A2, A0
LW A0, o_face_angle_yaw (S0)
JAL turn_angle
LW A1, o_angle_to_mario (S0)
SW V0, o_face_angle_yaw (S0)

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@reset_claw_positions:
LW T0, @_left_hand (S0)
LW T1, @_right_hand (S0)
SETU AT, 0x2800
SH AT, @_target_rel_yaw (T0)
SH AT, @_target_angle (T0)
SETU AT, 0xD800
SH AT, @_target_rel_yaw (T1)
SH AT, @_target_angle (T1)
SETU AT, 0xB000
SH AT, @_target_pitch (T0)
SH AT, @_target_pitch (T1)
SH R0, @_target_roll (T0)
SH R0, @_target_roll (T1)
LUI AT, 0x437A
SW AT, @_target_rel_y (T0)
SW AT, @_target_rel_y (T1)
LUI AT, 0x4361
SW AT, @_target_dist (T0)
JR RA
SW AT, @_target_dist (T1)

/* @snowgre_move_horizontal
Move horizontally using the movement angle and speed, but stop at edges.
Returns 1 if a ledge was hit, and 0 otherwise
*/
@snowgre_move_horizontal:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)

LW AT, o_x (S0)
SW AT, 0x10 (SP)
LW AT, o_z (S0)
SW AT, 0x14 (SP)
LW AT, o_floor_height (S0)
SW AT, 0x18 (SP)

JAL decompose_speed_and_move
NOP

JAL obj_update_floor_and_walls
NOP

LW T0, o_move_flags (S0)
ANDI T0, T0, 0x200
BNE T0, R0, @@revert
LUI AT, 0x4100
MTC1 AT, F6
L.S F4, o_floor_height (S0)
L.S F5, 0x18 (SP)
SUB.S F4, F5, F4
ABS.S F4, F4
C.LE.S F4, F6
MOVE V0, R0
BC1T @@return
@@revert:
LW AT, 0x10 (SP)
SW AT, o_x (S0)
LW AT, 0x14 (SP)
JAL obj_update_floor_and_walls
SW AT, o_z (S0)
SETU V0, 0x1

@@return:
LW RA, 0x1C (SP)
JR RA
ADDIU SP, SP, 0x20

/* @snowgre_move_vertical
Move vertically using the vertical speed and gravity. Stop at the floor.
Returns 1 if the floor was hit. 0 otherwise.
*/
@snowgre_move_vertical:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

L.S F4, o_y (S0)
L.S F5, o_speed_y (S0)
L.S F6, o_gravity (S0)

ADD.S F5, F5, F6
S.S F5, o_speed_y (S0)
ADD.S F4, F4, F5
S.S F4, o_y (S0)

L.S F5, o_floor_height (S0)
C.LE.S F4, F5
MOVE V0, R0
BC1F @@return
NOP
S.S F5, o_y (S0)
SW R0, o_speed_y (S0)
SETU V0, 0x1

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18



@snowgre_head_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LW T0, o_parent (S0)
LW T1, o_state (T0)
LW AT, o_x (T0)
SW AT, o_x (S0)
LW AT, o_z (T0)
SW AT, o_z (S0)
LW AT, o_scale_y (T0)
SW AT, o_scale_y (S0)

LUI AT, 0x43A7
MTC1 AT, F5
L.S F4, o_scale_y (T0)
MUL.S F5, F5, F4
L.S F4, o_y (T0)
ADD.S F4, F4, F5
S.S F4, o_y (S0)

LI T2, @action_begin_death_2
BEQ T1, T2, @@prepare_for_death_cutscene
LI T2, @action_death_cutscene_1
BEQ T1, T2, @@return
LI T2, @action_death_cutscene_2
BEQ T1, T2, @@look_at_missing_hand
LI T2, @action_death_cutscene_3
BEQ T1, T2, @@look_up
LI T2, @action_death_cutscene_4
BEQ T1, T2, @@return

LW AT, o_face_angle_yaw (T0)
SW AT, o_face_angle_yaw (S0)

LW A0, g_mario_obj_ptr
JAL get_dist_2d
MOVE A1, S0
LI T0, g_mario
LUI AT, 0x42C8
MTC1 AT, F5
L.S F4, m_y (T0)
ADD.S F4, F4, F5
L.S F5, o_y (S0)
SUB.S F14, F5, F4
JAL atan2s
MOV.S F12, F0
MINI V0, V0, 0x1555
MAXI V0, V0, 0xEAAB
SW V0, o_face_angle_pitch (S0)

LW T0, o_parent (S0)
LW T0, o_state (T0)
LI T1, @action_clawshot_2
BEQ T0, T1, @@look_at_mario
LI T1, @action_clawshot_3
BNE T0, T1, @@return

@@look_at_mario:
LW T0, o_parent (S0)
LW A0, o_face_angle_yaw (T0)
LW A1, o_angle_to_mario (T0)
JAL turn_angle
SETU A2, 0x4000
SW V0, o_face_angle_yaw (S0)

@@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@@prepare_for_death_cutscene:
SETS AT, 0xD000
SW AT, o_face_angle_yaw (S0)
B @@return
SW R0, o_face_angle_pitch (S0)

@@look_at_missing_hand:
LW A0, o_face_angle_pitch (S0)
SETS A1, 0x2000
JAL turn_angle
SETU A2, 0x100
SW V0, o_face_angle_pitch (S0)
LW A0, o_face_angle_yaw (S0)
SETS A1, 0xA800
JAL turn_angle
SETU A2, 0x100
B @@return
SW V0, o_face_angle_yaw (S0)

@@look_up:
LW A0, o_face_angle_pitch (S0)
SETS A1, 0xE000
JAL turn_angle
SETU A2, 0x200
SW V0, o_face_angle_pitch (S0)
LW A0, o_face_angle_yaw (S0)
SETS A1, 0xD000
JAL turn_angle
SETU A2, 0x200
B @@return
SW V0, o_face_angle_yaw (S0)

@snowgre_claw_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LI T0, g_mario
LH T0, m_hitstun (T0)
SW T0, o_intangibility_timer (S0)

LW T0, o_parent (S0)
LW T0, o_state (T0)
LI T1, @action_clawshot_2
BEQ T0, T1, @@launching
LI T1, @action_clawshot_3
LUI AT, 0x4120
BNE T0, T1, @@endif_vulnerable
SW AT, o_speed_h (S0)
B @@endif_lanching
LUI AT, 0x4270
@@launching:
LUI AT, 0x42C8
@@endif_lanching:
SW AT, o_speed_h (S0)
LW T0, o_parent (S0)
LBU AT, @_flash_counter (T0)
BNE AT, R0, @@endif_vulnerable
NOP
	; vulnerable to ground pound
	SW R0, o_intangibility_timer (S0)
	LW T0, o_interaction_status (S0)
	SETU AT, 0xC004
	BNE T0, AT, @@endif_vulnerable
		LW T0, o_parent (S0)
		SETU AT, 135
		SB AT, @_flash_counter (T0)
		LW T1, o_health (T0)
		ADDIU T1, T1, 0xFFFF
		SW T1, o_health (T0)
		SW R0, o_interaction (S0)
		BNE T1, R0, @@endif_snowgre_slain
			LI.U A0, @ice_shards_big
			JAL spawn_particles
			LI.L A0, @ice_shards_big
			@make_hidden S0
			LW T0, o_parent (S0)
			LI T1, @action_idle
			SW T1, o_state (T0)
			LI T1, @action_begin_death
			SW T1, @_next_action (T0)
			SETU AT, 45
			SH AT, @_wait_time (T0)
			LUI A0, 0x505A
			JAL play_sound
			ORI A0, A0, 0x8081
			B @@endif_vulnerable
		@@endif_snowgre_slain:
		LUI A0, 0x935A
		JAL play_sound
		ORI A0, A0, 0x0081
		LUI A0, 0x5147
		JAL play_sound
		ORI A0, A0, 0xC081
		LI.U A0, @ice_shards
		JAL spawn_particles
		LI.L A0, @ice_shards
@@endif_vulnerable:

L.S F14, o_speed_h (S0)
L.S F12, @_current_dist (S0)
JAL @move_float_towards
L.S F13, @_target_dist (S0)
S.S F0, @_current_dist (S0)

LUI AT, 0x4120
MTC1 AT, F14
L.S F12, @_current_rel_y (S0)
JAL @move_float_towards
L.S F13, @_target_rel_y (S0)
S.S F0, @_current_rel_y (S0)

LH A0, @_current_angle (S0)
LH A1, @_target_angle (S0)
JAL turn_angle
SETU A2, 0x400
SH V0, @_current_angle (S0)

LH A0, @_current_rel_yaw (S0)
LH A1, @_target_rel_yaw (S0)
JAL turn_angle
SETU A2, 0x400
SH V0, @_current_rel_yaw (S0)

LW A0, o_face_angle_pitch (S0)
LH A1, @_target_pitch (S0)
JAL turn_angle
SETU A2, 0x400
SW V0, o_face_angle_pitch (S0)

LW A0, o_face_angle_roll (S0)
LH A1, @_target_roll (S0)
JAL turn_angle
SETU A2, 0x400
SW V0, o_face_angle_roll (S0)

LW T0, o_parent (S0)
LW A0, o_face_angle_yaw (T0)
LH AT, @_current_angle (S0)
JAL angle_to_unit_vector
ADDU A0, A0, AT
L.S F4, @_current_dist (S0)
MUL.S F0, F0, F4
MUL.S F1, F1, F4
LW T0, o_parent (S0)
L.S F4, o_x (T0)
L.S F5, o_z (T0)
ADD.S F4, F0, F4
ADD.S F5, F1, F5
S.S F4, o_x (S0)
S.S F5, o_z (S0)

LW T0, o_parent (S0)
L.S F4, o_y (T0)
L.S F5, @_current_rel_y (S0)
L.S F6, o_scale_y (T0)
MUL.S F5, F5, F6
MUL.S F5, F5, F6
ADD.S F4, F4, F5
S.S F4, o_y (S0)

LW T0, o_face_angle_yaw (T0)
LH AT, @_current_rel_yaw (S0)
ADDU T0, T0, AT
@shortify T0
SW T0, o_face_angle_yaw (S0)
SW T0, o_move_angle_yaw (S0)

LW T0, o_parent (S0)
LW T1, @_right_hand (T0)
BNE S0, T1, @@endif_attack_mode
LW T0, o_state (T0)
LI T1, @action_clawshot_2
BNE T0, T1, @@endif_attack_mode
	LUI AT, 0x459C
	MTC1 AT, F5
	L.S F4, @_current_dist (S0)
	C.LE.S F4, F5
	NOP
	BC1F @@retract
	NOP
	JAL obj_resolve_wall_collisions
	NOP
	BEQ V0, R0, @@endif_attack_mode
		@@retract:
		LW T0, o_parent (S0)
		LI T1, @action_clawshot_3
		SW T1, o_state (T0)
		SW R0, @_target_dist (S0)
@@endif_attack_mode:

LW T0, o_parent (S0)
LW T1, @_right_hand (T0)
BNE S0, T1, @@return
LW T0, o_state (T0)
LI T1, @action_clawshot_3
BNE T0, T1, @@return
	LUI AT, 0x4380
	MTC1 AT, F5
	L.S F4, @_current_dist (S0)
	C.LE.S F4, F5
	LW T0, o_parent (S0)
	BC1F @@return
	LI T1, @action_clawshot_4
	SW T1, o_state (T0)
	SW R0, o_interaction (S0)

@@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@move_float_towards:
C.LE.S F12, F13
SUB.S F4, F13, F12
BC1F @@elseif_bigger
ABS.S F4, F4
	C.LE.S F14, F4
	B @@endif_smaller
	ADD.S F0, F12, F14
@@elseif_bigger:
	C.LE.S F14, F4
	SUB.S F0, F12, F14
@@endif_smaller:
BC1T @@return
NOP
MOV.S F0, F13
@@return:
JR RA
NOP
	
@snowgre_lighting_normal:
.word 0xFFFFFFFF, 0xFFFFFFFF
.word 0xBFBFBFFF, 0xBFBFBFFF
.word 0x9F9F9FFF, 0x9F9F9FFF

@snowgre_lighting_red:
.word 0xFF0000FF, 0xFF0000FF
.word 0xBF0000FF, 0xBF0000FF
.word 0x9F0000FF, 0x9F0000FF

@set_missile_angle:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LUI A0, 0x258
JAL play_sound
ORI A0, A0, 0xC081

LW.U S0, g_current_obj_ptr
JAL get_random_short
LW.L S0, g_current_obj_ptr
ANDI T0, V0, 0x3
SB T0, 0xF4 (S0)

BEQ T0, R0, @@return
SETU AT, 0x1
BNE T0, AT, @@endif_random_offset
	SRA V0, V0, 0x5
	LW T0, o_face_angle_yaw (S0)
	ADDU T0, T0, V0
	@shortify T0
	B @@return
	SW T0, o_face_angle_yaw (S0)
@@endif_random_offset:

LW A0, g_mario_obj_ptr
JAL get_dist_2d
MOVE A1, S0
L.S F4, o_speed_h (S0)
DIV.S F8, F0, F4

LI T1, g_mario
L.S F4, m_x (T1)
L.S F5, m_z (T1)
L.S F6, m_speed_x (T1)
L.S F7, m_speed_z (T1)
LBU T0, 0xF4 (S0)
SETU AT, 0x2
BNE T0, AT, @@endif_half_lead
	LUI AT, 0x4000
	MTC1 AT, F9
	NOP
	DIV.S F6, F6, F9
	DIV.S F7, F7, F9
@@endif_half_lead:
MUL.S F6, F6, F8
MUL.S F7, F7, F8
ADD.S F4, F4, F6
ADD.S F5, F5, F7
L.S F6, o_x (S0)
L.S F7, o_z (S0)
SUB.S F12, F5, F7
JAL atan2s
SUB.S F14, F4, F6
LW A0, o_face_angle_yaw (S0)
MOVE A1, V0
JAL turn_angle
SETU A2, 0x1555
SW V0, o_face_angle_yaw (S0)

@@return:
LW AT, o_face_angle_yaw (S0)
SW AT, o_move_angle_yaw (S0)
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18


@frost_breath_init:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

JAL get_random_short 
NOP
LW T0, o_animation_state (S0)
ADDU T0, T0, V0
SW T0, o_animation_state (S0)

LI T0, g_mario
LUI AT, 0x42C8
MTC1 AT, F4
L.S F12, m_x (T0)
L.S F13, m_y (T0)
L.S F14, m_z (T0)
ADD.S F13, F13, F4
LUI AT, 0x480
MTC1 AT, F6
L.S F4, m_speed_x (T0)
L.S F5, m_speed_z (T0)
MUL.S F4, F4, F6
MUL.S F5, F5, F6
ADD.S F12, F12, F4
ADD.S F14, F14, F5
JAL unit_vector_from_object_to_point
MOVE A0, S0
LUI AT, 0x42F0
MTC1 AT, F4
NOP
MUL.S F0, F0, F4
MUL.S F1, F1, F4
MUL.S F2, F2, F4
S.S F0, o_speed_x (S0)
S.S F1, o_speed_y (S0)
S.S F2, o_speed_z (S0)

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@frost_breath_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LW A0, g_current_obj_ptr
LW T0, o_timer (A0)
SLTI AT, T0, 0xF
BEQ AT, R0, @@endif_growing
	ADDIU T0, T0, 0x1
	MTC1 T0, F4
	NOP
	CVT.S.W F4, F4
	MFC1 A1, F4
	JAL scale_object
	SW R0, o_interaction_status (A0)
@@endif_growing:

LW A0, g_current_obj_ptr
LI A1, @frost_breath_hitbox
JAL set_object_hitbox
SW R0, o_interaction_status (A0)

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@frost_breath_hitbox:
.word 0x20000000 ; interaction
.byte 0x06 ; downOffset
.byte 0x03 ; collision damage
.byte 0x00 ; health
.byte 0x00 ; loot coins
.halfword 0x0C ; hitbox radius
.halfword 0x0C ; hitbox height
.halfword 0x00 ; hurtbox radius
.halfword 0x00 ; hurtbox height

@ice_shards:
.byte 0 ; behaviour argument
.byte 5 ; # of particles
.byte 72 ; model
.byte 50 ; vertical offset
.byte 8 ; base hvel
.byte 3 ; random hvel
.byte 27 ; base vvel
.byte 15 ; random vvel
.byte -4 ; gravity
.byte 0 ; drag
.align 4
.word float( 4 ) ; base size
.word float( 4 ) ; random size

@ice_shards_big:
.byte 0 ; behaviour argument
.byte 8 ; # of particles
.byte 72 ; model
.byte 50 ; vertical offset
.byte 8 ; base hvel
.byte 3 ; random hvel
.byte 27 ; base vvel
.byte 15 ; random vvel
.byte -4 ; gravity
.byte 0 ; drag
.align 4
.word float( 8 ) ; base size
.word float( 4 ) ; random size

despawn_snowgre:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

JAL mark_object_for_deletion
MOVE S0, A0
JAL mark_object_for_deletion
LW A0, @_head (S0)
JAL mark_object_for_deletion
LW A0, @_left_hand (S0)
JAL mark_object_for_deletion
LW A0, @_right_hand (S0)

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
