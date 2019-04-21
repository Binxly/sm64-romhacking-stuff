/* Whomp Minion Behaviour Script */
beh_whomp_minion_script:
.word 0x00090000
.word 0x110100C7
.word 0x27260000, 0x06020A04
.word 0x2A000000, 0x06020A0C
.word 0x28000000
.word 0x0C000000, @beh_whomp_minion_init
.word 0x08000000
.word 0x0C000000, @beh_whomp_minion_loop
.word 0x09000000

@o_wind_speed_x equ 0xF4
@o_wind_speed_z equ 0xF8
@o_shadow equ 0xFC

@is_being_ground_pounded equ 0x802A3754

/* Init */
@beh_whomp_minion_init:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LUI AT, 0x8036
LW S0, 0x1160 (AT)

LW T0, o_parent (S0)

LW AT, o_home_x (T0)
SW AT, o_home_x (S0)
LW AT, o_home_y (T0)
SW AT, o_home_y (S0)
LW AT, o_home_z (T0)
SW AT, o_home_z (S0)

LUI AT, 0xC080
SW AT, o_gravity (S0)

L.S F12, @o_wind_speed_z (T0)
JAL atan2s
L.S F14, @o_wind_speed_x (T0)
SLL V0, V0, 0x10
SRA V0, V0, 0x10
SW V0, o_face_angle_yaw (S0)
SW V0, o_move_angle_yaw (S0)
ORI AT, R0, 0x4000
SW AT, o_face_angle_pitch (S0)

LUI AT, 0xC28C
SW AT, o_speed_y (S0)
LUI AT, 0x41C0
JAL decompose_speed
SW AT, o_speed_h (S0)

LI AT, 0x45834000
MTC1 AT, F5
L.S F4, o_home_y (S0)
ADD.S F4, F4, F5
S.S F4, o_y (S0)


LI T0, g_mario
LUI AT, 0x4288
MTC1 AT, F6
L.S F4, o_speed_x (S0)
L.S F5, o_speed_z (S0)
MUL.S F4, F4, F6
MUL.S F5, F5, F6
L.S F6, m_x (T0)
L.S F7, m_z (T0)
SUB.S F4, F6, F4
SUB.S F5, F7, F5
S.S F4, o_x (S0)
S.S F5, o_z (S0)

JAL get_random_float
NOP
LUI AT, 0x43FA
MTC1 AT, F4
NOP
MUL.S F4, F4, F0
S.S F4, 0xFC (S0)

JAL advance_rng
NOP
JAL angle_to_unit_vector
SLL A0, V0, 0x0
L.S F4, 0xFC (S0)
MUL.S F0, F0, F4
MUL.S F1, F1, F4
L.S F4, o_x (S0)
L.S F5, o_z (S0)
ADD.S F4, F4, F0
ADD.S F5, F5, F0

LUI AT, 0x4040
MTC1 AT, F8
LI T0, g_mario
L.S F6, m_speed_x (T0)
L.S F7, m_speed_z (T0)
MUL.S F6, F6, F8
MUL.S F7, F7, F8
ADD.S F4, F4, F6
ADD.S F5, F5, F7
S.S F4, o_x (S0)
S.S F5, o_z (S0)

; spawn shadow
ORI A1, R0, 0x46
LI A2, (beh_whomp_shadow_script-0x80000000)
JAL spawn_object
SLL A0, S0, 0x0
ORI AT, R0, 0x1
SW AT, 0x144 (V0)
SW V0, @o_shadow (S0)

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

/* Loop */
@beh_whomp_minion_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LUI AT, 0x8036
LW S0, 0x1160 (AT)

ORI A0, R0, 0x1
JAL 0x8029F514
LUI A1, 0x3F80

JAL obj_update_floor_and_walls
NOP

JAL @is_being_ground_pounded
NOP
BEQ V0, R0, @endif_dead
ORI AT, R0, 0x1
	JAL 0x802A1BDC ; spawn coin
	SW AT, o_num_loot_coins (S0)
	JAL mark_object_for_deletion
	LW A0, @o_shadow (S0)
	LUI A0, 0x520C
	JAL explode_whomp
	ORI A0, A0, 0xC081
	B @endif_terminal_velocity
	NOP
@endif_dead:

L.S F12, o_x (S0)
L.S F14, o_y (S0)
LW A2, o_z (S0)
JAL find_floor
ADDIU A3, SP, 0x18

L.S F4, o_y (S0)
L.S F5, o_floor_height (S0)
C.LT.S F4, F5
NOP
BC1F @else_if_falling
	LW T0, o_speed_y (S0)
	S.S F5, o_y (S0)
	SW T0, 0x1C (SP)
	SW R0, o_speed_y (S0)
	
	; prevent Mario from being dragged along when crushed
	LI T0, g_mario
	LW T1, 0x64 (T0)
	BEQ T1, R0, @endif_crushing_mario
	NOP
		LW T1, 0x2C (T1)
		BNE T1, S0, @endif_crushing_mario
			L.S F4, o_speed_x (S0)
			L.S F5, o_speed_z (S0)
			L.S F6, m_x (T0)
			L.S F7, m_z (T0)
			SUB.S F6, F6, F4
			SUB.S F7, F7, F5
			S.S F6, m_x (T0)
			S.S F7, m_z (T0)
	@endif_crushing_mario:
	
	; delete if on death floor
	LW AT, 0x18 (SP)
	LHU T0, 0x0 (AT)
	ORI AT, R0, 0xA
	BNE T0, AT, @check_if_hard_landing
	NOP
		JAL mark_object_for_deletion
		LW A0, @o_shadow (S0)
		JAL mark_object_for_deletion
		SLL A0, S0, 0x0
@else_if_falling:
	; if the whomp hits Mario midair, take Mario down with it
	JAL pull_mario_down
	NOP
		
@endif_floor_collision:

L.S F4, o_speed_y (S0)
L.S F5, o_gravity (S0)
LUI AT, 0xC28C
MTC1 AT, F6
ADD.S F4, F4, F5
C.LT.S F4, F6
NOP
BC1F @endif_terminal_velocity
S.S F4, o_speed_y (S0)
	S.S F6, o_speed_y (S0)
@endif_terminal_velocity:

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
J process_collision
ADDIU SP, SP, 0x18

@check_if_hard_landing:
LW T0, 0x1C (SP)
LUI AT, 0xC28C
BNE T0, AT, @endif_floor_collision
	LUI A0, 0x5068
	JAL play_sound_2
	ORI A0, A0, 0xC081
	B @endif_floor_collision
	NOP
