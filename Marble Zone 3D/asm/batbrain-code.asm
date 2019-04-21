beh_batbrain_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr
LW T0, o_timer (S0)

LW T1, o_animation_frame (S0)
ANDI AT, T0, 0x3
BNE AT, R0, @endif_next_frame
NOP
	ADDIU T1, T1, 0x1
@endif_next_frame:
ORI AT, R0, 0x3
DIVU T1, AT
NOP
MFHI AT
NOP
SW AT, o_animation_frame (S0)

LW AT, o_state (S0)
BEQ AT, R0, @check_collision
NOP

ORI AT, 0x96
BNE T0, AT, @return
LW AT, o_home_y (S0)
SW AT, o_y (S0)
SW R0, o_timer (S0)
SW R0, o_state (S0)
LHU AT, 0x2 (S0)
ANDI AT, AT, 0xFFEF
SH AT, 0x2 (S0)
B @return
NOP

@check_collision:
LI A1, @hitbox
JAL set_object_hitbox
SLL A0, S0, 0x0
LW AT, o_interaction_status (S0)
ANDI AT, AT, 0xFF
BEQ AT, R0, @fly
ORI AT, R0, 0x1

SW AT, o_state (S0)
JAL spawn_explosion
SLL A0, S0, 0x0

LHU AT, 0x2 (S0)
ORI AT, AT, 0x10
SH AT, 0x2 (S0)

LUI AT, 0xC4B6
SW AT, o_y (S0)
B @return
SW R0, o_timer (S0)

@fly:
LW T0, o_timer (S0)
ANDI T1, T0, 0x80
ANDI T0, T0, 0x7F
SLL T0, T0, 0x3
MTC1 T0, F5
L.S F4, o_home_z (S0)
BEQ T1, R0, @move_right
CVT.S.W F5, F5
	LUI AT, 0x4480
	MTC1 AT, F6
	SUB.S F4, F4, F5
	ADD.S F4, F4, F6
	B @return
	S.S F4, o_z (S0)

@move_right:
	LW AT, o_animation_frame (S0)
	ADDIU AT, AT, 0x3
	SW AT, o_animation_frame (S0)
	ADD.S F4, F4, F5
	S.S F4, o_z (S0)

@return:
SW R0, o_interaction_status (S0)
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@hitbox:
.word 0x00008000
.byte 0x00
.byte 0x01
.byte 0x01
.byte 0x00
.halfword 0x00C8
.halfword 0x00C8
.halfword 0x00C8
.halfword 0x00C8
