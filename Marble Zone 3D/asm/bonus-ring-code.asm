beh_bonus_ring_loop:
LW T0, g_current_obj_ptr
LW T1, o_timer (T0)

LW AT, o_face_angle_yaw (T0)
ADDIU AT, AT, 0x1000
SLL AT, AT, 0x10
SRA AT, AT, 0x10
SW AT, o_face_angle_yaw (T0)
SW AT, o_move_angle_yaw (T0)
ORI AT, R0, 0x2000
SW AT, o_interaction (T0)
SW R0, o_interaction_status (T0)

LUI AT, 0x42C8
SW AT, 0x1F8 (T0)
LUI AT, 0x4348
SW AT, 0x208 (T0)
LUI AT, 0x43C8
SW AT, 0x1FC (T0)

SLTI AT, T1, 0xFF
BEQ AT, R0, @endif_can_reenter
	LUI AT, 0x4500
	MTC1 AT, F5
	L.S F4, o_distance_to_mario (T0)
	C.LE.S F4, F5
	ANDI T2, T1, 0x1
	BC1F @endif_can_reenter
	LHU AT, 0x2 (T0)
	ANDI AT, AT, 0xFFEF
	SH AT, 0x2 (T0)
	SLTI AT, T1, 0xB4
	BNE AT, R0, @endif_timer_expiring
	LUI T3, 0x8054
		LUI T3, 0x8055
		LHU AT, 0x2 (T0)
		BEQ T2, R0, @blink
		ANDI AT, AT, 0xFFEF
			ORI AT, AT, 0x10
		@blink:
		SH AT, 0x2 (T0)
	@endif_timer_expiring:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	JAL play_sound_2
	ORI A0, T3, 0xF011
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
@endif_can_reenter:

LI T1, g_mario
LH T1, m_coins (T1)
SLTI T1, T1, 0x32
BNE T1, R0, @not_enough_rings
LHU T1, 0x2 (T0)
	ANDI T1, T1, 0xFFEF
	JR RA
	SH T1, 0x2 (T0)
	
@not_enough_rings:
ORI T1, T1, 0x10
SH T1, 0x2 (T0)

@return:
JR RA
SW R0, o_interaction (T0)
