file_select_init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL 0x802799DC
	NOP
	
	MOVE A0, R0
	SETU A1, 15
	MOVE A2, R0
	MOVE A3, R0
	JAL play_transition
	SW R0, 0x10 (SP)
	
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
	
	ORI T0, 0x8FF
	SH T0, (g_mario + m_health)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
file_objects:
.word 0, 0, 0, 0
	
beh_save_file_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_COLLISION bb_level_20_object_Existing_File_collision
BHV_SET_FLOAT o_collision_distance, 1024
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INT o_state, 0
BHV_EXEC @save_file_init
BHV_LOOP_BEGIN
	BHV_EXEC @save_file_loop
	BHV_EXEC process_collision
BHV_LOOP_END

@_level_name equ 0xF4
@_max_hp equ 0xF8
@_hp equ 0xF9
@_items equ 0xFA
@_talismans equ 0xFB
@_bombs equ 0xFC
@_exists equ 0xFD
@_clicked equ 0xFE

@save_file_init:
	ADDIU SP, SP, 0xFFD8
	SW RA, 0x24 (SP)
	
	LW T0, g_current_obj_ptr
	LBU A1, o_arg0 (T0)
	JAL fetch_save_data
	ADDIU A0, SP, 0x10
	
	LI T0, 0xDEADBEEF
	LW AT, (0x10 + sv_signature) (SP)
	BNE T0, AT, @@empty_file
		LW T0, g_current_obj_ptr
		SETU AT, 1
		SB AT, @_exists (T0)
		SW AT, o_state (T0)
		LBU AT, (0x10 + gv_max_health) (SP)
		SB AT, @_max_hp (T0)
		LBU AT, (0x10 + sv_health) (SP)
		SB AT, @_hp (T0)
		LBU AT, (0x10 + gv_items) (SP)
		SB AT, @_items (T0)
		LBU AT, (0x10 + gv_talismans) (SP)
		SB AT, @_talismans (T0)
		LBU AT, (0x10 + gv_bombs) (SP)
		SB AT, @_bombs (T0)
		LI T1, @level_name_table
		LHU AT, (0x10 + sv_level) (SP)
		SLL AT, AT, 2
		ADDU AT, T1, AT
		LW AT, 0x0 (AT)
		SW AT, @_level_name (T0)
		JAL 0x802A04C0
		SETU A0, 26
		B @@return
	@@empty_file:
		LW T0, g_current_obj_ptr
		SB R0, @_exists (T0)
		SW R0, o_state (T0)
		JAL 0x802A04C0
		SETU A0, 30
	@@return:
	LW RA, 0x24 (SP)
	JR RA
	ADDIU SP, SP, 0x28
	
@save_file_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LBU AT, @_clicked (T0)
	BEQ AT, R0, @@return
		LBU T0, o_arg0 (T0)
		SH T0, g_save_file_num
		
		JAL load_game
		NOP
		
		LW T0, g_current_obj_ptr
		LW AT, o_state (T0)
		BNE AT, R0, @@endif_create
			LI A0, 0x701EFF81
			LUI A1, 0x8033
			JAL set_sound
			ORI A1, A1, 0x31F0
			
			JAL refresh_save_buffer
			NOP
			
			LI.U RA, @@return
			J @save_file_init
			LI.L RA, @@return
		@@endif_create:
			LI A0, 0x7024FF81
			LUI A1, 0x8033
			JAL set_sound
			ORI A1, A1, 0x31F0
			
			LHU A0, (global_vars + sv_level)
			SETU A1, 1
			SETU A2, 10
			JAL 0x8024A700
			MOVE A3, R0
			
			MOVE A0, R0
			JAL 0x802497B8
			MOVE A1, R0
			
			SH R0, 0x8033BACC
			LHU T0, (global_vars + sv_health)
			SH T0, (g_mario + m_health)
		
	@@return:
	LW T0, g_current_obj_ptr
	SB R0, @_clicked (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

beh_cursor_impl:
; BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_LOOP_BEGIN
	BHV_EXEC @cursor_loop
	BHV_EXEC @handle_click
BHV_LOOP_END

@cursor_loop:
	LW T0, (g_mario + m_controller)
	BEQ T0, R0, @@return
	LW T1, g_current_obj_ptr
	L.S F4, o_z (T1)
	L.S F5, o_y (T1)
	LI.S F8, 8
	L.S F6, c_analog_float_x (T0)
	L.S F7, c_analog_float_y (T0)
	NEG.S F6, F6
	DIV.S F6, F6, F8
	DIV.S F7, F7, F8
	ADD.S F4, F4, F6
	ADD.S F5, F5, F7
	LI.S F7, 150
	LI.S F8, 110
	MIN.S F4, F4, F7
	MIN.S F5, F5, F8
	LI.S F9, 20
	NEG.S F7, F7
	NEG.S F8, F8
	ADD.S F8, F8, F9
	MAX.S F4, F4, F7
	MAX.S F5, F5, F8
	S.S F4, o_z (T1)
	S.S F5, o_y (T1)
	@@return:
	JR RA
	NOP
	
@handle_click:
	ADDIU SP, SP, 0xFFC0
	SW RA, 0x3C (SP)
	
	LW T0, (g_mario + m_controller)
	BEQ T0, R0, @@return
	NOP
	LHU AT, c_buttons_pressed (T0)
	ANDI AT, AT, C_BUTTON_A
	BEQ AT, R0, @@return
	
	LW T0, g_current_obj_ptr
	ADDIU A0, T0, o_position
	JAL copy_vector
	ADDIU A1, SP, 0x10
	
	SW R0, 0x1C (SP)
	LI AT, float( 6 )
	SW AT, 0x20 (SP)
	SW R0, 0x24 (SP)
	
	JAL 0x80380E8C
	ADDIU A0, SP, 0x10
	
	BEQ V0, R0, @@return
	LW AT, 0x28 (SP)
	LW T0, t_object (AT)
	SETU AT, 0x1
	SB AT, @_clicked (T0)
	
	@@return:
	LW RA, 0x3C (SP)
	JR RA
	ADDIU SP, SP, 0x40

@level_name_table:
.word @@LN_UNKNOWN, @@LN_UNKNOWN, @@LN_UNKNOWN, @@LN_UNKNOWN
.word @@LN_EINTEI
.word @@LN_RAPIDS
.word @@LN_PLAINS
.word @@LN_BOTW
.word @@LN_MINES
.word @@LN_CHASM
.word @@LN_UNKNOWN
.word @@LN_CASTLE
.word @@LN_MOUNTAIN
.word @@LN_UNKNOWN, @@LN_UNKNOWN, @@LN_UNKNOWN
.word @@LN_HUB
.word @@LN_UNKNOWN, @@LN_UNKNOWN, @@LN_UNKNOWN, @@LN_UNKNOWN, @@LN_UNKNOWN
.word @@LN_WATER
.word @@LN_FOREST
.word @@LN_TOWN
.word @@LN_UNKNOWN, @@LN_UNKNOWN

@@LN_EINTEI:
.string "Forest Secret"
@@LN_RAPIDS:
.string "Restless Rapids"
@@LN_PLAINS:
.string "Great Plains"
@@LN_BOTW:
.string "Secret of the Well"
@@LN_MINES:
.string "Tal Tal Mines"
@@LN_CHASM:
.string "Chasm of Lost Hope"
@@LN_CASTLE:
.string "Bowser's Castle"
@@LN_MOUNTAIN:
.string "Tal Tal Mountain"
@@LN_HUB:
.string "Star Road"
@@LN_WATER:
.string "Flooded Temple"
@@LN_FOREST:
.string "Bamboo Forest"
@@LN_TOWN:
.string "Ruined Town"
@@LN_UNKNOWN:
.string "???"
.align 4

file_select_render:
	ADDIU SP, SP, 0xFFE0
	SW RA, 0x1C (SP)
	SW S0, 0x18 (SP)
	SW S1, 0x14 (SP)
	
	LW T0, g_mario_obj_ptr
	BEQ T0, R0, @@return
	
	LHU T0, g_level_num
	SETU AT, 0x14
	BNE T0, AT, @@return
	
	LW T0, 0x803610E8
	ADDIU S1, T0, 0x3A8
	LW S0, 0x60 (S1)
	
	JAL start_icon_rendering
	NOP
	
	JAL disable_texture_interpolation
	NOP
	
	@@loop:
	BEQ S0, S1, @@break
		LI T0, beh_save_file
		LW T1, o_behaviour (S0)
		BNE T0, T1, @@continue
		
		LBU AT, @_exists (S0)
		BEQ AT, R0, @@continue
		
		LBU T0, o_arg0 (S0)
		SLL T0, T0, 2
		LI T1, (@@file_positions - 4)
		ADDU T0, T1, T0
		LW AT, 0x0 (T0)
		SW AT, 0x10 (SP)
		
		LBU A0, @_items (S0)
		LI A1, @@item_icon_table
		LHU A2, 0x10 (SP)
		ADDIU A2, A2, 152
		LHU A3, 0x12 (SP)
		JAL @draw_icon_row
		ADDIU A3, A3, 68
		
		LBU A0, @_talismans (S0)
		LI A1, @@talisman_icon_table
		LHU A2, 0x10 (SP)
		ADDIU A2, A2, 152
		LHU A3, 0x12 (SP)
		JAL @draw_icon_row
		ADDIU A3, A3, 148
		
		
		LHU A0, 0x10 (SP)
		ADDIU A0, A0, 8
		LHU A1, 0x12 (SP)
		ADDIU A1, A1, 68
		
		LBU AT, @_hp (S0)
		SLL A2, AT, 24
		LBU AT, @_max_hp (S0)
		SLL AT, AT, 8
		OR A2, A2, AT
		
		JAL render_hearts
		SETU A3, 4
		
		LBU AT, @_items (S0)
		ANDI AT, AT, ITEM_BOMBS
		BEQ AT, R0, @@continue
			LI A0, icon_bombs
			LHU A1, 0x10 (SP)
			ADDIU A1, A1, 12
			LHU A2, 0x12 (SP)
			ADDIU A2, A2, 180
			JAL render_icon
			SETU A3, ICON_SIZE_16x16 | ICON_SCALE_x2
		@@continue:
		B @@loop
		LW S0, 0x60 (S0)
		
	@@break:
	JAL enable_texture_interpolation
	NOP
	
	LW T0, 0x803610E8
	ADDIU T0, T0, 0x340
	LW T0, 0x60 (T0)
	
	LI T1, beh_cursor
	LW T2, o_behaviour (T0)
	BNE T1, T2, @@endif_render_cursor
		L.S F12, o_x (T0)
		L.S F13, o_y (T0)
		JAL perspective_transform
		L.S F14, o_z (T0)
		
		CVT.W.S F0, F0
		CVT.W.S F1, F1
		MFC1 A1, F0
		MFC1 A2, F1
		
		SRL A1, A1, 2
		SLL A1, A1, 2
		SRL A2, A2, 2
		SLL A2, A2, 2
		
		LI A0, @cursor_img
		JAL render_icon
		SETU A3, ICON_SIZE_32x32 | ICON_SCALE_x2
	@@endif_render_cursor:
	
	JAL end_icon_rendering
	NOP
	
	LW T0, 0x803610E8
	ADDIU S1, T0, 0x3A8
	LW S0, 0x60 (S1)
	
	LUI A0, 0xFFFF
	JAL begin_print_encoded_text
	ORI A0, A0, 0xFFFF
	
	LI T0, 0xFB00FF00
	SW T0, 0x10 (SP)
	
	@@loop2:
	BEQ S0, S1, @@break2
		LI T0, beh_save_file
		LW T1, o_behaviour (S0)
		BNE T0, T1, @@continue2
		
		LBU AT, @_exists (S0)
		BEQ AT, R0, @@continue2
		
		LBU T0, o_arg0 (S0)
		SLL T0, T0, 2
		LI T1, (@@file_positions - 4)
		ADDU T0, T1, T0
		LW AT, 0x0 (T0)
		SW AT, 0x14 (SP)
		
		LHU AT, 0x14 (SP)
		SRL AT, AT, 2
		SH AT, 0x14 (SP)
		
		LHU AT, 0x16 (SP)
		SRL T0, AT, 2
		SETU AT, 240
		SUBU AT, AT, T0
		ADDIU AT, AT, 0xFFF3
		SH AT, 0x16 (SP)
		
		; bomb count
		LBU AT, @_items (S0)
		ANDI AT, AT, ITEM_BOMBS
		BEQ AT, R0, @@endif_show_bomb_count
			LHU A0, 0x14 (SP)
			ADDIU A0, A0, 12
			LHU A1, 0x16 (SP)
			ADDIU A1, A1, -44
			LBU AT, @_bombs (S0)
			SB AT, 0x11 (SP)
			JAL print_encoded_text
			ADDIU A2, SP, 0x10
		@@endif_show_bomb_count:
		
		; file index
		LHU A0, 0x14 (SP)
		ADDIU A0, A0, 3
		LHU A1, 0x16 (SP)
		ADDIU A1, A1, -4
		LI A2, @file_string
		JAL print_encoded_text
		NOP
		
		LHU A0, 0x14 (SP)
		ADDIU A0, A0, 28
		LHU A1, 0x16 (SP)
		ADDIU A1, A1, -4
		LBU AT, o_arg0 (S0)
		ADDIU AT, AT, 0x9
		SB AT, 0x11 (SP)
		JAL print_encoded_text
		ADDIU A2, SP, 0x11
		
		LW T0, g_display_list_head
		LUI AT, 0xFB00
		SW AT, 0x0 (T0)
		LI AT, 0xD8D8D8D8
		SW At, 0x4 (T0)
		ADDIU T0, T0, 8
		SW T0, g_display_list_head
		
		; level name
		LHU A0, 0x14 (SP)
		ADDIU A0, A0, 38
		LHU A1, 0x16 (SP)
		ADDIU A1, A1, -4
		JAL print_encoded_text
		LW A2, @_level_name (S0)
		
		LW T0, g_display_list_head
		LUI AT, 0xFB00
		SW AT, 0x0 (T0)
		LI AT, 0xFFFFFFFF
		SW At, 0x4 (T0)
		ADDIU T0, T0, 8
		SW T0, g_display_list_head
		
		@@continue2:
		B @@loop2
		LW S0, 0x60 (S0)
	@@break2:
	
	JAL end_print_encoded_text
	NOP
	
	@@return:
	LW S1, 0x14 (SP)
	LW S0, 0x18 (SP)
	LW RA, 0x1C (SP)
	JR RA
	ADDIU SP, SP, 0x20
	
@@file_positions:
.halfword 60, 280
.halfword 656, 280
.halfword 60, 580
.halfword 656, 580

@@item_icon_table:
.word icon_star
.word icon_boots
.word icon_bombs
.word icon_lens
.word icon_feather
.word ICON_SIZE_16x16 | ICON_SCALE_x4

@@talisman_icon_table:
.word icon_wood
.word icon_fire
.word icon_earth
.word icon_metal
.word icon_water
.word ICON_SIZE_32x32 | ICON_SCALE_x2

@draw_icon_row:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)
	
	SW A0, 0x18 (SP)
	SW A1, 0x1C (SP)
	SW A2, 0x20 (SP)
	SW A3, 0x24 (SP)
	
	MOVE S0, R0
	@@loop:
		LW T0, 0x18 (SP)
		SETU AT, 1
		SLLV AT, AT, S0
		AND AT, T0, AT
		BEQ AT, R0, @@continue
	
		LW A0, 0x1C (SP)
		LW A3, 0x14 (A0)
		SLL AT, S0, 2
		ADDU A0, A0, AT
		LW A0, 0x0 (A0)
		SETU AT, 80
		MULTU S0, AT
		LW A1, 0x20 (SP)
		MFLO AT
		LW A2, 0x24 (SP)
		JAL render_icon
		ADDU A1, A1, AT
	
		@@continue:
		SLTI AT, S0, 4
		BNE AT, R0, @@loop
		ADDIU S0, S0, 1
		
	
	LW S0, 0x10 (SP)
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
.definelabel @cursor_img, (org() - 0x80000000)
.incbin "../img/cursor.bin"

@file_string:
.string "FILE"
.align 4
