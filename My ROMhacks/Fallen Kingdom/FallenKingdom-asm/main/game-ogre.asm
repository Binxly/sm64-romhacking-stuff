@ogre_state:
.byte 0 :: @selected_option equ 0
.byte 1 :: @stick_was_neutral equ 1
.byte 0 :: @long_hold equ 2
.byte 0 :: @hold_timer equ 3

@DEADZONE equ 27
@HOLD_TIMER_SHORT equ 5
@HOLD_TIMER_LONG equ 15

game_ogre_init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI A0, g_mario
	LI A1, ACT_NOP
	JAL set_mario_action
	MOVE A2, R0
	LI A0, g_mario
	JAL set_mario_animation
	SETU A1, 99
	
	LUI T0, 0x0001
	SW T0, @ogre_state
	
	LI A0, 0x2431FF81
	LUI A1, 0x8033
	JAL set_sound
	ORI A1, A1, 0x31F0
	
	LUI T0, 0x8034
	LHU AT, 0xB26A (T0)
	ANDI AT, AT, 0xFFF7
	SH AT, 0xB26A (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@process_inputs:
	LI T0, @ogre_state
	LW T1, (g_mario + m_controller)
	LH T1, c_analog_short_y (T1)
	MOVE V1, R0
	
	ABS T2, T1
	SLTIU A0, T2, @DEADZONE
	BNE A0, R0, @@endif_holding_direction
	LBU AT, @stick_was_neutral (T0)
		BEQ AT, R0, @@endif_first_tilt
		LBU T3, @long_hold (T0)
			B @@move_selection
			SH R0, @long_hold (T0)
		@@endif_first_tilt:
		BEQ T3, R0, @@endif_long_hold
		SETU T3, @HOLD_TIMER_LONG
			SETU T3, @HOLD_TIMER_SHORT
		@@endif_long_hold:
		LBU AT, @hold_timer (T0)
		ADDIU AT, AT, 1
		SB AT, @hold_timer (T0)
		SLTU AT, AT, T3
		BNE AT, R0, @@endif_timer_done
		SETU AT, 1
			SB AT, @long_hold (T0)
			B @@move_selection
			SB R0, @hold_timer (T0)
		@@endif_timer_done:
	@@endif_holding_direction:
	
	LW T1, (g_mario + m_controller)
	LHU T1, c_buttons_pressed (T1)
	ANDI AT, T1, C_BUTTON_D_PAD_UP
	BEQ AT, R0, @@endif_dpad_up
	ANDI AT, T1, C_BUTTON_D_PAD_DOWN
		LBU AT, @selected_option (T0)
		ADDIU AT, AT, 0xFFFF
		B @@clamp_selection
		SB AT, @selected_option (T0)
	@@endif_dpad_up:
	BEQ AT, R0, @@return
	LBU AT, @selected_option (T0)
		ADDIU AT, AT, 1
		B @@clamp_selection
		SB AT, @selected_option (T0)
	
	@@return:
	SB A0, @stick_was_neutral (T0)
	LW V0, (g_mario + m_controller)
	LHU V0, c_buttons_pressed (V0)
	JR RA
	ANDI V0, V0, C_BUTTON_A
	
	@@move_selection:
		BEQ T1, T2, @@endif_down
		LBU AT, @selected_option (T0)
			B @@endif_up
			ADDIU AT, AT, 1
		@@endif_down:
			ADDIU AT, AT, 0xFFFF
		@@endif_up:
		B @@clamp_selection
		SB AT, @selected_option (T0)
		
	@@clamp_selection:
		LB T3, @selected_option (T0)
		SETU AT, 3
		ADDU T3, AT
		DIVU T3, AT
		SETU V1, 1
		MFHI AT
		B @@return
		SB AT, @selected_option (T0)

game_ogre_render:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_mario_obj_ptr
	BEQ T0, R0, @@return
	
	LHU T0, g_level_num
	SETU AT, 0x1A
	BNE T0, AT, @@return
	
	LHU T0, 0x8033B238
	SETU AT, 4
	BEQ T0, AT, @@endif_not_warping
	
	LHU T0, 0x8033B252
	BNE T0, R0, @@endif_not_warping
	NOP
		; TODO: also need to check for continue
		JAL @process_inputs
		NOP
		
		BEQ V1, R0, @@endif_play_sound
		SW V0, 0x10 (SP)
			LI A0, 0x7000F881
			LUI A1, 0x8033
			JAL set_sound
			ORI A1, A1, 0x31F0
			LW V0, 0x10 (SP)
		@@endif_play_sound:
		
		BEQ V0, R0, @@endif_not_warping
		NOP
			JAL @process_selection
			NOP
	@@endif_not_warping:
	
	LUI A0, 0xFFFF
	JAL begin_print_encoded_text
	ORI A0, A0, 0xFFFF
	
	LI A2, @txt_save_continue
	SETU A0, 20
	JAL print_encoded_text
	SETU A1, 180
	
	LI A2, @txt_continue
	SETU A0, 20
	JAL print_encoded_text
	SETU A1, 164
	
	LI A2, @txt_save_quit
	SETU A0, 20
	JAL print_encoded_text
	SETU A1, 148
	
	LI A2, @txt_arrow
	SETU A0, 10
	SETU A1, 180
	LBU T0, (@ogre_state + @selected_option)
	SLL AT, T0, 4
	JAL print_encoded_text
	SUBU A1, A1, AT
	
	JAL end_print_encoded_text
	NOP
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@txt_save_continue:
.string "SAVE AND CONTINUE"
@txt_continue:
.string "CONTINUE WITHOUT SAVING"
@txt_save_quit:
.string "SAVE AND QUIT"
@txt_arrow:
.string ">"
.align 4

@process_selection:
	LI T0, @@action_table
	LBU T1, (@ogre_state + @selected_option)
	SLL AT, T1, 2
	ADDU AT, T0, AT
	LW AT, 0x0 (AT)
	JR AT
	NOP

@@action_table:
.word @save_and_continue
.word @continue_without_saving
.word @save_and_quit

@save_and_continue:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	JAL save_game
	NOP

	JAL @continue_without_saving
	NOP
	
	LHU T0, (global_vars + sv_health)
	MAXI T0, T0, 0x6FF
	SH T0, (g_mario + m_health)

	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@continue_without_saving:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI A0, 0x203FFF81
	LUI A1, 0x8033
	JAL set_sound
	ORI A1, A1, 0x31F0
	
	LHU A0, (global_vars + sv_level)
	SETU A1, 1
	SETU A2, 10
	JAL 0x8024A700
	MOVE A3, R0
	
	MOVE A0, R0
	JAL 0x802497B8
	MOVE A1, R0
	
	SH R0, 0x8033BACC
	SETU T0, 0x6FF
	SH T0, (g_mario + m_health)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@save_and_quit:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LI A0, 0x701EFF81
	LUI A1, 0x8033
	JAL set_sound
	ORI A1, A1, 0x31F0
	
	SETU A0, 0x14
	SETU A1, 1
	SETU A2, 10
	JAL 0x8024A700
	MOVE A3, R0
	
	MOVE A0, R0
	JAL 0x802497B8
	MOVE A1, R0

	/*
	JAL save_game
	NOP

	LUI T0, 0x8034
	SETU AT, 0x14
	SH AT, 0xB252 (T0)
	SETU AT, 48
	SH AT, 0xB254 (T0)
	SETU AT, 0xF1
	SH AT, 0xB256 (T0)
	
	SETU A0, 1
	SETU A1, 48
	MOVE A2, R0
	MOVE A3, R0
	JAL play_transition
	SW R0, 0x10 (SP)
	*/

	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
