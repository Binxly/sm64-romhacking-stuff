@STAMINA_BAR_WIDTH equ 172
@SCREEN_WIDTH equ 1280
@SCREEN_HEIGHT equ 960

show_struggle_prompt:
.byte 0
show_warning_alert:
.byte 0
@intro_text_encoded:
.byte 0
@endgame_text_encoded:
.byte 0
.align 4

render_gui:
LH T0, g_level_num
SETU AT, 0x5
BEQ T0, AT, @render_end_screen
NOP

ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LW T0, g_mario_obj_ptr
BEQ T0, R0, @@return
NOP

JAL is_mario_blinded
NOP
BEQ V0, R0, @@endif_blinded
	LI.U A0, @blindness
	JAL exec_display_list
	LI.L A0, @blindness
@@endif_blinded:

LI T0, g_mario
LW T1, m_action (T0)
LI AT, ACT_WALLRUN
BNE T1, AT, @@endif_render_stamina_bar
	LUI AT, 0x4310
	MTC1 AT, F4
	L.S F12, m_x (T0)
	L.S F13, m_y (T0)
	L.S F14, m_z (T0)
	JAL perspective_transform
	ADD.S F13, F13, F4
	
	LUI AT, 0x4210
	MTC1 AT, F4
	MTC1 R0, F6
	SUB.S F5, F1, F4
	LI AT, float( @STAMINA_BAR_WIDTH/2 )
	C.LT.S F5, F6
	MTC1 AT, F4
	BC1T @@endif_render_stamina_bar
	SUB.S F4, F0, F4
	C.LT.S F4, F6
	BEQ V0, R0, @@endif_render_stamina_bar
	NOP
	BC1T @@endif_render_stamina_bar
	
	LI AT, float( @SCREEN_WIDTH )
	MTC1 AT, F7
	LI AT, float( @SCREEN_HEIGHT )
	C.LE.S F4, F7
	MTC1 AT, F8
	BC1F @@endif_render_stamina_bar
	CVT.W.S F4, F4
	C.LE.S F5, F8
	CVT.W.S F5, F5
	BC1F @@endif_render_stamina_bar
	
	MFC1 T0, F4
	MFC1 T1, F5
	ANDI A0, T0, 0xFFFC
	ANDI A1, T1, 0xFFFC
	ADDIU AT, A0, 0x4
	SH AT, 0x10 (SP)
	ADDIU AT, A1, 0x4
	SH AT, 0x12 (SP)
	
	SETU A2, @STAMINA_BAR_WIDTH
	JAL create_draw_rect_command
	SETU A3, 0x14
	
	LI T0, @draw_border
	SW V0, 0x0 (T0)
	SW V1, 0x4 (T0)
	
	LHU A0, 0x10 (SP)
	LHU A1, 0x12 (SP)
	SETU A2, (@STAMINA_BAR_WIDTH-8)
	JAL create_draw_rect_command
	SETU A3, 0xC
	
	LI T0, @draw_background
	SW V0, 0x0 (T0)
	SW V1, 0x4 (T0)
	
	LI T0, g_mario
	LHU T0, m_action_timer (T0)
	SETU T1, (@STAMINA_BAR_WIDTH-8)
	MULTU T0, T1
	NOP
	MFLO T0
	SETU AT, MAX_WALLRUN_TIME
	DIVU T0, AT
	LHU A0, 0x10 (SP)
	MFLO T0
	LHU A1, 0x12 (SP)
	SUBU A2, T1, T0
	ANDI A2, A2, 0xFFFC
	JAL create_draw_rect_command
	SETU A3, 0xC
	
	LI T0, @draw_bar
	SW V0, 0x0 (T0)
	SW V1, 0x4 (T0)
	
	LI A0, (@stamina_bar_fast3d-0x80000000)
	JAL exec_display_list
	NOP
	
@@endif_render_stamina_bar:

LW T0, g_mario_obj_ptr
BEQ T0, R0, @@endif_render_health
NOP
	LI A0, 0x02011AC0
	JAL exec_display_list
	NOP
	
	LI T0, g_mario
	LB T0, m_health (T0)
	MOVE T1, R0
	@@draw_hp_loop:
		MAXI T2, T0, 0x0
		MINI T2, T2, 0x4
		SUBU T0, T0, T2
		LI T3, @health_load_texture_commands
		SLL AT, T1, 0x2
		ADDU T3, T3, AT
		LW T3, 0x0 (T3)
		LI T4, @health_icon_table
		SLL T2, T2, 0x2
		ADDU T2, T4, T2
		LW AT, 0x0 (T2)
		SW AT, 0x0 (T3)
		SLTI AT, T1, 0x4
		BNE AT, R0, @@draw_hp_loop
		ADDIU T1, T1, 0x1
	
	LI A0, (@health_fast3d-0x80000000)
	JAL exec_display_list
	NOP

	LI A0, 0x02011B28
	JAL exec_display_list
	NOP
@@endif_render_health:

LBU T0, show_struggle_prompt
BEQ T0, R0, @@endif_draw_struggle_prompt
	LI A0, 0x02011AC0
	JAL exec_display_list
	NOP
	LW T0, g_global_timer
	ANDI T0, T0, 0x8
	LI A0, (@escape_prompt_1-0x80000000)
	BEQ T0, R0, @@endif_frame2
	NOP
		LI A0, (@escape_prompt_2-0x80000000)
	@@endif_frame2:
	JAL exec_display_list
	NOP
	LI A0, 0x02011B28
	JAL exec_display_list
	NOP
	SB R0, show_struggle_prompt
@@endif_draw_struggle_prompt:

LI T0, g_mario
LW T0, m_action (T0)
LI T1, ACT_INTRO_TEXT
BNE T0, T1, @@endif_render_intro
	LBU T0, @intro_text_encoded
	BNE T0, R0, @@endif_encode_intro_text
		LI A0, @intro_text_1
		JAL encode_text
		MOVE A1, A0
		LI A0, @intro_text_2
		JAL encode_text
		MOVE A1, A0
		LI A0, @intro_continue
		JAL encode_text
		MOVE A1, A0
		LI A0, @intro_done
		JAL encode_text
		MOVE A1, A0
		SETU T0, 0x1
		SB T0, @intro_text_encoded
	@@endif_encode_intro_text:
	
	LI.U A0, @blackout
	JAL exec_display_list
	LI.L A0, @blackout

	LUI A0, 0xFFFF
	JAL begin_print_encoded_text
	ORI A0, A0, 0xBFFF
	
	LI T0, g_mario
	LI T1, @intro_text_table
	LHU T0, m_action_state (T0)
	SLL T0, T0, 0x3
	ADDU T0, T0, T1
	LW A2, 0x0 (T0)
	LW T0, 0x4 (T0)
	SW T0, 0x10 (SP)
	
	SETU A0, 0x10
	JAL print_encoded_text
	SETU A1, 0xB0
	
	LI T0, g_mario
	LHU T0, m_action_timer (T0)
	SLTI AT, T0, 45
	BNE AT, R0, @@endif_press_a_prompt
		LW A2, 0x10 (SP)
		SETU A0, 0x70
		JAL print_encoded_text
		SETU A1, 0x40
	@@endif_press_a_prompt:
	
	JAL end_print_encoded_text
	NOP
@@endif_render_intro:

LH T0, g_level_num
SETU AT, 0xC
BNE T0, AT, @@endif_render_skull_pointer_and_distance
LW T0, skull_ref
BEQ T0, R0, @@endif_render_skull_pointer_and_distance
NOP
LW T1, o_opacity (T0)
BEQ T1, R0, @@endif_render_skull_pointer_and_distance
	LW A0, g_mario_obj_ptr
	JAL get_dist_3d
	MOVE A1, T0
	LUI AT, 0x42C8
	MTC1 AT, F4
	SETU A1, 10
	DIV.S F4, F0, F4
	CVT.W.S F4, F4
	MFC1 A0, F4
	LI A2, @distance_text_buffer
	LI A3, @distance_text_length
	SW R0, 0x0 (A3)
	ADDIU SP, SP, 0xFFE0
	SW R0, 0x10 (SP)
	JAL 0x802D5E54
	SW R0, 0x14 (SP)
	ADDIU SP, SP, 0x20
	LW T0, @distance_text_length
	LI A0, @distance_text_buffer
	ADDU T0, T0, A0
	SETU AT, 0x6D
	SB AT, 0x0 (T0)
	SB R0, 0x1 (T0)
	JAL encode_text
	MOVE A1, A0
	
	LUI A0, 0xFFFF
	JAL begin_print_encoded_text
	ORI A0, A0, 0xFFFF
	
	LI A2, @distance_text_buffer
	SETU A0, 0x14
	JAL print_encoded_text
	SETU A1, 0xD0
	
	JAL end_print_encoded_text
	NOP
	
	LI A0, 0x02011AC0
	JAL exec_display_list
	NOP
	
	LI A0, @skull_dist_icon
	JAL exec_display_list
	NOP
	
	LUI AT, 0x4316
	MTC1 AT, F4
	LW T0, skull_ref
	L.S F12, o_x (T0)
	L.S F13, o_y (T0)
	ADD.S F13, F13, F4
	JAL perspective_transform
	L.S F14, o_z (T0)
	LUI AT, 0x4200
	MTC1 AT, F4
	BEQ V0, R0, @@endif_draw_skull_pointer
	SUB.S F0, F0, F4
	SUB.S F1, F1, F4
	MTC1 R0, F4
	LUI AT, 0x4498
	C.LT.S F0, F4
	MTC1 AT, F5
	BC1T @@endif_draw_skull_pointer
	C.LT.S F1, F4
	LUI AT, 0x4460
	BC1T @@endif_draw_skull_pointer
	C.LE.S F0, F5
	MTC1 AT, F6
	BC1F @@endif_draw_skull_pointer
	C.LE.S F1, F6
	CVT.W.S F0, F0
	BC1F @@endif_draw_skull_pointer
	MFC1 T0, F0
	CVT.W.S F1, F1
	MFC1 T1, F1
	SLL T2, T0, 12
	ADDU T2, T2, T1
	SW T2, (@skull_ptr_draw_cmd+0x4)
	ADDIU T0, T0, 0x40
	ADDIU T1, T1, 0x3F
	SLL T2, T0, 12
	ADDU T2, T2, T1
	LUI AT, 0xE400
	OR T2, T2, AT
	SW T2, @skull_ptr_draw_cmd
	
	LI A0, @skull_pointer_icon
	JAL exec_display_list
	NOP
	@@endif_draw_skull_pointer:
	
	LI A0, 0x02011B28
	JAL exec_display_list
	NOP
@@endif_render_skull_pointer_and_distance:

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@render_end_screen:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LI.U A0, @blackout
JAL exec_display_list
LI.L A0, @blackout

LBU T0, @endgame_text_encoded
BNE T0, R0, @@endif_encode_endgame_text
	LI A0, @endgame_text_1
	JAL encode_text
	MOVE A1, A0
	LI A0, @endgame_text_2
	JAL encode_text
	MOVE A1, A0
	SETU T0, 0x1
	SB T0, @endgame_text_encoded
@@endif_encode_endgame_text:

LUI A0, 0xFFFF
JAL begin_print_encoded_text
ORI A0, A0, 0xFFFF

LI A2, @endgame_text_1
SETU A0, 0x70
JAL print_encoded_text
SETU A1, 0xD0

LI A2, @endgame_text_2
SETU A0, 0x20
JAL print_encoded_text
SETU A1, 0x50

JAL end_print_encoded_text
NOP

LI A0, @endgame_images
JAL exec_display_list
NOP

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@stamina_bar_fast3d:
G_RDPPIPESYNC
G_SET_CYCLE_TYPE G_CYC_FILL
G_SETFILLCOLOR 0x00010001
@draw_border: NOP :: NOP
G_SETFILLCOLOR_RGBA5551 20,20,20,1
@draw_background: NOP :: NOP
G_SETFILLCOLOR_RGBA5551 2,28,2,1
@draw_bar: NOP :: NOP
G_RDPFULLSYNC
G_ENDDL

@health_fast3d:
G_RDPPIPESYNC
.word 0xFD100000 :: @heart_1: .word heart_full
.word 0x06000000, 0x02011AF8
.word 0xE404003F, 0x00020020
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x20000800
	
G_RDPPIPESYNC
.word 0xFD100000 :: @heart_2: .word heart_full
.word 0x06000000, 0x02011AF8
.word 0xE407003F, 0x00050020
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x20000800
	
G_RDPPIPESYNC
.word 0xFD100000 :: @heart_3: .word heart_full
.word 0x06000000, 0x02011AF8
.word 0xE40A003F, 0x00080020
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x20000800
	
G_RDPPIPESYNC
.word 0xFD100000 :: @heart_4: .word heart_full
.word 0x06000000, 0x02011AF8
.word 0xE40D003F, 0x000B0020
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x20000800
	
G_RDPPIPESYNC
.word 0xFD100000 :: @heart_5: .word heart_full
.word 0x06000000, 0x02011AF8
.word 0xE410003F, 0x000E0020
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x20000800

G_RDPFULLSYNC
G_ENDDL

@health_load_texture_commands:
.word @heart_1
.word @heart_2
.word @heart_3
.word @heart_4
.word @heart_5

@health_icon_table:
.word heart_empty
.word heart_quarter
.word heart_half
.word heart_three_quarters
.word heart_full

@escape_prompt_1:
G_RDPPIPESYNC
.word 0xFD100000, analog_stick_1
.word 0x06000000, @prepare_texture_32x32
.word 0xE426018F, 0x00220150
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x20000800
G_RDPPIPESYNC
.word 0xFD100000, a_button_2
.word 0x06000000, @prepare_texture_32x32
.word 0xE42F018F, 0x002B0150
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x20000800
G_RDPFULLSYNC
G_ENDDL

@escape_prompt_2:
G_RDPPIPESYNC
.word 0xFD100000, analog_stick_2
.word 0x06000000, @prepare_texture_32x32
.word 0xE426018F, 0x00220150
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x20000800
G_RDPPIPESYNC
.word 0xFD100000, a_button_1
.word 0x06000000, @prepare_texture_32x32
.word 0xE42F018F, 0x002B0150
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x20000800
G_RDPFULLSYNC
G_ENDDL

.definelabel @prepare_texture_32x32, (org()-0x80000000)
.word 0xF5100000, 0x07020080
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x073FF100
.word 0xF5101000, 0x00020080
.word 0xF2000000, 0x0007C07C
.word 0xB8000000, 0000000000

@blackout:
G_RDPPIPESYNC
G_SET_CYCLE_TYPE G_CYC_FILL
G_SETFILLCOLOR 0x00010001
G_FILLRECT 0, 0, 1920, 960
G_RDPFULLSYNC
G_ENDDL

@blindness:
.word 0x06000000, @blackout
.word 0x06000000, 0x02011AC0
G_RDPPIPESYNC
.word 0xFD100000, eye_icon
.word 0x06000000, @prepare_texture_32x32
.word 0xE42BC21C, 0x002401A0
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x10000400
G_RDPFULLSYNC
.word 0x06000000, 0x02011B28
G_ENDDL

@skull_dist_icon:
G_RDPPIPESYNC
.word 0xFD100000, skull_16
.word 0x06000000, 0x02011AF8
.word 0xE4050080, 0x00010040
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x10000400
G_RDPFULLSYNC
G_ENDDL
	
@skull_pointer_icon:
G_RDPPIPESYNC
.word 0xFD100000, skull_32
.word 0x06000000, @prepare_texture_32x32
@skull_ptr_draw_cmd:
.word 0xE4000000, 0x00000000
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x20000800
G_RDPFULLSYNC
G_ENDDL

@intro_text_1:
.ascii "The Mushroom Kingdom is in turmoil. Bowser and his evil\\"
.ascii "magician Kamek have cursed the kingdom to an eternal\\"
.ascii "winter. We join our hero, the mighty plumber Mario, as he\\"
.ascii "searches for the Chalice of Winter, a legendary artefact\\"
.asciiz "that may have the power to dispel this curse."
.align 4

@intro_text_2:
.ascii "The chalice is said to be housed in a tomb filled with\\"
.ascii "traps and challenges. But even getting to the tomb will\\"
.ascii "be no easy task, for it lies atop the peak of a\\"
.asciiz "treacherous mountain..."
.align 4

@intro_continue:
.asciiz "Press [ to continue."
.align 4

@intro_done:
.asciiz "Press [ to begin."
.align 4

@intro_text_table:
.word @intro_text_1, @intro_continue
.word @intro_text_2, @intro_done

@distance_text_buffer:
.fill 16, 0
.align 4
@distance_text_length:
.word 0

@endgame_text_1:
.asciiz "A WINNER IS YOU"
.align 4

@endgame_text_2:
.ascii "You can find the source code (as much as assembly\\"
.ascii "language can be considered source code) of this hack\\"
.ascii "as well as a bunch of useful labels, helper functions,\\"
.ascii "and macros on my GitLab at\\"
.asciiz "gitlab.com@mpharoah@sm64-romhacking-stuff"
.align 4

@endgame_images:
.word 0x06000000, 0x02011AC0
G_RDPPIPESYNC
.word 0xFD100000, chalice_img
.word 0x06000000, @prepare_texture_32x32
.word 0xE42BC123, 0x002400A8
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x10000400
G_RDPPIPESYNC
.word 0xFD100000, mario_img
.word 0x06000000, @prepare_texture_32x32
.word 0xE42BC19F, 0x00240124
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x10000400
G_RDPPIPESYNC
.word 0xFD100000, mountain_img
.word 0x06000000, @prepare_texture_32x32
.word 0xE42BC21B, 0x002401A0
	.word 0xB3000000, 0x00000000
	.word 0xB2000000, 0x10000400
G_RDPFULLSYNC
.word 0x06000000, 0x02011B28
G_ENDDL
