wallrun_check:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)

LI T0, g_mario
LW T1, m_action (T0)
LI AT, 0x03000880 ; Single Jump
BEQ T1, AT, @@check_speed
LI AT, 0x03000881 ; Double Jump
BEQ T1, AT, @@check_speed
LI AT, 0x03000886 ; Walljump
BEQ T1, AT, @@check_speed
LI AT, 0x03000888 ; Longjump
BNE T1, AT, @@return

@@check_speed:
LI.S F5, MIN_WALLRUN_H_SPEED
L.S F4, m_speed_h (T0)
C.LT.S F4, F5
NOP
BC1T @@return
LI.S F5, MAX_WALLRUN_V_SPEED
L.S F4, m_speed_y (T0)
ABS.S F4, F4
C.LE.S F4, F5
NOP
BC1F @@return
NOP

JAL try_get_wall_angles
NOP

BEQ V0, R0, @@return
NOP

SLTI AT, V1, MIN_WALLRUN_ANGLE
BNE AT, R0, @@return

SLTI AT, V1, MAX_WALLRUN_ANGLE
BEQ AT, R0, @@return

; Do not wallrun if the wall is ice or lava
LI T0, g_mario
LW T0, m_wall_ptr (T0)
JAL collision_type_supports_wallrunning
LHU A0, t_collision_type (T0)
BEQ V0, R0, @@return

LI T0, g_mario
L.S F6, m_speed_h (T0)
MUL.S F4, F0, F6
MUL.S F5, F1, F6
S.S F4, m_speed_x (T0)
S.S F5, m_speed_z (T0)
SW R0, m_speed_y (T0)
MOV.S F12, F1
JAL atan2s
MOV.S F14, F0
LI T0, g_mario
SH V0, m_angle_yaw (T0)
SH V0, 0x24 (T0)
MOVE A0, T0
LI A1, ACT_WALLRUN
JAL set_mario_action
MOVE A2, R0

@@return:
LW RA, 0x1C (SP)
JR RA
ADDIU SP, SP, 0x20
