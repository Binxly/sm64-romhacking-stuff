/* JALR (Jump And Link Register)
Like JAL, except it jumps to the address stored in a register instead of a
hardcoded memory address. This macro uses the branch delay slot, so the
instruction following a use of this macro can be a branch and will not be
executed before the jump.
*/
.macro JALR, register
	@@jalr_call:
	LI.U RA, (@@jalr_call + 0xC)
	JR register
	LI.L RA, (@@jalr_call + 0xC)
.endmacro

/* JALRINZ (Jump And Link Register If Not Zero)
Same as the JALR macro, except it does nothing if the register holds value 0.
*/
.macro JALRINZ, register
	BEQ register, R0, @@skip
	JALR register
	@@skip:
.endmacro

/* MAX
Stores the larger of the two values in the source registers in the destination
register. Reads the values as signed integers.
*/
.macro MAX, dst, src1, src2
	SLT AT, src1, src2
	BEQ AT, R0, @@end
	SLL dst, src1, 0x0
	SLL dst, src2, 0x0
	@@end:
.endmacro

/* MAXU
Stores the larger of the two values in the source registers in the destination
register. Reads the values as unsigned integers.
*/
.macro MAXU, dst, src1, src2
	SLTU AT, src1, src2
	BEQ AT, R0, @@end
	SLL dst, src1, 0x0
	SLL dst, src2, 0x0
	@@end:
.endmacro

/* MAXI
Stores the larger of the source register and the immediate value in the
destination register. Both the source register value and the immediate value
are interpreted as signed.
*/
.macro MAXI, dst, src, imm
	SLTI AT, src1, imm
	BEQ AT, R0, @@end
	SLL dst, src1, 0x0
	ADDIU dst, R0, imm
	@@end:
.endmacro

/* MAXIU
Stores the larger of the source register and the immediate value in the
destination register. Both the source register value and the immediate value
are interpreted as unsigned.
*/
.macro MAXIU, dst, src, imm
	ORI AT, R0, imm
	MAXU dst, src, AT
.endmacro

/* MIN
Stores the smaller of the two values in the source registers in the destination
register. Reads the values as signed integers.
*/
.macro MIN, dst, src1, src2
	SLT AT, src1, src2
	BEQ AT, R0, @@end
	SLL dst, src2, 0x0
	SLL dst, src1, 0x0
	@@end:
.endmacro

/* MINU
Stores the smaller of the two values in the source registers in the destination
register. Reads the values as unsigned integers.
*/
.macro MINU, dst, src1, src2
	SLTU AT, src1, src2
	BEQ AT, R0, @@end
	SLL dst, src2, 0x0
	SLL dst, src1, 0x0
	@@end:
.endmacro

/* MINI
Stores the smaller of the source register and the immediate value in the
destination register. Both the source register value and the immediate value
are interpreted as signed.
*/
.macro MINI, dst, src, imm
	SLTI AT, src1, imm
	BEQ AT, R0, @@end
	ADDIU dst, R0, imm
	SLL dst, src1, 0x0
	@@end:
.endmacro

/* MINIU
Stores the smaller of the source register and the immediate value in the
destination register. Both the source register value and the immediate value
are interpreted as unsigned.
*/
.macro MINIU, dst, src, imm
	ORI AT, R0, imm
	MINU dst, src, AT
.endmacro

/* MOVE
Moves the value of one register to another
*/
.macro MOVE, dst, src
	SLL dst, src, 0x0
.endmacro

/* SETS (Set Signed)
Sets the value of a register to the sign-extended immediate value
*/
.macro SETS, dst, imm
	ADDIU dst, R0, imm
.endmacro

/* SETU (Set Unsigned)
Sets the value of a register to the immediate unsigned value
*/
.macro SETU, dst, imm
	ORI dst, R0, imm
.endmacro
