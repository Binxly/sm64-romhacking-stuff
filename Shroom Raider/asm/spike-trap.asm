check_for_spike_trap:
LI T0, g_mario
LW T1, m_action (T0)
LI AT, ACT_IMPALED
BEQ T1, AT, @@return
LW T1, m_floor_ptr (T0)
BEQ T1, R0, @@return
LUI AT, 0x4000
MTC1 AT, F6
L.S F4, m_y (T0)
L.S F5, m_floor_height (T0)
SUB.S F4, F4, F5
ABS.S F4, F4
C.LE.S F4, F6
LH T1, t_collision_type (T1)
BC1F @@return
SETU AT, 0x26
BNE T1, AT, @@return
MOVE A0, T0
LI A1, ACT_IMPALED
J set_mario_action
MOVE A2, R0
@@return:
JR RA
NOP
