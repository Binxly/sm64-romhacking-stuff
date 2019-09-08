wall_collision_loop_shim:
SW T5, 0x4 (SP)

LI T0, g_mario
LI T1, ACT_WALLRUN
LW AT, m_action (T0)
BNE T1, AT, @@return
LHU AT, m_subaction (T0)
BNE AT, R0, @@return
LW T0, g_mario_obj_ptr
LW T1, g_current_obj_ptr
BNE T0, T1, @@return
NOP

ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)
SW A0, 0x18 (SP)
SW A1, 0x14 (SP)

L.S F14, t_normal_x (A2)
JAL atan2s
L.S F12, t_normal_z (A2)

LI T0, g_mario
LHU A0, m_angle_yaw (T0)
JAL abs_angle_diff
MOVE A1, V0

SETU A0, 0x4000
JAL abs_angle_diff
MOVE A1, V0

LW A1, 0x14 (SP)
LW A0, 0x18 (SP)
LW RA, 0x1C (SP)
ADDIU SP, SP, 0x20

SLTIU AT, V0, MAX_WALLRUN_ANGLE_CHANGE
BNE AT, R0, @@return
LI T0, g_mario
SETU AT, 0x1
SH AT, m_subaction (T0)

@@return:
BEQ A0, R0, @@break
LW V0, 0x4 (SP)
	J 0x803806E4
	NOP
@@break:
JR RA
ADDIU SP, SP, 0x40
