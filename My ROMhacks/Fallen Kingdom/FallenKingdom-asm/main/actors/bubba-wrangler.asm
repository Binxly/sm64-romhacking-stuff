beh_bubba_wrangler_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_EXEC @spawn_bubba
BHV_LOOP_BEGIN
	BHV_EXEC @wrangle_bubba
BHV_LOOP_END

@spawn_bubba:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LI A2, 0x130055DC
	JAL spawn_object
	SETU A1, 89
	
	LW T0, g_current_obj_ptr
	SW V0, 0xF4 (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@wrangle_bubba:
	LW T0, g_current_obj_ptr
	LW T0, 0xF4 (T0)
	LI.S F5, -4500
	L.S F4, o_z (T0)
	MIN.S F4, F4, F5
	JR RA
	S.S F4, o_z (T0)
