.definelabel beh_chalice_of_winter_impl,(org()-0x80000000)
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_INTERACTION 0x00001000
BHV_SET_INT o_interaction_arg, 0x400
BHV_SET_HITBOX 80, 100, 50
BHV_SET_INT o_intangibility_timer, 0
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@loop:
LW A0, g_current_obj_ptr
LW T0, o_interaction_status (A0)
BEQ T0, R0, @@return
LI T0, g_mario
	SETU AT, 76
	J mark_object_for_deletion
	SB AT, m_heal_counter (T0)
@@return:
JR RA
NOP
