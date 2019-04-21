beh_press_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr
LW A0, o_timer (S0)
JAL sin_u16
SLL A0, A0, 0x9
LUI AT, 0x3F80
MTC1 AT, F4
LUI AT, 0x4348
MTC1 AT, F5
ADD.S F4, F0, F4
MUL.S F5, F4, F5

L.S F4, o_home_y (S0)
ADD.S F4, F4, F5
S.S F4, o_y (S0)

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
J process_collision
ADDIU SP, SP, 0x18
