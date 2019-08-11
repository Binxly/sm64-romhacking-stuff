.definelabel beh_door_impl,(org()-0x80000000)
; BHV_STAR OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_COLLISION door_collision
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC process_collision
BHV_LOOP_END

@loop:
LW T0, g_current_obj_ptr
LW AT, o_state (T0)
BNE AT, R0, @@endif_idle
LUI AT, 0x40A0
	@@return:
	JR RA
@@endif_idle:
MTC1 AT, F5
L.S F4, o_y (T0)
ADD.S F4, F4, F5
S.S F4, o_y (T0)
LW T1, o_timer (T0)
SLTI AT, T1, 80
BNE AT, R0, @@return
MOVE A0, T0
J mark_object_for_deletion
NOP
