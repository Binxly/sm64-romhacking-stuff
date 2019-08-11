; When jumping off a platform that is moving vertically, the platform's vertical
; velocity should be added to Mario's initial jumping speed

jump_inertia_fix_shim:
LI T0, g_mario
LW T1, m_floor_ptr (T0)
BEQ T1, R0, @@return
NOP
LW T1, t_object (T1)
BEQ T1, R0, @@return
L.S F4, m_speed_y (T0)
L.S F5, o_speed_y (T1)
ADD.S F4, F4, F5
S.S F4, m_speed_y (T0)
@@return:
JR RA
NOP

; When Mario is moving upwards, do not allow him to enter the landing state on
; platforms (fixes jump getting eaten when jumping off a plaform moving upwards)

sticky_floor_fix_shim:
LI T0, g_mario
MTC1 R0, F5
L.S F4, m_speed_y (T0)
C.LE.S F4, F5
LW T1, m_floor_ptr (T0)
BC1T @@return
LW T1, t_object (T1)
BEQ T1, R0, @@return
NOP
SETU V0, 0x0
@@return:
J 0x802564CC
NOP
