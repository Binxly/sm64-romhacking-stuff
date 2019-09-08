lava_texture equ 0x0E011210

animate_lava:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)
SW S0, 0x18 (SP)

LHU T0, g_level_num
ORI AT, R0, 0x9
BNE T0, AT, @return

LW S0, g_mario_obj_ptr
LW S0, o_timer (S0)
ORI AT, R0, 0x16C
MULTU S0, AT
NOP
MFLO A0
JAL sin_u16
NOP
LUI AT, 0x3F80
MTC1 AT, F4
LUI AT, 0x4180
MTC1 AT, F5
ADD.S F0, F0, F4
MUL.S F0, F0, F5
CVT.W.S F0, F0
MFC1 T2, F0
NOP
ANDI T2, T2, 0x1F
SLL T2, T2, 0x6
SW T2, 0x14 (SP)

ORI AT, R0, 0xA
DIVU S0, AT
NOP
MFLO T0
ORI AT, R0, 0x3
DIVU T0, AT
LI.U AT, @frame_table
MFHI T0
LI.L AT, @frame_table
SLL T0, T0, 0x2
ADDU T0, T0, AT
JAL segmented_to_virtual
LW A0, 0x0 (T0)
SW V0, 0x10 (SP)

LI.U A0, lava_texture
JAL segmented_to_virtual
LI.L A0, lava_texture
LW T0, 0x10 (SP)
SLL T1, V0, 0x0
LW T2, 0x14 (SP)
SLL T3, R0, 0x0

@copy_texture_loop:
	ADDU AT, T0, T2
	LW T4, 0x0 (AT)
	ADDU AT, T1, T3
	SW T4, 0x0 (AT)
	
	ORI AT, R0, 0x4
	ADDU T2, T2, AT
	ADDU T3, T3, AT
	ANDI T2, T2, 0x7FF
	
	ORI AT, R0, 0x800
	BNE T3, AT, @copy_texture_loop
	NOP
	
@return:
LW S0, 0x18 (SP)
LW RA, 0x1C (SP)
JR RA
ADDIU SP, SP, 0x20

@frame_table:
.word lava_texture_1
.word lava_texture_2
.word lava_texture_3
