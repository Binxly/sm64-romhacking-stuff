.definelabel beh_mafia_snowman_impl, (org()-0x80000000)
;BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_ANGLE_TO_MARIO | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_WORD o_animation_pointer, 0x0500D118
BHV_SET_INT o_animation_state, 1
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 2500
BHV_DROP_TO_FLOOR
BHV_STORE_HOME
BHV_ADD_FLOAT o_y, -256
BHV_SET_ANIMATION 0
BHV_SET_WORD o_state, @action_underground
BHV_EXEC @init
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@_initial_yaw equ 0xF4
@_underground_y equ 0xF8
@_attack_delay equ 0xFC

@init:
LW T0, g_current_obj_ptr
LW AT, o_face_angle_yaw (T0)
SW AT, @_initial_yaw (T0)
LW AT, o_y (T0)
SW AT, @_underground_y (T0)
LI A1, 0x80332B00
J set_object_hitbox
MOVE A0, T0

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LW A0, @_initial_yaw (S0)
LW A1, o_angle_to_mario (S0)
JAL turn_angle
SETU A2, 0x238E
SW V0, o_face_angle_yaw (S0)

LW T0, o_state (S0)
JR T0
NOP

@action_underground:
	JAL @is_mario_in_range
	NOP
	BEQ V0, R0, @return
	LUI A0, 0x8033
	JAL spawn_particles
	ORI A0, A0, 0x2B10
	LI T0, @action_rising
	B @return
	SW T0, o_state (S0)
	
@action_rising:
	LUI AT, 0x4220
	MTC1 AT, F6
	L.S F4, o_y (S0)
	L.S F5, o_home_y (S0)
	ADD.S F4, F4, F6
	C.LT.S F4, F5
	NOP
	BC1T @return
	S.S F4, o_y (S0)
	JAL get_random_short
	S.S F5, o_y (S0)
	ANDI V0, V0, 0xF
	ADDIU V0, V0, 0x1
	SH V0, @_attack_delay (S0)
	LI T0, @action_ready_to_fire
	SW T0, o_state (S0)
	B @return
	SW R0, o_timer (S0)
	
@action_ready_to_fire:
	LH T0, @_attack_delay (S0)
	LW T1, o_timer (S0)
	BNE T0, T1, @return
	LI T0, @action_attacking
	SW T0, o_state (S0)
	LI RA, @return
	J set_animation
	SETU A0, 0x1
	
@action_attacking:
	LH T0, o_animation_frame (S0)
	SETU AT, 0x5
	BNE T0, AT, @@endif_throw_snowball
		LI A2, (@beh_snowball-0x80000000)
		SETU A1, 0xA0
		JAL spawn_object
		MOVE A0, S0
		LW AT, o_face_angle_yaw (S0)
		SW AT, o_move_angle_yaw (V0)
	@@endif_throw_snowball:
	JAL check_done_animation
	NOP
	BEQ V0, R0, @return
	NOP
	JAL @is_mario_in_range
	NOP
	BNE V0, R0, @return
	NOP
	JAL set_animation
	SETU A0, 0x0
	LUI A0, 0x8033
	JAL spawn_particles
	ORI A0, A0, 0x2B10
	LI T0, @action_sinking
	B @return
	SW T0, o_state (S0)
	
@action_sinking:
	LUI AT, 0x4220
	MTC1 AT, F6
	L.S F4, o_y (S0)
	L.S F5, @_underground_y (S0)
	SUB.S F4, F4, F6
	C.LE.S F4, F5
	NOP
	BC1F @return
	S.S F4, o_y (S0)
	S.S F5, o_y (S0)
	LI T0, @action_underground
	B @return
	SW T0, o_state (S0)
	
@return:
SW R0, o_interaction_status (S0)
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@is_mario_in_range:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
LUI AT, 0x44D5
MTC1 AT, F5
L.S F4, o_distance_to_mario (S0)
C.LE.S F4, F5
LW A0, o_angle_to_mario (S0)
BC1F @@return
MOVE V0, R0
JAL abs_angle_diff
LW A1, @_initial_yaw (S0)
SLTIU AT, V0, 0x238F
BEQ AT, R0, @@return
MOVE V0, R0
SETU V0, 0x1
@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18


@beh_snowball:
BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_AUTO_MOVE_XZ | OBJ_AUTO_MOVE_Y | OBJ_ALWAYS_ACTIVE
BHV_BILLBOARD
BHV_SCALE 200
BHV_SET_FLOAT 0xDC, 10
BHV_SET_FLOAT o_wall_hitbox_radius, 30
BHV_SET_FLOAT o_gravity, -2
BHV_ADD_FLOAT o_y, 75
BHV_EXEC @snowball_init
BHV_LOOP_BEGIN
	BHV_EXEC @snowball_loop
BHV_LOOP_END

@snowball_init:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

JAL angle_to_unit_vector
LW A0, o_move_angle_yaw (S0)
LUI AT, 0x428C
MTC1 AT, F5
NOP
MUL.S F4, F1, F5
MUL.S F5, F0, F5
L.S F6, o_x (S0)
L.S F7, o_z (S0)
ADD.S F4, F4, F6
ADD.S F5, F5, F7
S.S F4, o_x (S0)
S.S F5, o_z (S0)

LW A1, g_mario_obj_ptr
JAL angle_to_object
MOVE A0, S0
LW A0, o_move_angle_yaw (S0)
MOVE A1, V0
JAL turn_angle
SETU A2, 0xE39
JAL get_random_short
SW V0, o_move_angle_yaw (S0)
SLL V0, V0, 0x17
SRA V0, V0, 0x17
LW T0, o_move_angle_yaw (S0)
ADDU T0, T0, V0
SW T0, o_move_angle_yaw (S0)
SW T0, o_face_angle_yaw (S0)

JAL @get_angle_of_yeet
NOP
JAL angle_to_unit_vector
MOVE A0, V0
LUI AT, 0x4280
MTC1 AT, F6
NOP
MUL.S F4, F6, F1
MUL.S F5, F6, F0
S.S F4, o_speed_h (S0)
S.S F5, o_speed_y (S0)

LI A1, 0x80332B24
JAL set_object_hitbox
MOVE A0, S0

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@snowball_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

JAL obj_update_floor_and_walls
NOP

LW T0, g_current_obj_ptr

LW T1, o_move_flags (T0)
ANDI AT, T1, 0x80
BEQ AT, R0, @@explode_snowball
ANDI AT, T1, 0x200
BNE AT, R0, @@explode_snowball
LW T1, o_interaction_status (T0)
ANDI AT, T1, 0x2000
BNE AT, R0, @@explode_snowball

L.S F4, o_speed_y (T0)
L.S F5, o_gravity (T0)
ADD.S F4, F4, F5
S.S F4, o_speed_y (T0)

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@@explode_snowball:
LUI A0, 0x8033
JAL spawn_particles
ORI A0, A0, 0x2B10
LW RA, 0x14 (SP)
LW A0, g_current_obj_ptr
J mark_object_for_deletion
ADDIU SP, SP, 0x18


@get_angle_of_yeet:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)

LW A0, g_mario_obj_ptr
JAL get_dist_2d
MOVE A1, S0
S.S F0, 0x18 (SP)

LUI AT, 0x4300
MTC1 AT, F6
L.S F4, o_y (S0)
LI T0, g_mario
L.S F5, m_y (T0)
ADD.S F5, F5, F6
SUB.S F14, F5, F4
JAL atan2s
MOV.S F12, F0
JAL get_random_float
SH V0, 0x14 (SP)
LUI AT, 0x44B6
MTC1 AT, F4
LUI AT, 0x4009
MTC1 AT, F6
L.S F5, 0x18 (SP)
MUL.S F4, F4, F0
MUL.S F5, F5, F6
ADD.S F4, F4, F5
CVT.W.S F4, F4
MFC1 T0, F4
LH V0, 0x14 (SP)
ADDU V0, V0, T0
MINI V0, V0, 0x238E

LW RA, 0x1C (SP)
JR RA
ADDIU SP, SP, 0x20

interact_snowball:
ADDIU SP, SP, 0xFFE8
SW A0, 0x18 (SP)
SW A2, 0x20 (SP)
SW RA, 0x14 (SP)

; Don't hit Mario while he's dying
LB T0, m_health (A0)
BEQ T0, R0, @@return
MOVE V0, R0

; Damage Mario, ignoring invulnerability
SH R0, g_is_invulnerable
JAL take_damage_and_knockback
MOVE A1, A2

; No iframes
LW T0, 0x18 (SP)
SH R0, m_hitstun (T0)

; Set speed and angle
LUI AT, 0xC000
SW AT, m_speed_h (T0)
LW T1, 0x20 (SP)
LW T1, o_move_angle_yaw (T1)
SUBU T1, R0, T1
SH T1, m_angle_yaw (T0)

SETU V0, 0x1

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
