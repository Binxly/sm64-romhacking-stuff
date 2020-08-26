bobomb_held_shim:
	LW T0, g_current_obj_ptr
	LW T0, o_state (T0)
	SETU AT, 3
	BNE T0, AT, @@endif_exploding
	NOP
		J 0x802E6AF8 ;J bobomb_explode_shim
		NOP
	@@endif_exploding:
	J 0x802E7180
	NOP
	
bobomb_hit_enemy_shim:
	SW R0, o_gravity (T6)
	SW R0, o_speed_y (T6)
	SW R0, o_speed_h (T6)
	SETU AT, 5
	SW AT, o_timer (T6)
	SETU AT, 3
	J 0x802E6CE0
	SW AT, o_state (T6)

bobomb_respawn_shim:
	LW T0, g_current_obj_ptr
	LB AT, o_arg3 (T0)
	BNE AT, R0, @@abort
	NOP
		J 0x802EAF84
		NOP
	@@abort:
	JR RA
	NOP

try_pull_bomb:
; a0 = state to set Mario to (ACT_HOLD_IDLE or ACT_HOLD_WALKING)
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW A0, 0x10 (SP)
	
	LI T0, global_vars
	LBU AT, gv_items (T0)
	ANDI AT, AT, ITEM_BOMBS
	BEQ AT, R0, @@return

	LBU T1, gv_bombs (T0)
	BNE T1, R0, @@endif_out_of_bombs
		LUI A0, 0x700E
		B @@play_sound
		ORI A0, A0, 0x8081
	@@endif_out_of_bombs:
	
	ADDIU T1, T1, 0xFFFF
	SB T1, gv_bombs (T0)
	
	LW A0, g_mario_obj_ptr
	LI A2, beh_bobomb
	JAL spawn_object
	SETU A1, 0xBC
	SETU AT, 1
	SB AT, o_arg3 (V0)
	LI A0, g_mario
	SW V0, m_used_object (A0)
	SW V0, m_held_object (A0)
	LW T0, 0x98 (A0)
	SETU AT, 1
	SW AT, o_held_state (V0)
	SB AT, 0xA (T0)
	LW A1, 0x10 (SP)
	JAL set_mario_action
	MOVE A2, R0
	LI A0, 0x502F0081
	
	@@play_sound:
	LW A1, g_mario_obj_ptr
	JAL set_sound
	ADDIU A1, A1, 0x54

	@@return:
	MOVE V0, R0
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
try_stow_bomb:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW AT, m_held_object (A0)
	SW AT, 0x10 (SP)
	
	JAL drop_and_set_mario_action
	NOP
	
	LW AT, 0x10 (SP)
	BEQ AT, R0, @@return
	
	LBU T0, (global_vars + gv_items)
	ANDI AT, T0, ITEM_BOMBS
	BEQ AT, R0, @@return
	
	LI.U A0, beh_bobomb
	JAL segmented_to_virtual
	LI.L A0, beh_bobomb
	
	LW T0, 0x10 (SP)
	LW AT, o_behaviour (T0)
	BNE AT, V0, @@return
	NOP
	
	LI T1, global_vars
	LBU T2, gv_bombs (T1)
	SLTI AT, T2, 9
	BNE AT, R0, @@endif_bomb_bag_full
		LI A0, 0x700E8081
		LW A1, g_mario_obj_ptr
		JAL set_sound
		ADDIU A1, A1, 0x54
		B @@return
	@@endif_bomb_bag_full:
	
	ADDIU T2, T2, 1
	SB T2, gv_bombs (T1)
	
	SH R0, o_active_flags (T0)
	
	LI A0, 0x50190081
	LW A1, g_mario_obj_ptr
	JAL set_sound
	ADDIU A1, A1, 0x54
	
	@@return:
	SETU V0, 1
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	

/*
bobomb_explode_shim:
	J 0x802E6AF8
	NOP



	LW T0, g_current_obj_ptr
	LI T1, g_mario
	
	LW AT, m_held_object (T1)
	BNE AT, T0, @@endif_holding_bomb
		LW T1, 0x98 (T1)
		LW AT, 0x18 (T1)
		SW AT, o_x (T0)
		LW AT, 0x1C (T1)
		SW AT, o_y (T0)
		LW AT, 0x20 (T1)
		SW AT, o_z (T0)
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		JAL 0x802E7220
		NOP
		LW RA, 0x14 (SP)
		ADDIU SP, SP, 0x18
		LW T0, g_current_obj_ptr
	@@endif_holding_bomb:
	
	LI T1, g_mario
	LW AT, m_used_object (T1)
	BEQ AT, T0, @@cancel_grab
	LW AT, 0x78 (T1)
	BNE AT, T0, @@endif_cancel_grab
	LHU T2, 0x02 (T1)
	ANDI AT, T2, 0x0800
	BEQ AT, R0, @@endif_cancel_grab
	NOP
		@@cancel_grab:
		LHU AT, 0x02 (T1)
		ANDI AT, AT, 0xF7FF
		SH AT, 0x02 (T1)
		SW R0, 0x78 (T1)
		SW R0, m_used_object (T1)
	@@endif_cancel_grab:
	
	SETU AT, 3
	SW AT, o_state (T0)
	LW AT, o_flags (T0)
	ANDI AT, AT, ~OBJ_HOLDABLE
	SW AT, o_flags (T0)
	SW R0, o_interaction_status (T0)
	LI AT, INT_SOLID
	J 0x802E6AF8
	SW AT, o_interaction (T0)
	
bobomb_interaction_shim:
	LW T0, g_current_obj_ptr
	LW AT, o_flags (T0)
	ANDI AT, AT, OBJ_HOLDABLE
	BNE AT, R0, @@continue
		LI AT, INT_SOLID
		SW AT, o_interaction (T0)
	@@continue:
	LUI T6, 0x8036
	J 0x802E6BF8
	LW T6, 0x1160 (T6)
*/
