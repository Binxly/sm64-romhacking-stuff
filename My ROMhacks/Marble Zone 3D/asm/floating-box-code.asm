; state 0 - waiting
; state 1 - moving
; state 2 - sinking
; state 3 - rising

beh_floating_box_loop:
LW T0, g_current_obj_ptr
SW R0, o_speed_x (T0)
SW R0, o_speed_y (T0)

LW T1, o_state (T0)
BEQ T1, R0, @action_waiting
ORI AT, R0, 0x1
BEQ T1, AT, @action_moving
ORI AT, R0, 0x2
BEQ T1, AT, @action_sinking
NOP

@action_rising:
	LUI AT, 0x40A0
	SW AT, o_speed_y (T0)
	MTC1 AT, F5
	L.S F4, o_y (T0)
	ADD.S F4, F4, F5
	S.S F4, o_y (T0)
	LW T1, o_timer (T0)
	ORI AT, R0, 0x50
	BNE T1, AT, @return
	LW AT, o_home_y (T0)
	SW AT, o_y (T0)
	B @return
	SW R0, o_state (T0)

@action_sinking:
	LUI AT, 0xC0A0
	SW AT, o_speed_y (T0)
	MTC1 AT, F5
	L.S F4, o_y (T0)
	ADD.S F4, F4, F5
	S.S F4, o_y (T0)
	LW T1, o_timer (T0)
	ORI AT, R0, 0x50
	BNE T1, AT, @return
	LW AT, o_home_x (T0)
	SW AT, o_x (T0)
	ORI AT, R0, 0x3
	SW AT, o_state (T0)
	B @return
	SW R0, o_timer (T0)

@action_moving:
	L.S F4, o_x (T0)
	L.S F5, o_home_x (T0)
	LUI AT, 0x44E1 ; distance
	MTC1 AT, F7
	SUB.S F6, F5, F4
	ABS.S F6, F6
	C.LT.S F6, F7
	LUI AT, 0x4120 ; speed
	BC1F @reached_distination
	MTC1 AT, F5
	LBU AT, o_arg0 (T0)
	BEQ AT, R0, @endif_flip_direction
	NOP
		NEG.S F5, F5
	@endif_flip_direction:
	S.S F5, o_speed_x (T0)
	ADD.S F4, F4, F5
	B @return
	S.S F4, o_x (T0)

	@reached_distination:
	ORI AT, R0, 0x2
	SW AT, o_state (T0)
	B @return
	SW R0, o_timer (T0)

@action_waiting:
	LI T1, g_mario
	LW T2, m_floor_ptr (T1)
	BEQ T2, R0, @return
	LUI AT, 0x434A
	MTC1 AT, F5
	LW T2, t_object (T2)
	BNE T2, T0, @return
	L.S F4, o_y (T0)
	ADD.S F4, F4, F5
	L.S F5, m_y (T1)
	C.LE.S F5, F4
	NOP
	BC1F @return
	ORI AT, R0, 0x1
	SW AT, o_state (T0)

@return:
J process_collision
NOP
