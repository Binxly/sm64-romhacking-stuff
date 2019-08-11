.definelabel beh_tutorial_checkpoint_impl, (org()-0x80000000)
;BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_EXEC @init
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@init:
SW R0, @active_tutorial_checkpoint
JR RA
NOP

@loop:
LW T0, g_current_obj_ptr
LI T1, g_mario

LUI AT, 0x4120
MTC1 AT, F6

L.S F4, m_y (T1)
L.S F5, o_y (T0)
C.LT.S F4, F5
LBU AT, o_arg1 (T0)
MTC1 AT, F7
BC1T @@return
CVT.S.W F7, F7
MUL.S F7, F7, F6
ADD.S F5, F5, F7
C.LE.S F4, F5
LBU AT, o_arg0 (T0)
BC1F @@return
MTC1 AT, F7
CVT.S.W F7, F7
MUL.S F6, F6, F7
L.S F4, m_x (T1)
L.S F7, o_x (T0)
L.S F5, m_z (T1)
L.S F8, o_z (T0)
SUB.S F4, F7, F4
SUB.S F5, F8, F5
MUL.S F4, F4, F4
MUL.S F5, F5, F5
ADD.S F4, F4, F5
MUL.S F5, F6, F6
C.LE.S F4, F5
NOP
BC1F @@return
NOP
SW T0, @active_tutorial_checkpoint
@@return:
JR RA
NOP

@active_tutorial_checkpoint:
.word 0

run_tutorial_void_check:
LI T0, g_mario
LUI AT, 0xC480
MTC1 AT, F5
L.S F4, m_y (T0)
C.LE.S F4, F5
LW T1, @active_tutorial_checkpoint
BEQ T1, R0, @void_check_return
NOP
BC1F @check_floor
NOP
@reset_to_checkpoint:
LI T0, g_mario
LW AT, @active_tutorial_checkpoint
SW AT, m_action_arg (T0)
LI AT, ACT_CHECKPOINT_RESPAWN
JR RA
SW AT, m_action (T0)
@check_floor:
LW T2, m_floor_ptr (T0)
BEQ T2, R0, @check_ceiling
ORI AT, R0, 0x30
LHU T3, t_collision_type (T2)
BEQ T3, AT, @is_reset_surface
ORI AT, R0, 0x29
BNE T3, AT, @check_ceiling
@is_reset_surface:
L.S F5, m_floor_height (T0)
C.LE.S F4, F5
NOP
BC1T @reset_to_checkpoint
NOP
@check_ceiling:
LI T0, g_mario
LW T1, m_ceiling_ptr (T0)
BEQ T1, R0, @void_check_return
ORI AT, R0, 0x29
LHU T2, t_collision_type (T1)
BNE T2, AT, @void_check_return
LI AT, 0x44936000 ; uses a hardcoded height to make things easier
MTC1 AT, F5
L.S F4, m_y (T0)
L.S F6, m_speed_y (T0)
ADD.S F4, F4, F6
C.LT.S F4, F5
NOP
BC1F @reset_to_checkpoint
NOP
@void_check_return:
JR RA
NOP
