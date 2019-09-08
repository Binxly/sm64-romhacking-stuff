animate_rainbow_rings:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LW T0, g_mario_obj_ptr
LW T0, o_timer (T0)
SLL T0, T0, 0x4
ORI AT, R0, 0x600
DIVU T0, AT
NOP
MFHI T0
NOP
SRL T2, T0, 0x8
ANDI T1, T0, 0xFF
ANDI AT, T2, 0x1
BEQ AT, R0, @push_to_colour_channels
ORI T0, R0, 0xFF
	SUBU T0, T0, T1
	ORI T1, R0, 0xFF

@push_to_colour_channels:
ANDI AT, T2, 0x4
BEQ AT, R0, @check_case_2
NOP
	B @assemble_colour
	SLL T1, T1, 0x10
@check_case_2:
ANDI AT, T2, 0x2
BEQ AT, R0, @case_3
NOP
	B @assemble_colour
	SLL T0, T0, 0x8
@case_3:
	SLL T0, T0, 0x10
	SLL T1, T1, 0x8
	
@assemble_colour:
ADDU T0, T0, T1
SLL T0, T0, 0x8
ORI T0, T0, 0xFF
SW T0, 0x10 (SP)

LUI A0, 0x0300
JAL segmented_to_virtual
ORI A0, A0, 0x574C

LW T0, 0x10 (SP)
SW T0, 0x0 (V0)
SW T0, 0x10 (V0)
SW T0, 0x20 (V0)
SW T0, 0x30 (V0)

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
