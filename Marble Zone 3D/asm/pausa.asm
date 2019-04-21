render_star_hint_viewer:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)
SW S0, 0x18 (SP)
SW S1, 0x14 (SP)

LHU A0, g_save_file_num
ADDIU A0, A0, 0xFFFF
JAL save_file_get_star_flags
SLL A1, R0, 0x0
ANDI S0, V0, 0x7F

LHU A0, g_save_file_num
ADDIU A0, A0, 0xFFFF
JAL save_file_get_star_flags
ORI A1, R0, 0x1
ANDI V0, V0, 0x1
SLL V0, V0, 0x7
ADDU S0, S0, V0

LW T0, 0x8033B20C
LHU T0, 0x12 (T0)

ANDI AT, T0, 0x200
BEQ AT, R0, @endif_dpad_left_pressed
	LHU T1, @selected_star
	ADDIU T1, T1, 0xFFFF
	ANDI T1, T1, 0x7
	SH T1, @selected_star
@endif_dpad_left_pressed:

ANDI AT, T0, 0x100
BEQ AT, R0, @endif_dpad_right_pressed
	LHU T1, @selected_star
	ADDIU T1, T1, 0x1
	ANDI T1, T1, 0x7
	SH T1, @selected_star
@endif_dpad_right_pressed:

SLL S1, R0, 0x0
@star_display_loop:
	LI A2, @icon
	ORI AT, R0, 0x1
	SLLV AT, AT, S1
	AND AT, AT, S0
	BEQ AT, R0, @endif_has_star
	NOP
		ADDIU A2, A2, 0x2
	@endif_has_star:
	ORI A1, R0, 0xB0
	ORI A0, R0, 0x50
	SLL AT, S1, 0x4
	ADDU A0, A0, AT
	SLL AT, S1, 0x2
	ADDU A0, A0, AT
	JAL print_int
	SLL A3, R0, 0x0
	
	ADDIU S1, S1, 0x1
	ORI AT, R0, 0x8
	BNE S1, AT, @star_display_loop
	NOP
	
LHU T0, @selected_star
ORI A0, R0, 0x50
SLL AT, T0, 0x4
ADDU A0, A0, AT
SLL AT, T0, 0x2
ADDU A0, A0, AT
ORI A1, R0, 0xA0
LI A2, @cursor
JAL print_int
SLL A3, R0, 0x0

LW T0, g_display_list_head
LI T1, @fast3d_1
LW AT, 0x0 (T1)
SW AT, 0x0 (T0)
LW AT, 0x4 (T1)
SW AT, 0x4 (T0)
LW AT, 0x8 (T1)
SW AT, 0x8 (T0)
LW AT, 0xC (T1)
SW AT, 0xC (T0)
ADDIU T0, T0, 0x10
SW T0, g_display_list_head

ORI A0, R0, 0x50
ORI A1, R0, 0x90
LI A2, @hint_table
LHU AT, @selected_star
SLL AT, AT, 0x2
ADDU A2, A2, AT
LW A3, 0x20 (A2)
JAL @print_ascii
LW A2, 0x0 (A2)

LW T0, g_display_list_head
LI T1, @fast3d_2
LW AT, 0x0 (T1)
SW AT, 0x0 (T0)
LW AT, 0x4 (T1)
SW AT, 0x4 (T0)
ADDIU T0, T0, 0x8
SW T0, g_display_list_head

LW S1, 0x14 (SP)
LW S0, 0x18 (SP)
LW RA, 0x1C (SP)
JR RA
ADDIU SP, SP, 0x20

@selected_star:
.halfword 0x0000
@cursor:
.halfword 0x4200

@icon:
.word 0x2A002D00

@hint_table:
.word @star_hint_1
.word @star_hint_2
.word @star_hint_3
.word @star_hint_4
.word @star_hint_5
.word @star_hint_6
.word @star_hint_7
.word @star_hint_8
.word @buffer_1
.word @buffer_2
.word @buffer_3
.word @buffer_4
.word @buffer_5
.word @buffer_6
.word @buffer_7
.word @buffer_8

@star_hint_1:
.asciiz "SPIN THE SIGNPOST"
.align 4
@buffer_1:
.asciiz "SPIN THE SIGNPOST"
.align 4

@star_hint_2:
.asciiz "RAINBOW RING RACE"
.align 4
@buffer_2:
.asciiz "RAINBOW RING RACE"
.align 4

@star_hint_3:
.asciiz "OUTRUN THE LAVA"
.align 4
@buffer_3:
.asciiz "OUTRUN THE LAVA"
.align 4

@star_hint_4:
.asciiz "CROSS THE THREE LAVA RIVERS"
.align 4
@buffer_4:
.asciiz "CROSS THE THREE LAVA RIVERS"
.align 4

@star_hint_5:
.asciiz "THE FALSE WALL"
.align 4
@buffer_5:
.asciiz "THE FALSE WALL"
.align 4

@star_hint_6:
.asciiz "SECRET OF THE BLUE PILLARS"
.align 4
@buffer_6:
.asciiz "SECRET OF THE BLUE PILLARS"
.align 4

@star_hint_7:
.asciiz "COLLECT 877 RINGS"
.align 4
@buffer_7:
.asciiz "COLLECT 100 RINGS"
.align 4

@star_hint_8:
.asciiz "BONUS LEVEL"
.align 4
@buffer_8:
.asciiz "BONUS LEVEL"
.align 4

@fast3d_1:
.word 0x06000000, 0x02011CC8
.word 0xFB000000, 0xFFFFFFFF
@fast3d_2:
.word 0x06000000, 0x02011D50

@print_ascii:
SLL T0, A2, 0x0
SLL T2, A3, 0x0
@text_encoding_loop:
	LBU T1, 0x0 (T0)
	BEQ T1, R0, @break
	ORI AT, R0, 0x20
	BEQ T1, AT, @write_space
	NOP
	ADDIU T1, T1, 0xFFC9
	SB T1, 0x0 (T2)
	ADDIU T0, T0, 0x1
	ADDIU T2, T2, 0x1
	B @text_encoding_loop
	@write_space:
	ORI AT, R0, 0x9E
	SB AT, 0x0 (T2)
	ADDIU T0, T0, 0x1
	ADDIU T2, T2, 0x1
	B @text_encoding_loop
	NOP
@break:
ORI AT, R0, 0xFF
SB AT, 0x0 (T2)
J 0x802D77DC
SLL A2, A3, 0x0
