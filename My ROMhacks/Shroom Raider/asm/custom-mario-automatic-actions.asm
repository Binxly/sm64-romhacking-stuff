.definelabel ACT_FROZEN,0x00000346

mario_automatic_actions_shim:
LI T0, g_mario
LW T1, m_action (T0)
LI AT, ACT_FROZEN
BEQ T1, AT, @frozen
NOP
J 0x802605D0
NOP

@frozen:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

SETU T0, 0x1
SB T0, show_struggle_prompt

LI T0, g_mario
LHU T1, m_health (T0)
SLTI AT, T1, 0x100
BNE AT, R0, @@break_free

LW T1, g_mario_obj_ptr
LH AT, m_action_timer (T0)
BNE AT, R0, @@endif_init
	LHU AT, o_animation_frame (T1)
	SH AT, m_action_state (T0)
@@endif_init:
SW R0, 0x44 (T1)
SW R0, 0x48 (T1)
LHU AT, m_action_state (T0)
SH AT, o_animation_frame (T1)

LH AT, m_angle_pitch (T0)
SH AT, o_gfx_angle_pitch (T1)
LH AT, m_angle_yaw (T0)
SH AT, o_gfx_angle_yaw (T1)
LH AT, m_angle_roll (T0)
SH AT, o_gfx_angle_roll (T1)

ADDIU A0, T0, m_x
JAL copy_vector
ADDIU A1, T1, o_x

LI T0, g_mario
LW T1, m_controller (T0)

LUI AT, 0x4100
MTC1 AT, F5
L.S F4, c_analog_float_mag (T1)
C.LT.S F4, F5
LHU T2, (m_action_arg+0x2) (T0)
BC1F @@endif_stick_is_neutral
	SETU AT, 0x1
	SH AT, (m_action_arg+0x2) (T0)
@@endif_stick_is_neutral:
LUI AT, 0x424
MTC1 AT, F5
BEQ T2, R0, @@endif_stick_input
C.LE.S F4, F5
LHU T2, m_action_arg (T0)
BC1T @@endif_stick_input
ADDIU T2, T2, 0x1
	SH T2, m_action_arg (T0)
	B @@endif_a_pressed
	SH R0, (m_action_arg+0x2) (T0)
@@endif_stick_input:

LHU T2, c_buttons_pressed (T1)
ANDI T2, T2, C_BUTTON_A
BEQ T2, R0, @@endif_a_pressed
	LHU T3, m_action_arg (T0)
	ADDIU T3, T3, 0x1
	SH T3, m_action_arg (T0)
@@endif_a_pressed:

LHU T1, m_action_arg (T0)
SLTI AT, T1, 20
BNE AT, R0, @@endif_break_free
	@@break_free:
	SETU AT, 90
	SH AT, m_hitstun (T0)
	MOVE A0, T0
	LI A1, 0x010208B6 ; ACT_SOFT_BONK
	JAL set_mario_action
	MOVE A2, R0
	B @@return
	SETU V0, 0x1
@@endif_break_free:

LHU T1, m_action_timer (T0)
ADDIU T1, T1, 0x1
SH T1, m_action_timer (T0)
ANDI T1, T1, 0x3
BNE T1, R0, @@endif_frost_dot
	LBU T1, m_hurt_counter (T0)
	ADDIU T1, T1, 0x1
	SB T1, m_hurt_counter (T0)
@@endif_frost_dot:

MOVE A0, T0
JAL 0x80256B24
MOVE A1, R0

SETU AT, 0x1
BNE V0, AT, @@return
MOVE V0, R0
	LI T0, g_mario
	SW R0, m_speed_x (T0)
	SW R0, m_speed_y (T0)
	SW R0, m_speed_z (T0)
	SW R0, m_speed_h (T0)

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18


interact_freezing_wind:
LH T0, g_is_invulnerable
BNE T0, R0, @@return
LI T0, g_mario
LH AT, m_hitstun (T0)
BNE AT, R0, @@return
LW T1, m_action (T0)
LI T2, ACT_FROZEN
BEQ T1, T2, @@return
MOVE A0, T0
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
MOVE A1, T2
JAL set_mario_action
MOVE A2, R0
LW A0, g_mario_obj_ptr
LI A2, beh_ice_cube
JAL spawn_object
SETU A1, 0x50
SETU V0, 0x1
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
@@return:
JR RA
MOVE V0, R0
