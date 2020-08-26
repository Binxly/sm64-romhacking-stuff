beh_warp_unlock_impl:
; BHV_START OBJ_LIST_DEFAULT
BHV_EXEC @check_unlocked
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@unlock_message_timer:
.word 0

@check_unlocked:
	LW T0, g_current_obj_ptr
	LBU T1, (global_vars + gv_warps)
	LBU AT, o_arg0 (T0)
	AND AT, T1, AT
	BEQ AT, R0, @@return
	NOP
		SH R0, o_active_flags (T0)
	@@return:
	JR RA
	NOP
	
@loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LHU AT, o_active_flags (A0)
	BEQ AT, R0, @@return
	LW.U A1, g_mario_obj_ptr
	JAL get_dist_2d
	LW.L A1, g_mario_obj_ptr
	LW T0, g_current_obj_ptr
	LBU T1, o_arg1 (T0)
	MTC1 T1, F4
	LI.S F5, 100
	CVT.S.W F4, F4
	MUL.S F4, F4, F5
	C.LE.S F0, F4
	LBU T1, o_arg0 (T0)
	BC1F @@return
	LI T2, global_vars
	LBU AT, gv_warps (T2)
	OR T1, T1, AT
	SB T1, gv_warps (T2)
	SETU T2, 90
	SW T2, @unlock_message_timer
	JAL save_game
	SH R0, o_active_flags (T0)
	LI A0, 0x701EFF81
	LUI A1, 0x8033
	JAL set_sound
	ORI A1, A1, 0x31F0
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
render_warp_unlock_message:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LI T0, @unlock_message_timer
	LW AT, 0x0 (T0)
	BEQ AT, R0, @@return
	ADDIU AT, AT, -1
	SW AT, 0x0 (T0)
	SLL T1, AT, 3
	MINIU T1, T1, 0xFF
	ORI T1, T1, 0xFF00
	LUI AT, 0xFFFF
	JAL begin_print_encoded_text
	OR A0, AT, T1
	LI A2, @txt_warp_unlocked
	SETU A0, 90
	JAL print_encoded_text
	SETU A1, 200
	JAL end_print_encoded_text
	NOP
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@txt_warp_unlocked:
.string "NEW WARP POINT UNLOCKED"
.align 4
