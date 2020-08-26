g_cutscene:
.byte 0 :: cs_enabled equ 0
.byte 0 :: cs_level equ 1
.halfword 0 :: cs_timer equ 2
.halfword 0 :: cs_length equ 4
.halfword 0
.word 0, 0, 0 :: cs_position equ 8
.word 0, 0, 0 :: cs_focus equ 20
.align 4

play_basic_cutscene:
	; a0 = pointer to position vector
	; a1 = pointer to focus vector
	; a2 = length in frames
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI T0, g_cutscene
	SETU AT, 1
	SB AT, cs_enabled (T0)
	LH T1, g_level_num
	SB T1, cs_level (T0)
	SH R0, cs_timer (T0)
	SH A2, cs_length (T0)
	
	SW A1, 0x10 (SP)
	JAL copy_vector
	ADDIU A1, T0, cs_position
	
	LW A0, 0x10 (SP)
	JAL copy_vector
	ADDIU A1, T0, cs_focus
	
	SETU T0, 0x9
	SW T0, g_timestop_flags
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
cutscene_handler:
	; a0 = camera graph node
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI T0, g_cutscene
	LBU AT, cs_enabled (T0)
	BEQ AT, R0, @@return
	MOVE V0, R0
	
	LH T1, g_level_num
	LB AT, cs_level (T0)
	BEQ T1, AT, @@endif_level_changed
	NOP
		SW R0, g_timestop_flags
		B @@return
		SB R0, cs_enabled (T0)
	@@endif_level_changed:
	
	LHU T1, cs_timer (T0)
	LHU AT, cs_length (T0)
	SLTU AT, T1, AT
	BNE AT, R0, @@endif_cutscene_finished
	ADDIU T1, T1, 1
		SW R0, g_timestop_flags
		B @@return
		SB R0, cs_enabled (T0)
	@@endif_cutscene_finished:
	SH T1, cs_timer (T0)
	
	SW R0, 0x38 (A0)
	SW A0, 0x10 (SP)
	
	ADDIU A1, A0, 0x1C
	JAL copy_vector
	ADDIU A0, T0, cs_position
	
	LW AT, 0x10 (SP)
	ADDIU A1, AT, 0x28
	JAL copy_vector
	ADDIU A0, T0, cs_focus
	
	LW A0, 0x10 (SP)
	SETU V0, 1
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
