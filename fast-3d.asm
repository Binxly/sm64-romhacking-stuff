; Some macros for Fast3D commands relating to 2D drawing

.macro G_NOOP
	.word 0x00000000
	.word 0x00000000
.endmacro

.macro G_RDPPIPESYNC
	.word 0xE7000000
	.word 0x00000000
.endmacro

.macro G_RDPTILESYNC
	.word 0xE8000000
	.word 0x00000000
.endmacro

.macro G_RDPFULLSYNC
	.word 0xE9000000
	.word 0x00000000
.endmacro

.macro G_ENDDL
	.word 0xB8000000
	.word 0x00000000
.endmacro

.macro G_SET_MODE_2D_DRAWING_PRESET
	; set render mode: 0x0F0A4000
	.word 0xB900031D
	.word 0x0F0A4000
	; set cycle type: G_CYC_FILL
	.word 0xBA001402
	.word 0x00300000
.endmacro

.macro G_SETFILLCOLOR, colour
	.word 0xF7000000
	.word colour
.endmacro

; color: RGBA5551 format (red/green/blue from 0 to 31, alpha is 0 or 1)
.macro G_SETFILLCOLOR_RGBA5551, red, green, blue, alpha
	.word 0xF7000000
	.word ( (( red & 0x1F ) << 11) | (( green & 0x1F ) << 6) | (( blue & 0x1F ) << 1) | ( alpha & 1 ) )
.endmacro

; (x1,y1) = upper-left corner
; (x2,y2) = lower-right corner
.macro G_FILLRECT, x1, y1, x2, y2
	.word ( 0xF6000000 | ( ( x2 & 0xFFF ) << 0xC ) | ( y2 & 0xFFF ) )
	.word ( ( ( x1 & 0xFFF ) << 0xC ) | ( y1 & 0xFFF ) )
.endmacro
