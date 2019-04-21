/* Caterkiller Head code */
@children equ 0xFC
@target_angle equ 0x108
@target_timer equ 0x10A

beh_caterkiller_head_init:
ADDIU SP, SP, 0xFFD8
SW RA, 0x24 (SP)
SW S0, 0x20 (SP)
SW S1, 0x1C (SP)
SW S2, 0x18 (SP)
S.S F20, 0x14 (SP)
S.S F21, 0x10 (SP)

LW S0, g_current_obj_ptr
LI S1, (@beh_caterkiller_body-0x80000000)
SLL S2, R0, 0x0

LUI AT, 0x4296
MTC1 AT, F21
L.S F20, o_home_z (S0)
@create_body_loop:
	SUB.S F20, F20, F21
	SLL A0, S0, 0x0
	ORI A1, R0, 0x52
	JAL spawn_object
	SLL A2, S1, 0x0
	SB S2, o_arg0 (V0)
	S.S F20, o_z (V0)
	ORI AT, R0, 0x2
	SW AT, o_animation_frame (V0)
	SLL AT, S2, 0x2
	ADDU AT, S0, AT
	SW V0, @children (AT)
	ADDIU S2, S2, 0x1
	SLTI AT, S2, 0x3
	BNE AT, R0, @create_body_loop
	NOP

JAL @generate_new_waypoint
NOP

LW RA, 0x24 (SP)
LW S0, 0x20 (SP)
LW S1, 0x1C (SP)
LW S2, 0x18 (SP)
L.S F20, 0x14 (SP)
L.S F21, 0x10 (SP)
JR RA
ADDIU SP, SP, 0x28

beh_caterkiller_head_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr
LI A1, @head_hitbox
JAL set_object_hitbox
SLL A0, S0, 0x0

LW T0, o_interaction_status (S0)
ANDI T0, T0, 0xFF
BEQ T0, R0, @endif_attacked
	NOP
	JAL spawn_explosion
	SLL A0, S0, 0x0
	JAL mark_object_for_deletion
	SLL A0, S0, 0x0
	JAL mark_object_for_deletion
	LW A0, @children (S0)
	JAL mark_object_for_deletion
	LW A0, (@children+0x4) (S0)
	JAL mark_object_for_deletion
	LW A0, (@children+0x8) (S0)
@endif_attacked:

LW T0, o_timer (S0)
ORI AT, R0, 0x5
BNE T0, AT, @endif_advance_state
	LW T0, o_state (S0)
	ADDIU T0, T0, 0x1
	ANDI T0, T0, 0x3
	SW T0, o_state (S0)
	SW R0, o_timer (S0)
@endif_advance_state:

LUI AT, 0x44C8
MTC1 AT, F5
L.S F4, o_distance_to_mario (S0)
C.LE.S F4, F5
NOP
BC1F @endif_close_to_mario
	LW AT, o_angle_to_mario (S0)
	B @handle_state
	SH AT, @target_angle (S0)
@endif_close_to_mario:
	LHU T0, @target_timer (S0)
	ADDIU T0, T0, 0x1
	SH T0, @target_timer (S0)
	ORI AT, R0, 0x5A
	BNE T0, AT, @handle_state
	NOP
	JAL @generate_new_waypoint
	NOP

@handle_state:
LW T0, o_state (S0)
ORI AT, R0, 0x3
BEQ T0, AT, @fall_and_move
ORI AT, R0, 0x1
BEQ T0, AT, @rise
NOP

LH A0, @target_angle (S0)
JAL turn_move_angle_towards_target_angle
ORI A1, R0, 0x666

LW AT, o_move_angle_yaw (S0)
SW AT, o_face_angle_yaw (S0)

LW AT, o_state (S0)
BEQ AT, R0, @endif_in_air
L.S F4, o_home_y (S0)
	LUI AT, 0x4248
	MTC1 AT, F5
	NOP
	ADD.S F4, F4, F5
@endif_in_air:
S.S F4, o_y (S0)

@head_return:
SW R0, o_interaction_status (S0)
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
J obj_update_floor_and_walls
ADDIU SP, SP, 0x18

@rise:
LW T0, o_timer (S0)
SLL T1, T0, 0x3
ADDU T1, T1, T0
ADDU T0, T1, T0
MTC1 T0, F5
L.S F4, o_home_y (S0)
CVT.S.W F5, F5
ADD.S F4, F4, F5
B @head_return
S.S F4, o_y (S0)

@fall_and_move:
SW R0, o_speed_y (S0)
LUI AT, 0x41F0
SW AT, o_speed_h (S0)
JAL obj_move_standard
ADDIU A0, R0, 0xFFB2

LW T0, o_timer (S0)
SLL T1, T0, 0x3
ADDU T1, T1, T0
ADDU T0, T1, T0
ORI AT, R0, 0x32
SUBU T0, AT, T0
MTC1 T0, F5
L.S F4, o_home_y (S0)
CVT.S.W F5, F5
ADD.S F4, F4, F5
B @head_return
S.S F4, o_y (S0)

@generate_new_waypoint:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
JAL advance_rng
SH R0, @target_timer (S0)
SH V0, @target_angle (S0)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

/* Caterkiller Body script */
@beh_caterkiller_body:
.word 0x00040000
.word 0x11010001
.word 0x0C000000, @beh_caterkiller_body_init
.word 0x08000000
.word 0x0C000000, @beh_caterkiller_body_loop
.word 0x09000000

/* Caterkiller Body code */
@lead equ 0xFC

@beh_caterkiller_body_init:
LW T0, g_current_obj_ptr
LBU T1, o_arg0 (T0)
LW T2, o_parent (T0)
BEQ T1, R0, @endif_not_first_body_segment
SW T2, @lead (T0)
	SLL AT, T1, 0x2
	ADDU AT, T2, AT
	ADDIU AT, AT, 0xFFFC
	LW AT, @children (AT)
	SW AT, @lead (T0)
@endif_not_first_body_segment:
JR RA
NOP


@beh_caterkiller_body_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LI A1, @body_hitbox
JAL set_object_hitbox
SLL A0, S0, 0x0
LBU AT, o_arg0 (S0)
ANDI AT, AT, 0x1
BEQ AT, R0, @endif_match_head_y
	LW AT, o_parent (S0)
	LW AT, o_y (AT)
	SW AT, o_y (S0)
@endif_match_head_y:
SLL A0, S0, 0x0
JAL angle_to_object
LW A1, @lead (S0)
SW V0, o_face_angle_yaw (S0)
JAL angle_to_unit_vector
SLL A0, V0, 0x0
LUI AT, 0x4296
MTC1 AT, F6
LW T0, @lead (S0)
L.S F4, o_x (T0)
L.S F5, o_z (T0)
MUL.S F0, F0, F6
MUL.S F1, F1, F6
SUB.S F4, F4, F0
SUB.S F5, F5, F1
S.S F4, o_x (S0)
S.S F5, o_z (S0)

SW R0, o_interaction_status (S0)
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@head_hitbox:
.word 0x00008000
.byte 0x00
.byte 0x01
.byte 0x01
.byte 0x00
.halfword 0x0064
.halfword 0x0096
.halfword 0x0064
.halfword 0x0096

@body_hitbox:
.word 0x00000008
.byte 0x00
.byte 0x01
.byte 0x7F
.byte 0x00
.halfword 0x0064
.halfword 0x0096
.halfword 0x0064
.halfword 0x0096
