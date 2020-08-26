beh_fakeout_boss_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_STORE_DISTANCE_TO_MARIO
BHV_EXEC @check_flags
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@check_flags:
	LBU T0, (global_vars + gv_talismans)
	ANDI T0, T0, TALISMAN_METAL
	BEQ T0, R0, @@return
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@return:
	JR RA
	NOP
	
@loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LW T0, g_current_obj_ptr
	LW AT, o_state (T0)
	
	BNE AT, R0, @@endif_not_triggered
		LI.S F5, 2500
		L.S F4, o_distance_to_mario (T0)
		C.LE.S F4, F5
		MOVE A0, T0
		BC1F @@return
		SETU AT, 1
		SW AT, o_state (T0)
		LI A2, 0x1300472C
		JAL spawn_object
		SETU A1, 0xC0
		MOVE A0, R0
		SETU A1, 10
		JAL set_music
		MOVE A2, R0
		B @@return
		NOP
	@@endif_not_triggered:
	
	LUI A0, 0x1300
	JAL get_nearest_object_with_behaviour
	ORI A0, A0, 0x472C
	
	BNE V0, R0, @@return
	
	LW T0, g_current_obj_ptr
	SH R0, o_active_flags (T0)
	
	MOVE A0, R0
	SETU A1, 6
	JAL set_music
	MOVE A2, R0
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
