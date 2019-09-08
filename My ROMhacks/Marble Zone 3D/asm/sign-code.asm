beh_signpost_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr
LW T0, o_state (S0)

ORI AT, R0, 0x1
BEQ T0, AT, @spinning
ORI AT, R0, 0x2
BEQ T0, AT, @return

LW A0, g_mario_obj_ptr
JAL get_dist_2d
SLL A1, S0, 0x0
LUI AT, 0x437A
MTC1 AT, F4
NOP
C.LE.S F0, F4
NOP
BC1F @return
ORI AT, R0, 0x1
SW AT, o_state (S0)
B @return
SW R0, o_timer (S0)

@spinning:
LW T0, o_timer (S0)
ORI AT, R0, 0x3C
BNE T0, AT, @endif_change_image
ORI AT, R0, 0x1
	SW AT, o_animation_frame (S0)
@endif_change_image:
ORI AT, R0, 0x78
BNE T0, AT, @endif_stop_spinning
ORI AT, R0, 0x2
	SW AT, o_state (S0)
	LUI AT, 0x4570
	MTC1 AT, F12
	LUI AT, 0x4423
	MTC1 AT, F14
	JAL spawn_star
	LUI A2, 0xC5F5
	B @return
	NOP
@endif_stop_spinning:

LW T0, o_face_angle_yaw (S0)
ADDIU T0, T0, 0x2000
SLL T0, T0, 0x10
SRA T0, T0, 0x10
SW T0, o_face_angle_yaw (S0)

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
