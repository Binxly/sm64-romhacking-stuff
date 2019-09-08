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
BNE V0, R0, @@wall_found
NOP
JR RA
NOP
@@wall_found:
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
BEQ AT, R0, @@flip
NOP
	B @@return
	NEG.S F0, F0
@@flip:
	NEG.S F1, F1
	SETU AT, 0x8000
	SUBU V1, AT, V1
@@return:
SETU V0, 0x1
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18


/* collision_type_supports_wallrunning
Returns a non-zero value iff the given collision type supports wallrunning

args:
a0 [short]: surface collision type

returns:
v0 [bool]: non-zero if the surface supports wallrunning, 0 if it does not
*/
collision_type_supports_wallrunning:
@@VANISH_CAP_SURFACE equ 0x7B
@@FIRST_PAINTING_SURFACE equ 0xD3
@@LAST_PAINTING_SURFACE equ 0xFC

ANDI A0, A0, 0xFF

LW T0, (g_mario+0x4)
ANDI T0, T0, 0x2 ; non-zero if Mario has vanish cap
BEQ T0, R0, @@endif_has_vanish_cap
	SETU AT, 0x7B ; Vanish Cap Surface
	BEQ A0, AT, @@cannot_wallrun
@@endif_has_vanish_cap:

SLTI AT, A0, 0xA6 ; 0xA6 to 0xFD are related to paintings and warps
BNE AT, R0, @@not_painting
	SLTI AT, A0, 0xFE
	BNE AT, R0, @@cannot_wallrun
@@not_painting:

LI T0, @table_anti_wallrun_surfaces
LI T1, @end_table_anti_wallrun_surfaces
@@loop:
	LBU T2, 0x0 (T0)
	BNE A0, T2, @@endif_cannot_wallrun
	ADDIU T0, T0, 0x1
		@@cannot_wallrun:
		JR RA
		MOVE V0, R0
	@@endif_cannot_wallrun:
	SLTU AT, T0, T1
	BNE AT, R0, @@loop
	NOP
JR RA
SETU V0, 0x1

@table_anti_wallrun_surfaces:
.byte 0x01 ; Lava
.byte 0x13 ; Very Slippery
.byte 0x14 ; Slippery
.byte 0x2A ; Slippery With Noise #1
.byte 0x2E ; Ice
.byte 0x35 ; Slippery (Hard)
.byte 0x36 ; Very Slippery (Hard)
.byte 0x72 ; Intangible (Camera Only Collision)
.byte 0x73 ; Slippery With Noise #2
.byte 0x74 ; Slippery With Noise #3
.byte 0x75 ; Slippery With Noise #4
.byte 0x78 ; Very Slippery With Noise and No Camera Collision
.byte 0x79 ; Slippery With Noise and No Camera Collision
@end_table_anti_wallrun_surfaces:
.byte 0
.align 4
