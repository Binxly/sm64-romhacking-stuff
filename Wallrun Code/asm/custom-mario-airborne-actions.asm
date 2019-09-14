.definelabel ACT_WALLRUN,0x00000884

should_bonk_off_unreferenced_wall:
.word 0

mario_air_actions_shim:
LI T0, g_mario
LW T0, m_action (T0)

LI AT, ACT_WALLRUN
BEQ T0, AT, @wallrun
NOP

J 0x8026FB04
NOP

@wallrun:
ADDIU SP, SP, 0xFFD8
SW RA, 0x24 (SP)
SW S0, 0x20 (SP)

LI S0, g_mario

SH R0, m_subaction (S0)

LHU A0, m_action_timer (S0)
SETU AT, MAX_WALLRUN_TIME
BEQ A0, AT, @fall
ADDIU A0, A0, 0x1
SH A0, m_action_timer (S0)

JAL try_get_wall_angles
NOP

BEQ V0, R0, @fall
SLTI AT, V1, MAX_WALLRUN_ANGLE_CHANGE
BEQ AT, R0, @fall
LW T0, m_wall_ptr (S0)
BEQ T0, R0, @fall
LHU A0, t_collision_type (T0)
JAL collision_type_supports_wallrunning
NOP
BEQ V0, R0, @fall


LW T0, m_controller (S0)
BEQ T0, R0, @endif_wallkick
NOP
LHU T0, c_buttons_pressed (T0)
; Fall if the Z trigger is pressed
ANDI T1, T0, C_TRIGGER_Z
BNE T1, R0, @delayed_fall
@endif_drop_off:
; Wall kick if A button pressed
ANDI T0, T0, C_BUTTON_A
BEQ T0, R0, @endif_wallkick
	MOVE A0, S0
	LI A1, 0x03000886 ; ACT_WALLJUMP
	JAL set_mario_action
	MOVE A2, R0
	SB R0, 0x2A (S0) ; wall kick timer
	LUI AT, 0x4278
	SW AT, m_speed_y (S0)
	LW T0, m_wall_ptr (S0)
	L.S F14, t_normal_x (T0)
	JAL atan2s
	L.S F12, t_normal_z (T0)
	MOVE A1, V0
	LH A0, m_angle_yaw (S0)
	JAL turn_angle
	SETU A2, 0x1C72
	SH V0, m_angle_yaw (S0)
	SH V0, 0x24 (S0)
	LUI AT, 0x41C0
	MTC1 AT, F5
	L.S F4, m_speed_h (S0)
	C.LT.S F4, F5
	NOP
	BC1F @endif_needs_speedup
	NOP
		S.S F5, m_speed_h (S0)
	@endif_needs_speedup:
	LUI A0, 0x2400
	ORI A0, A0, 0x8081
	LW A1, g_mario_obj_ptr
	JAL set_sound
	ADDIU A1, A1, 0x54
	B @return
	SETU V0, 0x1
@endif_wallkick:

L.S F6, m_speed_h (S0)
MUL.S F4, F0, F6
MUL.S F5, F1, F6
S.S F4, m_speed_x (S0)
SW R0, m_speed_y (S0)
S.S F5, m_speed_z (S0)
MOV.S F12, F1
JAL atan2s
MOV.S F14, F0
SH V0, m_angle_yaw (S0)
SH V0, 0x24 (S0)
LW T0, g_mario_obj_ptr
SW V0, o_face_angle_yaw (T0)
SW V0, o_move_angle_yaw (T0)
SH V0, o_gfx_angle_yaw (T0)

LW T0, m_wall_ptr (S0)
L.S F4, m_speed_z (S0)
L.S F5, t_normal_x (T0)
L.S F6, m_speed_x (S0)
L.S F7, t_normal_z (T0)
MUL.S F4, F4, F5
MUL.S F5, F6, F7
MTC1 R0, F6
SUB.S F4, F4, F5
C.LT.S F4, F6

SETU T0, 0x1000
BC1T @endif_tilt_left
NOP
	SUBU T0, R0, T0
@endif_tilt_left:
SH T0, 0x1C (SP)
LW AT, m_speed_h (S0)
SW AT, 0x10 (SP)
LW T0, m_wall_ptr (S0)
LW AT, t_normal_x (T0)
SW AT, 0x14 (SP)
LW AT, t_normal_z (T0)
SW AT, 0x18 (SP)

LI A1, 0x04000440 ; change to walking state when touching ground
SETU A2, 0x72 ; running animation
SETU A3, 0x1 ; allow ledge grabs from this state
JAL 0x8026B444
MOVE A0, S0

BNE V0, R0, @return
MOVE V0, R0

LHU AT, m_subaction (S0)
BNE AT, R0, @fall

LW AT, 0x10 (SP)
SW AT, m_speed_h (S0)

LH T1, 0x1C (SP)
SH T1, m_angle_roll (S0)

LW T0, g_mario_obj_ptr
LUI AT, 0x8
SW AT, 0x48 (T0)
SW T1, o_face_angle_roll (T0)
SH T1, o_gfx_angle_roll (T0)

LI.S F6, 25
L.S F4, 0x14 (SP)
L.S F5, 0x18 (SP)
MUL.S F4, F4, F6
MUL.S F5, F5, F6
L.S F6, m_x (S0)
L.S F7, m_z (S0)
SUB.S F4, F6, F4
SUB.S F5, F7, F5
S.S F4, m_x (S0)
S.S F5, m_z (S0)
LW T0, g_mario_obj_ptr
S.S F4, o_gfx_x (T0)
S.S F5, o_gfx_z (T0)

LW AT, m_wall_ptr (S0)
BNE AT, R0, @return
MOVE V0, R0

; If rounding errors have caused Mario to move slightly out of range of the wall,
; perform another wall check and update the wall pointer
S.S F4, 0x10 (SP)
S.S F5, 0x18 (SP)
LW AT, m_y (S0)
SW AT, 0x14 (SP)
ADDIU A0, SP, 0x10
MOVE A1, R0
JAL 0x80251A48
LUI A2, 0x41F0
SW V0, m_wall_ptr (S0)

B @return
MOVE V0, R0

@bonk:
B (@fall+0x8)
SETU A1, 0x8A7 ; bonk off wall

@fall:
LI A1, 0x0100088C ; freefall
MOVE A0, S0
JAL set_mario_action
MOVE A2, R0
SETU V0, 0x1

@return:
LW S0, 0x20 (SP)
LW RA, 0x24 (SP)
JR RA
ADDIU SP, SP, 0x28

@delayed_fall:
MOVE A0, S0
LI A1, 0x0100088C ; freefall
JAL set_mario_action
MOVE A2, R0
B @return
MOVE V0, R0
