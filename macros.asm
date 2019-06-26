.macro JALR, register
	@@jalr_call:
	LI.U RA, (@@jalr_call + 0xC)
	JR register
	LI.L RA, (@@jalr_call + 0xC)
.endmacro

.macro JALRINZ, register
	BEQ register, R0, @@skip
	JALR register
	@@skip:
.endmacro
