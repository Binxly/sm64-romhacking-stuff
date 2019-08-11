; Hah! You've activated my trap card!
@beh_spike_trap:
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_AUTO_MOVE_Y
BHV_DROP_TO_FLOOR
BHV_ADD_FLOAT o_y, -150
BHV_SET_FLOAT o_speed_y, 30
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@loop:
LW T0, g_current_obj_ptr
LW T1, o_timer (T0)
SLTI AT, T1, 5
BEQ AT, R0, @@endif_rising
	LUI AT, 0x41C8
	MTC1 AT, F5
	LW T2, g_mario_obj_ptr
	L.S F4, o_gfx_y (T2)
	ADD.S F4, F4, F5
	S.S F4, o_gfx_y (T2)
@@endif_rising:
SETU AT, 5
BNE T1, AT, @@endif_stop
SETU AT, 30
	SW R0, o_speed_y (T0)
@@endif_stop:
BNE T1, AT, @@endif_retract
	LUI AT, 0xC120
	SW AT, o_speed_y (T0)
@@endif_retract:
SLTI AT, T1, 30
BNE AT, R0, @@endif_pull_mario_down
SLTI AT, T1, 35
BEQ AT, R0, @@endif_pull_mario_down
	LW T2, g_mario_obj_ptr
	L.S F4, o_gfx_y (T2)
	L.S F5, o_speed_y (T0)
	ADD.S F4, F4, F5
	S.S F4, o_gfx_y (T2)
@@endif_pull_mario_down:
SLTI AT, T1, 45
BNE AT, R0, @@return
NOP
	J mark_object_for_deletion
	MOVE A0, T0
@@return:
JR RA
NOP

check_for_hidden_spike_trap:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LI T0, g_mario
LW T1, m_action (T0)
LI T2, ACT_IMPALED
BEQ T1, T2, @@return
LW T1, m_floor_ptr (T0)
BEQ T1, R0, @@return
L.S F4, m_y (T0)
L.S F5, m_floor_height (T0)
LUI AT, 0x4080
MTC1 AT, F6
SUB.S F4, F4, F5
ABS.S F4, F4
C.LT.S F4, F6
LHU T1, t_collision_type (T1)
BC1F @@return
SETU AT, 0xFF
BNE T1, AT, @@return
MOVE A0, T0
MOVE A1, T2
JAL set_mario_action
MOVE A2, R0
LW A0, g_mario_obj_ptr
LI A2, (@beh_spike_trap-0x80000000)
JAL spawn_object
SETU A1, 0x4A
SW V0, 0x10 (SP)
LI T0, g_mario
JAL angle_to_unit_vector
LH A0, m_angle_yaw (T0)
LUI AT, 0x41C8
MTC1 AT, F4
LI T0, g_mario
MUL.S F0, F0, F4
MUL.S F1, F1, F4
L.S F4, m_x (T0)
L.S F5, m_z (T0)
ADD.S F4, F4, F0
ADD.S F5, F5, F1
LW T0, 0x10 (SP)
S.S F4, o_x (T0)
S.S F5, o_z (T0)

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
