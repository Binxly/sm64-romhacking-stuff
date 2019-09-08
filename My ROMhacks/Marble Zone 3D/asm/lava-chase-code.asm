beh_lava_chase_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LI T0, g_mario
LUI AT, 0xC4B6
MTC1 AT, F5
L.S F4, m_y (T0)
C.LE.S F4, F5
LUI AT, 0xC509
BC1F @reset
MTC1 AT, F5
C.LE.S F4, F5
NOP
BC1F @endif_chase_cam
NOP
	JAL get_or_set_camera_mode
	ORI A0, R0, 0x2
	SH R0, 0x8033C684
	ORI T0, R0, 0xC000
	SH T0, 0x8033C778 ; todo: angle?
@endif_chase_cam:

LUI AT, 0x3E80
MTC1 AT, F6
LUI AT, 0xC1F0
MTC1 AT, F7
L.S F5, o_speed_x (S0)
SUB.S F5, F5, F6
C.LT.S F5, F7
NOP
BC1T @move
S.S F7, o_speed_x (S0)
S.S F5, o_speed_x (S0)
@move:
L.S F5, o_speed_x (S0)
LUI AT, 0xC57A
MTC1 AT, F6
L.S F4, o_x (S0)
ADD.S F4, F4, F5
C.LT.S F4, F6
NOP
BC1T @return
NOP
S.S F4, o_x (S0)
B @return
NOP

@reset:
LW AT, o_home_x (S0)
SW AT, o_x (S0)
SW R0, o_timer (S0)
SW R0, o_speed_x (S0)

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
J process_collision
ADDIU SP, SP, 0x18
