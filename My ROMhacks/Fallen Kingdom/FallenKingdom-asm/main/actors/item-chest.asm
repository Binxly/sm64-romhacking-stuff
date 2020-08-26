; a0 = flag
; a1 = model
; a2 = dialog1
; a3 = dialog2 (TODO)

beh_item_chest_impl:
;BHV_START OBJ_LIST_GENERIC
BHV_SET_WORD oChest_isLootedFunc, @check_looted
BHV_SET_WORD oChest_lootBehaviour, beh_item
BHV_EXEC @chest_init
BHV_JUMP beh_chest_common

.definelabel beh_item, (org() - 0x80000000)
BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_EXEC @item_init
BHV_LOOP_BEGIN
	BHV_ADD_INT o_face_angle_yaw, 0x400
	BHV_EXEC @item_loop
BHV_LOOP_END

@chest_init:
	LW T0, g_current_obj_ptr
	LBU AT, o_arg1 (T0)
	JR RA
	SW AT, oChest_lootModel (T0)

@check_looted:
	LW T0, g_current_obj_ptr
	LBU T0, o_arg0 (T0)
	LBU T1, (global_vars + gv_items)
	JR RA
	AND V0, T0, T1

@item_init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI.U A0, g_mario
	JAL 0x802559B0
	LI.L A0, g_mario
	
	LW T0, g_current_obj_ptr
	LBU T1, o_arg0 (T0)
	LI T2, global_vars
	LBU AT, gv_items (T2)
	OR AT, AT, T1
	SB AT, gv_items (T2)
	
	SETU AT, ITEM_BOMBS
	BNE T1, AT, @@endif_bombs
		SETU AT, 5
		SB AT, gv_bombs (T2)
	@@endif_bombs:
	
	LI A0, g_mario
	LW AT, m_x (A0)
	SW AT, o_x (T0)
	LW AT, m_z (A0)
	SW AT, o_z (T0)
	LI.S F5, 200
	L.S F4, m_y (A0)
	ADD.S F4, F4, F5
	S.S F4, o_y (T0)
	
	SH R0, m_action_timer (A0)
	LH AT, o_active_flags (T0)
	ORI AT, AT, AF_ACTIVE_IN_TIMESTOP
	SH AT, o_active_flags (T0)
	
	LI A1, ACT_ITEM_GET
	JAL set_mario_action
	LBU A2, o_arg2 (T0)
	
	JAL save_game
	NOP
	
	JAL 0x80248D78
	NOP
	
	SETU A0, 1
	SETU A1, 0xF01
	JAL 0x803219AC
	MOVE A2, R0
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@item_loop:
	LW T0, (g_mario + m_action)
	LI T1, ACT_ITEM_GET
	BEQ T0, T1, @@return
	LI T1, 0x20001305
	BEQ T0, T1, @@return
		LW A0, g_current_obj_ptr
		SH R0, o_active_flags (A0)
		LBU A1, o_arg3 (A0)
		BEQ A1, R0, @@return
		LUI A2, 0x437A
		J spawn_vivian
		NOP
	@@return:
	JR RA
	NOP
	
act_item_get_impl:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)
	
	LI S0, g_mario
	
	LW AT, m_area (S0)
	LW AT, 0x24 (AT)
	LH T1, 0x2 (AT)
	SH T1, m_angle_yaw (S0)
	
	LW T2, g_mario_obj_ptr
	SW T1, o_face_angle_yaw (T2)
	SH T1, o_gfx_angle_yaw (T2)
	
	MOVE A0, S0
	JAL set_mario_animation
	SETU A1, 0xCD
	
	LH AT, m_action_timer (S0)
	SLTI AT, AT, 40
	BNE AT, R0, @@endif_peace
		LW T0, 0x98 (S0)
		SETU AT, 2
		SB AT, 0x6 (T0)
	@@endif_peace:
	
	LH AT, m_action_timer (S0)
	ADDIU AT, AT, 1
	SH AT, m_action_timer (S0)
	
	SLTI AT, AT, 80
	BNE AT, R0, @@return
		MOVE A0, S0
		LI A1, 0x20001305
		JAL set_mario_action
		LW A2, m_action_arg (S0)
		
		JAL 0x80248DC0
		NOP
		
		LW T0, (g_mario + m_area)
		LHU A1, 0x38 (T0)
		MOVE A0, R0
		JAL set_music
		MOVE A2, R0
		
	@@return:
	MOVE V0, R0
	LW S0, 0x10 (SP)
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
