beh_key_chest_impl:
;BHV_START OBJ_LIST_GENERIC
BHV_SET_WORD oChest_isLootedFunc, @check_looted
BHV_SET_WORD oChest_lootBehaviour, @beh_key
BHV_SET_INT oChest_lootModel, 0
BHV_JUMP beh_chest_common

@check_looted:
	LW T0, g_current_obj_ptr
	LW T1, (global_vars + gv_env_flags)
	LW AT, o_arg0 (T0)
	JR RA
	AND V0, T1, AT
	
.definelabel @beh_key, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_EXEC @set_look_target
BHV_LOOP_BEGIN
	BHV_EXEC @try_collect_key
BHV_LOOP_END

@set_look_target:
	LW T0, g_current_obj_ptr
	LW T1, o_parent (T0)
	LW T2, o_parent (T1)
	LW AT, o_x (T2)
	SW AT, o_x (T0)
	LW AT, o_y (T1)
	SW AT, o_y (T0)
	LW AT, o_z (T2)
	JR RA
	SW AT, o_z (T0)

@try_collect_key:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	JAL perspective_transform_2
	ADDIU A0, A0, o_position
	
	SLT AT, V0, R0
	BNE AT, R0, @@return
	
	LI T0, key_info
	SETU AT, KEY_COLLECTING
	SW AT, k_state (T0)
	SH V0, k_x (T0)
	SH V1, k_y (T0)
	
	LW T0, g_current_obj_ptr
	LI T1, global_vars
	
	LW T2, o_arg0 (T0)
	LW AT, gv_env_flags (T1)
	OR AT, T2, AT
	SW AT, gv_env_flags (T1)
	
	JAL save_game
	SH R0, o_active_flags (T0)
	
	LI A0, 0x2421FF81
	LW A1, g_mario_obj_ptr
	JAL set_sound
	ADDIU A1, A1, 0x54
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
