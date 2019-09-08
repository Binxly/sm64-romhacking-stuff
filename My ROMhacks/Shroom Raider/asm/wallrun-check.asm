wallrun_check:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)

LI T0, g_mario
LW T1, m_action (T0)
LI AT, 0x03000880 ; Single Jump
BEQ T1, AT, @check_speed
LI AT, 0x03000881 ; Double Jump
BEQ T1, AT, @check_speed
;LI AT, 0x01000882 ; Triple Jump
;BEQ T1, AT, @check_speed
LI AT, 0x03000886 ; Walljump
BEQ T1, AT, @check_speed
LI AT, 0x03000888 ; Longjump
BNE T1, AT, @return

; check horizontal speed (require 15 or more horizontal speed, and 25 or less vertical speed)
@check_speed:
LUI AT, 0x4170
MTC1 AT, F5
L.S F4, m_speed_h (T0)
C.LT.S F4, F5
LUI AT, 0x41C8
BC1T @return
MTC1 AT, F5
L.S F4, m_speed_y (T0)
ABS.S F4, F4
C.LE.S F4, F5
NOP
BC1F @return
NOP

JAL try_get_wall_angles
NOP

BEQ V0, R0, @return
NOP

SLTI AT, V1, 0x38E
BNE AT, R0, @return

SLTI AT, V1, 0x2000
BEQ AT, R0, @return

; Do not wallrun if the wall is ice or lava
LI T0, g_mario
LW T1, m_wall_ptr (T0)
LHU T1, t_collision_type (T1)
SETU AT, 0x1
BEQ T1, AT, @return
SETU AT, 0x2E
BEQ T1, AT, @return

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
LI AT, ACT_WALLRUN
SW AT, m_action (T0)
SH R0, m_action_timer (T0)

@return:
LW RA, 0x1C (SP)
JR RA
ADDIU SP, SP, 0x20
