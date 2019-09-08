beh_loose_block_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LW T0, o_state (S0)
ORI AT, R0, 0x2
BEQ T0, AT, @return
ORI AT, R0, 0x1
BEQ T0, AT, @falling
LW T0, o_timer (S0)

ORI AT, 0x2B
DIVU T0, AT
ORI AT, 0x5F4
MFHI T0
NOP
MULTU T0, AT
NOP
MFLO A0
JAL sin_u16
NOP
LUI AT, 0x3F80
MTC1 AT, F4
LUI AT, 0x4248
MTC1 AT, F5
ADD.S F4, F4, F0
MUL.S F4, F4, F5
L.S F5, o_home_y (S0)
ADD.S F4, F4, F5
S.S F4, o_y (S0)

LW AT, o_arg0 (S0)
BEQ AT, R0, @return
LW A0, g_mario_obj_ptr
JAL get_dist_2d
SLL A1, S0, 0x0
LUI AT, 0x4461
MTC1 AT, F4
NOP
C.LE.S F0, F4
NOP
BC1F @return
ORI AT, R0, 0x1
B @return
SW AT, o_state (S0)

@falling:
L.S F4, o_y (S0)
LUI AT, 0x419C
MTC1 AT, F5
L.S F6, o_home_y (S0)
L.S F7, o_arg0 (S0)
SUB.S F4, F4, F5
SUB.S F5, F6, F7
C.LE.S F4, F5
S.S F4, o_y (S0)
BC1F @return
ORI AT, R0, 0x2
SW AT, o_state (S0)
S.S F5, o_y (S0)

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
J process_collision
ADDIU SP, SP, 0x18
