; a0 - type (0 = jumping, 1 = flying)
; a1 - frames between spawns
; a2 - (for type 1) fireball lifetime in frames

beh_fireball_spawner_loop:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)
SW S0, 0x18 (SP)
SW S1, 0x14 (SP)

LW S0, g_current_obj_ptr

LW T0, o_timer (S0)
LBU AT, o_arg1 (S0)
BNE T0, AT, @return
NOP

SW R0, o_timer (S0)
LI A2, beh_fireball
ORI A1, R0, 0x90
JAL spawn_object
SLL A0, S0, 0x0
SLL S1, V0, 0x0

LW AT, o_arg0 (S0)
SW AT, o_arg0 (S1)

SRL AT, AT, 0x18
BNE AT, R0, @flying_fireball
	LUI AT, 0x4270
	B @return
	SW AT, o_speed_y (S1)
@flying_fireball:
	JAL angle_to_unit_vector
	LW A0, o_face_angle_yaw (S0)
	LUI AT, 0x41C8
	MTC1 AT, F4
	NOP
	MUL.S F0, F0, F4
	MUL.S F1, F1, F4
	S.S F0, o_speed_x (S1)
	S.S F1, o_speed_z (S1)

@return:
LW S1, 0x14 (SP)
LW S0, 0x18 (SP)
LW RA, 0x1C (SP)
JR RA
ADDIU SP, SP, 0x20
