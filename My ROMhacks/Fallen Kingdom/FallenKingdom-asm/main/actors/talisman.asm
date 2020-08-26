beh_talisman_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_INTERACTION INT_COIN
BHV_SET_HITBOX 50, 100, 50
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INT o_collision_damage, 24
BHV_BILLBOARD
BHV_EXEC @talisman_init
BHV_LOOP_BEGIN
	BHV_EXEC @talisman_loop
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

@talisman_init:
	LW T0, g_current_obj_ptr
	
	LBU T1, (global_vars + gv_talismans)
	LBU AT, o_arg0 (T0)
	AND AT, T1, AT
	BEQ AT, R0, @@endif_collected
	NOP
		SH R0, o_active_flags (T0)
	@@endif_collected:
	JR RA
	NOP
	
@talisman_loop:
	LW T0, g_current_obj_ptr
	
	LW AT, o_state (T0)
	BNE AT, R0, @@endif_idle
		LW AT, o_interaction_status (T0)
		BEQ AT, R0, @@return
		SETU AT, 1
		SW AT, o_state (T0)
		LHU AT, o_gfx_flags (T0)
		ORI AT, AT, 0x10
		SH AT, o_gfx_flags (T0)
		SW R0, o_interaction (T0)
		SETS AT, -1
		SW AT, o_intangibility_timer (T0)
		LH AT, o_active_flags (T0)
		ORI AT, AT, AF_ACTIVE_IN_TIMESTOP
		J @collect_talisman
		SH AT, o_active_flags (T0)
	@@endif_idle:
	
	LW T1, o_state (T0)
	SETU AT, 1
	BNE T1, AT, @@endif_hidden
		LW AT, o_timer (T0)
		SLTIU AT, AT, 40
		BNE AT, R0, @@return
		LI T1, g_mario
		LW AT, m_x (T1)
		SW AT, o_x (T0)
		LW AT, m_z (T1)
		SW AT, o_z (T0)
		LI.S F5, 200
		L.S F4, m_y (T1)
		ADD.S F4, F4, F5
		S.S F4, o_y (T0)
		LHU AT, o_gfx_flags (T0)
		ANDI AT, AT, 0xFFEF
		SH AT, o_gfx_flags (T0)
		SETU AT, 2
		B @@return
		SW AT, o_state (T0)
	@@endif_hidden:
	
	LW T1, (g_mario + m_action)
	LI T2, ACT_ITEM_GET
	BEQ T1, T2, @@return
	LI T2, 0x20001305
	BEQ T1, T2, @@return
	NOP
	
	J @save_and_warp
	SH R0, o_active_flags (T0)
	
	@@return:
	JR RA
	NOP

@collect_talisman:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	SETU A0, 1
	SETU A1, 0xF01
	JAL 0x803219AC
	MOVE A2, R0
	
	LI.U A0, g_mario
	JAL 0x802559B0
	LI.L A0, g_mario
	
	LI A0, g_mario
	LI A1, ACT_ITEM_GET
	LW T0, g_current_obj_ptr
	JAL set_mario_action
	LBU A2, o_arg3 (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@save_and_warp:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LI T1, global_vars
	LBU T0, o_arg0 (T0)
	LBU AT, gv_talismans (T1)
	OR T0, T0, AT
	JAL save_game
	SB T0, gv_talismans (T1)
	
	LW T0, g_current_obj_ptr
	LBU A0, o_arg1 (T0)
	SETU A1, 1
	LBU A2, o_arg2 (T0)
	JAL 0x8024A700
	MOVE A3, R0
	
	LI A1, 0xFFFFFFFF
	JAL 0x802497B8
	MOVE A0, R0
	
	LUI T0, 0x8034
	SH R0, 0xBACC (T0)
	LHU AT, 0xC848 (T0)
	ANDI AT, AT, 0x7FFF
	SH AT, 0xC848 (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
