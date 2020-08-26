ICON_SCALE_x1 equ 0
ICON_SCALE_x2 equ 1
ICON_SCALE_x4 equ 2

ICON_SIZE_8x8 equ 4
ICON_SIZE_16x16 equ 8
ICON_SIZE_32x32 equ 12
ICON_SIZE_64x32 equ 16

start_icon_rendering:
	LUI A0, 0x0201
	J exec_display_list
	ORI A0, A0, 0x1AC0
	
end_icon_rendering:
	LUI A0, 0x0201
	J exec_display_list
	ORI A0, A0, 0x1B28
	
enable_texture_interpolation:
	LW T0, g_display_list_head
	LI AT, 0xBA000C02
	SW AT, 0x0 (T0)
	SETU AT, 0x2000
	SW AT, 0x4 (T0)
	ADDIU T0, T0, 0x8
	SW.U T0, g_display_list_head
	JR RA
	SW.L T0, g_display_list_head

disable_texture_interpolation:
	LW T0, g_display_list_head
	LI AT, 0xBA000C02
	SW AT, 0x0 (T0)
	SW R0, 0x4 (T0)
	ADDIU T0, T0, 0x8
	SW.U T0, g_display_list_head
	JR RA
	SW.L T0, g_display_list_head

; render_icon
; a0 = image (segmented pointer)
; a1 = x postion
; a2 = y position
; a3 = size and scale
render_icon:
	LW T0, g_display_list_head
	
	; G_RDPPIPESYNC
	LUI AT, 0xE700
	SW AT, 0x0 (T0)
	SW R0, 0x4 (T0)
	
	; load texture
	LUI AT, 0xFD10
	SW AT, 0x8 (T0)
	SW A0, 0xC (T0)
	
	; prepare texture
	LUI AT, 0x0600
	SW AT, 0x10 (T0)
	LI T1, @prepare_dl_table
	ANDI AT, A3, 0x1C
	ADDU AT, T1, AT
	LW AT, 0xFFFC (AT)
	SW AT, 0x14 (T0)
	
	; draw icon
	SRL T1, A3, 2
	MINIU T2, T1, 3
	ANDI AT, A3, 0x3
	ADDU T1, T1, AT
	ADDU T2, T2, AT
	SETU AT, 4
	SLLV T3, AT, T2
	SLLV T2, AT, T1
	ADDIU T2, T2, 0xFFFF
	ADDIU T3, T3, 0xFFFF
	
	LUI T1, 0xE400
	ADDU AT, A1, T2
	SLL AT, AT, 12
	OR T1, T1, AT
	ADDU AT, A2, T3
	OR T1, T1, AT
	SW T1, 0x18 (T0)
	
	SLL AT, A1, 12
	OR AT, AT, A2
	SW AT, 0x1C (T0)
	
	LUI AT, 0xB300
	SW AT, 0x20 (T0)
	SW R0, 0x24 (T0)
	
	LUI AT, 0xB200
	SW AT, 0x28 (T0)
	LI T1, 0x40001000
	ANDI AT, A3, 0x3
	SRLV AT, T1, AT
	SW AT, 0x2C (T0)
	
	; G_RDPFULLSYNC
	LUI AT, 0xE900
	SW AT, 0x30 (T0)
	SW R0, 0x34 (T0)
	
	ADDIU T0, T0, 0x38
	SW T0, g_display_list_head
	
	JR RA
	NOP
	

@prepare_dl_table:
.word (@@prepare_8x8 - 0x80000000)
.word 0x02011AF8
.word (@@prepare_32x32 - 0x80000000)
.word (@@prepare_64x32 - 0x80000000)

@@prepare_8x8:
.word 0xF5100000, 0x07020080
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x0703F400
.word 0xF5100400, 0x00020080
.word 0xF2000000, 0x00028028
.word 0xB8000000, 0000000000

@@prepare_32x32:
.word 0xF5100000, 0x07020080
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x073FF100
.word 0xF5101000, 0x00020080
.word 0xF2000000, 0x0007C07C
.word 0xB8000000, 0000000000

@@prepare_64x32:
.word 0xF5100000, 0x07020080
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x077FF080
.word 0xF5102000, 0x00094260
.word 0xF2000000, 0x000FC07C
.word 0xB8000000, 0000000000
