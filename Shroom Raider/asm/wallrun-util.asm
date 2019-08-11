/* try_get_wall_angles
Check if mario is near a wall, and return the angle between Mario's facing
direction and the wall along with  a unit vector parallel to the wall with
forwards being in the direction Mario is facing

v0 [bool]: non-zero if Mario is near a wall
v1 [short]: angle between Mario's facing direction and the wall [0-0x4000]
f0 [float]: x component of the unit vector along the wall
f1 [float]: z component of the unit vector along the wall
*/
try_get_wall_angles:
LI T0, g_mario
LW V0, m_wall_ptr (T0)
BNE V0, R0, @wall_found
NOP
JR RA
NOP
@wall_found:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)
MOVE S0, T0
L.S F12, t_normal_x (V0)
L.S F14, t_normal_z (V0)
JAL atan2s
NEG.S F14, F14
MOVE A1, V0
JAL abs_angle_diff
LH A0, m_angle_yaw (S0)
MOVE V1, V0

LW T0, m_wall_ptr (S0)
L.S F0, t_normal_z (T0)
L.S F1, t_normal_x (T0)

MUL.S F4, F0, F0
MUL.S F5, F1, F1
ADD.S F4, F4, F5
SQRT.S F4, F4
DIV.S F0, F0, F4
DIV.S F1, F1, F4

SLTI AT, V1, 0x4000
BEQ AT, R0, @flip
NOP
	B @return
	NEG.S F0, F0
@flip:
	NEG.S F1, F1
	SETU AT, 0x8000
	SUBU V1, AT, V1
@return:
SETU V0, 0x1
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
