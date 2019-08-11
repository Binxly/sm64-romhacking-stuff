.definelabel beh_barrier_impl, (org()-0x80000000)
; BHV_START OBJ_LIST_LEVEL
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@loop:
LI T0, g_mario
LW T1, g_current_obj_ptr
L.S F4, m_y (T0)
L.S F5, o_y (T1)
C.LT.S F4, F5
L.S F4, m_x (T0)
BC1T @@return
L.S F5, o_x (T1)
C.LT.S F4, F5
NOP
BC1F @@return
NOP
S.S F5, m_x (T0)
@@return:
JR RA
NOP
