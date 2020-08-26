g_selected_item:
.word 0

pressed_pause_shim:
	LHU T0, g_level_num
	SETU AT, 0x1A
	BEQ T0, AT, @@prevent_pause
	SETU AT, 0x14
	BEQ T0, AT, @@prevent_pause
	SETU AT, 0x1B
	BEQ T0, AT, @@prevent_pause
	SETU AT, 0x1F
	BEQ T0, AT, @@prevent_pause
	LBU T0, (global_vars + gv_items)
	ANDI AT, T0, ITEM_STAR
	BEQ AT, R0, @@prevent_pause
	NOP
	J 0x802496B8
	NOP
	@@prevent_pause:
	JR RA
	MOVE V0, R0
	
pause_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)
	
	LH T0, g_play_mode
	SETU AT, PLAY_MODE_PAUSED
	BNE T0, AT, @@return
	NOP
	
	LW T0, (g_mario + m_controller)
	LHU S0, c_buttons_pressed (T0)
	
	ANDI AT, S0, C_TRIGGER_R
	BEQ AT, R0, @@endif_save_game
		LI A0, 0x701EFF81
		LUI A1, 0x8033
		JAL set_sound
		ORI A1, A1, 0x31F0
		JAL save_game
		NOP
	@@endif_save_game:
	
	ANDI AT, S0, C_TRIGGER_Z
	BEQ AT, R0, @@endif_warp
		LHU T0, g_level_num
		SETU AT, 0x10
		BNE T0, AT, @@endif_on_star_road
			@@prevent_warp:
			LI RA, @@endif_warp
			LI A0, 0x700E8081
			LUI A1, 0x8033
			J set_sound
			ORI A1, A1, 0x31F0
		@@endif_on_star_road:
		SETU AT, 0x22
		BEQ T0, AT, @@prevent_warp
			SETU A0, 0x10
			SETU A1, 1
			SETU A2, 10
			JAL 0x8024A700
			MOVE A3, R0
			MOVE A0, R0
			JAL 0x802497B8
			MOVE A1, R0
			LUI T0, 0x8034
			SH R0, 0xBACC (T0)
			LHU AT, 0xC848 (T0)
			ANDI AT, AT, 0x7FFF
			SH AT, 0xC848 (T0)
			SETS T0, -1
			SH T0, 0x803314F8
	@@endif_warp:
	
	ANDI AT, S0, C_BUTTON_D_PAD_LEFT
	BEQ AT, R0, @@endif_select_prev
		LI A0, 0x7000FF81
		LUI A1, 0x8033
		JAL set_sound
		ORI A1, A1, 0x31F0
		JAL @move_item_selection
		SETU A0, 0xFFFF
	@@endif_select_prev:
	
	ANDI AT, S0, C_BUTTON_D_PAD_RIGHT
	BEQ AT, R0, @@endif_select_next
		LI A0, 0x7000FF81
		LUI A1, 0x8033
		JAL set_sound
		ORI A1, A1, 0x31F0
		JAL @move_item_selection
		SETU A0, 1
	@@endif_select_next:
	
	ANDI AT, S0, C_BUTTON_START
	BEQ AT, R0, @@endif_unpause
		MOVE A0, R0
		JAL 0x8024B798
		MOVE A1, R0
		SETU T0, 0xFFFF
		SH T0, 0x803314F8
		SETU T0, 1
		SB T0, 0x80331470
		LI A0, 0x7003FF81
		LUI A1, 0x8033
		JAL set_sound
		ORI A1, A1, 0x31F0
		B (@@return + 4)
		SETU V0, 1
	@@endif_unpause:
	
	@@return:
	MOVE V0, R0
	LW S0, 0x10 (SP)
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@move_item_selection:
	LW T0, g_selected_item
	ADDU T0, T0, A0
	ANDI T0, T0, 0x7
	SW T0, g_selected_item
	SETU AT, 1
	SLLV T0, AT, T0
	LBU T1, (global_vars + gv_items)
	AND AT, T0, T1
	BEQ AT, R0, @move_item_selection
	NOP
	JR RA
	NOP
