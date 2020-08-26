key_info:
.word 0 :: k_state equ 0
.halfword 0 :: k_x equ 4
.halfword 0 :: k_y equ 6
.word 0 :: k_door equ 8

KEY_COLLECTING equ 1
KEY_UNLOCKING equ 2

@HOME_X equ 16
@HOME_Y equ 80
@SPEED_COLLECT equ 15
@SPEED_UNLOCK equ 25

render_key:
	ADDIU SP, SP, 0xFFE0
	SW RA, 0x1C (SP)
	
	LW T0, (global_vars + gv_env_flags)
	JAL count_bits
	ANDI A0, T0, FLAG_WATER_KEY_1 | FLAG_WATER_KEY_2
	MOVE V1, V0
	JAL count_bits
	ANDI A0, T0, FLAG_WATER_LOCK_1 | FLAG_WATER_LOCK_2
	BEQ V0, V1, @@return
	
	LHU T0, g_level_num
	SETU AT, 0x16
	BNE T0, AT, @@return
	
	LI T0, key_info
	LW T1, k_state (T0)
	BNE T1, R0, @@endif_idle
		SETU AT, @HOME_X
		SH AT, k_x (T0)
		SETU AT, @HOME_Y
		SH AT, k_y (T0)
		B @@render
		SW R0, k_door (T0)
	@@endif_idle:
	
	SETU AT, KEY_COLLECTING
	BNE T1, AT, @@endif_collecting
		LH A0, k_x (T0)
		SETU A1, @HOME_X
		JAL @approach_int
		SETU A2, @SPEED_COLLECT
		
		SH V0, k_x (T0)
		MOVE T3, V1
		
		LH A0, k_y (T0)
		SETU A1, @HOME_Y
		JAL @approach_int
		SETU A2, @SPEED_COLLECT
		
		SH V0, k_y (T0)
		
		AND AT, V1, T3
		BEQ AT, R0, @@render
		NOP
			B @@render
			SW R0, k_state (T0)
	@@endif_collecting:
	
	SETU AT, KEY_UNLOCKING
	BNE T1, AT, @@endif_unlocking
		LW T2, k_door (T0)
		LW AT, o_x (T2)
		SW AT, 0x10 (SP)
		LI.S F5, 125
		L.S F4, o_y (T2)
		ADD.S F4, F4, F5
		S.S F4, 0x14 (SP)
		LW AT, o_z (T2)
		SW AT, 0x18 (SP)
		JAL perspective_transform_2
		ADDIU A0, SP, 0x10
		
		LI T0, key_info
		MOVE T1, V1
		
		SLT AT, V0, R0
		BEQ AT, R0, @@endif_offscreen
			SETU AT, KEY_COLLECTING
			B @@render
			SW AT, k_state (T0)
		@@endif_offscreen:
		
		LH A0, k_x (T0)
		MOVE A1, V0
		JAL @approach_int
		SETU A2, @SPEED_UNLOCK
		
		SH V0, k_x (T0)
		MOVE A1, T1
		MOVE T1, V1
		
		LH A0, k_y (T0)
		JAL @approach_int
		SETU A2, @SPEED_UNLOCK
		
		SH V0, k_y (T0)
		AND AT, T1, V1
		BEQ AT, R0, @@render
		NOP
			JAL unlock_door
			LW A0, k_door (T0)
	@@endif_unlocking:
	
	@@render:
	LI T0, key_info
	LI A0, icon_key
	LH A1, k_x (T0)
	LH A2, k_y (T0)
	JAL render_icon
	SETU A3, ICON_SIZE_64x32 | ICON_SCALE_x1
	
	@@return:
	LW RA, 0x1C (SP)
	JR RA
	ADDIU SP, SP, 0x20
	
@approach_int:
	SUBU A3, A1, A0
	ABS A3, A3
	SLT V1, A3, A2
	BNE V1, R0, @@return
	MOVE V0, A1
	
	SLT AT, A0, A1
	BNE AT, R0, @@return
	ADDU V0, A0, A2
		SUBU V0, A0, A2
	
	@@return:
	JR RA
	NOP
