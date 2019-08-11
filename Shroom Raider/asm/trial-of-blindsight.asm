is_mario_blinded:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

JAL is_mario_voiding_out
NOP
BNE V0, R0, @@return
LI T0, g_mario
LW T1, m_floor_ptr (T0)
BEQ T1, R0, @@return
LW T2, m_action (T0)
LI T3, ACT_IMPALED
BEQ T2, T3, @@return
LW T2, m_floor_height (T0)
LW T3, m_y (T0)
BNE T2, T3, @@endif_on_ground
	LH T1, t_collision_type (T1)
	BEQ T1, R0, @@return
@@endif_on_ground:
LW T1, g_current_obj_ptr
SW T1, 0x10 (SP)
SW T0, g_current_obj_ptr
LI.U A0, beh_trial_of_blindsight
JAL get_nearest_object_with_behaviour
LI.L A0, beh_trial_of_blindsight
LW T0, 0x10 (SP)
BEQ V0, R0, @@return
SW T0, g_current_obj_ptr
L.S F4, o_y (V0)
LI T0, g_mario
L.S F5, m_y (T0)
C.LT.S F5, F4
LW AT, o_arg0 (V0)
BC1T @@return
SW AT, 0x10 (SP)
LW A0, g_mario_obj_ptr
JAL get_dist_2d
MOVE A1, V0
L.S F4, 0x10 (SP)
C.LE.S F0, F4
NOP
BC1T (@@return+0x4)
SETU V0, 0x1
@@return:
SETU V0, 0x0
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
