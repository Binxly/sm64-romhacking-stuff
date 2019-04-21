; a0|a1 [short] - frames between drops
; a2|a3 [half float] - distance falling
beh_lava_spout_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LW AT, o_timer (S0)
ANDI AT, AT, 0x4
SRL AT, AT, 0x2
SW AT, o_animation_frame (S0)

LW AT, o_state (S0)
BNE AT, R0, @lavafall
	LW T0, o_timer (S0)
	LHU AT, o_arg0 (S0)
	BNE T0, AT, @return
	ORI AT, R0, 0x1
	SW AT, o_state (S0)
	LHU AT, 0x2 (S0)
	ANDI AT, AT, 0xFFEF
	SH AT, 0x2 (S0)
	LW AT, o_home_y (S0)
	B @return
	SW AT, o_y (S0)
@lavafall:
	LUI AT, 0x4280
	MTC1 AT, F5
	L.S F4, o_y (S0)
	SUB.S F4, F4, F5
	S.S F4, o_y (S0)
	
	LHU AT, g_is_invulnerable
	BNE AT, R0, @done_collision_check
	
	LUI A0, 0x4200
	JAL play_sound_2
	ORI A0, A0, 0x8001
	
	L.S F4, o_y (S0)
	LI T1, g_mario
	L.S F5, m_y (T1)
	C.LT.S F5, F4
	LUI AT, 0x44E1
	MTC1 AT, F6
	BC1T @done_collision_check
	ADD.S F6, F4, F6
	C.LE.S F5, F6
	LUI AT, 0x43C8
	BC1F @done_collision_check
	MTC1 AT, F5
	L.S F6, o_x (S0)
	L.S F8, m_x (T1)
	SUB.S F7, F6, F5
	C.LT.S F8, F7
	ADD.S F6, F6, F5
	BC1T @done_collision_check
	C.LE.S F8, F6
	L.S F6, o_z (S0)
	BC1F @done_collision_check
	L.S F8, m_z (T1)
	SUB.S F7, F6, F5
	C.LT.S F8, F7
	ADD.S F6, F6, F5
	BC1T @done_collision_check
	NOP
	C.LE.S F8, F6
	NOP
	BC1F @done_collision_check
	NOP
	
	LI A0, g_mario
	ORI AT, R0, 0x8
	SB AT, m_hurt_counter (A0)
	ORI AT, 0x3C
	SH AT, m_hitstun (A0)
	JAL take_damage_and_knockback
	SLL A1, S0, 0x0
	
	B @return
	NOP
	
	@done_collision_check:
	LHU AT, o_arg2 (S0)
	SLL AT, AT, 0x10
	MTC1 AT, F6
	L.S F5, o_home_y (S0)
	SUB.S F4, F5, F4
	C.LE.S F4, F6
	LHU AT, 0x2 (S0)
	BC1T @return
	ORI AT, AT, 0x10
	SH AT, 0x2 (S0)
	SW R0, o_timer (S0)
	SW R0, o_state (S0)
	
@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
