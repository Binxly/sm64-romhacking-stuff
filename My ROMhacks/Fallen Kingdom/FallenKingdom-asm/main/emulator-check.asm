emulator_check_init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LI A0, g_mario
	LI A1, ACT_NOP
	JAL set_mario_action
	MOVE A2, R0
	LI A0, g_mario
	
	LW T0, g_mario_obj_ptr
	LHU AT, o_gfx_flags (T0)
	ANDI AT, AT, 0xFFFE
	SH AT, o_gfx_flags (T0)
	
	LUI T0, 0x8034
	LHU AT, 0xB26A (T0)
	ANDI AT, AT, 0xFFF7
	SH AT, 0xB26A (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
render_emulator_check:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LHU T0, g_level_num
	SETU AT, 0x1B
	BNE T0, AT, @@return
	NOP
	
	JAL start_icon_rendering
	NOP
	JAL disable_texture_interpolation
	NOP
	
	LI A0, icon_key
	SETU A1, 400
	SETU A2, 576
	JAL render_icon
	SETU A3, ICON_SIZE_64x32 | ICON_SCALE_x1
	
	LI A0, icon_heart_full
	SETU A1, 500
	SETU A2, 576
	JAL render_icon
	SETU A3, ICON_SIZE_8x8 | ICON_SCALE_x4
	
	LI A0, icon_star
	SETU A1, 600
	SETU A2, 576
	JAL render_icon
	SETU A3, ICON_SIZE_16x16 | ICON_SCALE_x2
	
	LI A0, icon_star
	SETU A1, 700
	SETU A2, 560
	JAL render_icon
	SETU A3, ICON_SIZE_16x16 | ICON_SCALE_x4
	
	LI A0, icon_water
	SETU A1, 800
	SETU A2, 560
	JAL render_icon
	SETU A3, ICON_SIZE_32x32 | ICON_SCALE_x2
	
	
	JAL enable_texture_interpolation
	NOP
	JAL end_icon_rendering
	NOP
	
	LUI A0, 0xFFFF
	JAL begin_print_encoded_text
	ORI A0, A0, 0xFFFF
	
	LI A2, @txt_recommended
	SETU A0, 16
	JAL print_encoded_text
	SETU A1, 216
	
	LI A2, @txt_cpu_check
	SETU A0, 16
	JAL print_encoded_text
	SETU A1, 108
	
	LI A2, @txt_version
	SETU A0, 280
	JAL print_encoded_text
	SETU A1, 216
	
	JAL end_print_encoded_text
	NOP
	
	LUI A0, 0xFFFF
	JAL begin_print_encoded_text
	ORI A0, A0, 0x00FF
	
	LI A2, @txt_pj64
	SETU A0, 16
	JAL print_encoded_text
	SETU A1, 180
	
	JAL end_print_encoded_text
	NOP
	
	LUI A0, 0x00FF
	JAL begin_print_encoded_text
	ORI A0, A0, 0xFFFF
	
	LI A2, @txt_readme
	SETU A0, 16
	JAL print_encoded_text
	SETU A1, 144
	
	JAL end_print_encoded_text
	NOP
	
	JAL @verify_count_emulation
	NOP
	
	LI T0, @txt_fail
	BEQ V0, R0, @@check_result
	LUI A0, 0xFF00
		LUI A0, 0x00FF
		LI T0, @txt_pass
	@@check_result:
	ORI A0, A0, 0x00FF
	JAL begin_print_encoded_text
	SW T0, 0x10 (SP)
	
	SETU A0, 152
	SETU A1, 108
	JAL print_encoded_text
	LW A2, 0x10 (SP)
	
	JAL end_print_encoded_text
	NOP
	
	LUI A0, 0xFFFF
	JAL begin_print_encoded_text
	ORI A0, A0, 0xBFFF
	
	LI A2, @txt_start
	SETU A0, 100
	JAL print_encoded_text
	SETU A1, 24
	
	JAL end_print_encoded_text
	NOP
	
	LW T0, g_global_timer
	SLTIU AT, T0, 30
	BNE AT, R0, @@return
	
	LW T0, (g_mario + m_controller)
	BEQ T0, V0, @@return
	NOP
	LHU T0, c_buttons_pressed (T0)
	ANDI T0, T0, C_BUTTON_START
	BEQ T0, R0, @@return
	NOP
	
	SETU A0, 0x14
	SETU A1, 1
	SETU A2, 10
	JAL 0x8024A700
	MOVE A3, R0
	
	LI A0, g_mario
	LI A1, ACT_NOP
	JAL set_mario_action
	MOVE A2, R0
	LI A0, g_mario
	
	MOVE A0, R0
	JAL 0x802497B8
	MOVE A1, R0
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@verify_count_emulation:
	MFC0 T0, COUNT
	MFC0 T1, COUNT
	NOP
	SUBU AT, T1, T0
	JR RA
	SLTIU V0, AT, 2

@txt_recommended:
.string "Recommended Emulator: ParallelN64\nRecommended GFX Plugin: Glide64"
@txt_pj64:
.string "Project 64 is usable, but not recommended due to\npoor performance, accuracy, stability, and plugin support."
@txt_readme:
.string "Please consult the README.pdf that should have\ncome with this ROM before playing."
@txt_start:
.string "Press START to play"
@txt_cpu_check:
.string "CPU Clock Emulation Check:"
@txt_pass:
.string "PASS"
@txt_fail:
.string "FAIL"
@txt_version:
.string "v1.0.6"
.align 4
NOP
