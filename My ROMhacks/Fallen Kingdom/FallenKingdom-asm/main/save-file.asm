@g_save_buffer equ 0x80207700
@g_save_file_dirty equ 0x8033B4A6

refresh_save_buffer:
	LI T0, global_vars
	LH T1, (g_mario + m_health)
	MAXI AT, T1, 0x1FF
	SH AT, sv_health (T0)
	
	SETU T1, 1
	SB T1, @g_save_file_dirty
	
	LH AT, g_save_file_num
	ADDIU T1, AT, 0xFFFF
	SETU AT, 0x70
	MULTU T1, AT
	LI.U T1, @g_save_buffer
	MFLO AT
	LI.L T1, @g_save_buffer
	ADDU A0, T1, AT
	MOVE A1, T0
	J wordcopy
	SETU A2, 56

save_game:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL refresh_save_buffer
	NOP
	
	LH A0, g_save_file_num
	JAL 0x80279840 ; save_file_do_save
	ADDIU A0, A0, 0xFFFF
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
save_file_exists:
	; a0 = save file index (starting from 1)
	ADDIU A0, A0, 0xFFFF
	SETU AT, 0x70
	MULTU A0, AT
	LI.U T0, @g_save_buffer
	MFLO T1
	LI.L T0, @g_save_buffer
	ADDU T0, T0, T1
	LW T0, sv_signature (T0)
	LI AT, 0xDEADBEEF
	BEQ T0, AT, @@endif_invalid
	SETU V0, 1
		MOVE V0, R0
	@@endif_invalid:
	JR RA
	NOP
	
fetch_save_data:
	; a0 = data buffer
	; a1 = save file index (starting from 1)
	ADDIU A1, A1, 0xFFFF
	SETU AT, 0x70
	MULTU A1, AT
	LI.U A1, @g_save_buffer
	MFLO T0
	LI.L A1, @g_save_buffer
	ADDU A1, A1, T0
	J wordcopy
	SETU A2, 5
	
load_game:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI A0, global_vars
	LH A1, g_save_file_num
	JAL fetch_save_data
	NOP
	
	LI A0, global_vars
	LW T0, sv_signature (A0)
	LI AT, 0xDEADBEEF
	BEQ T0, AT, @@endif_empty_save
	MOVE T2, R0
		LI A1, default_save_data
		JAL wordcopy
		SETU A2, 5
		SETU T2, 1
	@@endif_empty_save:
	
	LI T0, global_vars
	LH T1, sv_health (T0)
	SH T1, (g_mario + m_health)
	
	BEQ T2, R0, @@endif_create_save_file
	NOP
		JAL save_game
		NOP
		LI T0, global_vars
	@@endif_create_save_file:
	
	JAL set_max_health
	LHU A0, gv_max_health (T0)
	
	LHU V0, (global_vars + sv_level)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
