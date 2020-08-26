end_screen_init:
	LW T0, g_mario_obj_ptr
	LHU AT, o_gfx_flags (T0)
	ANDI AT, AT, 0xFFFE
	SH AT, o_gfx_flags (T0)
	
	LUI T0, 0x8034
	LHU AT, 0xB26A (T0)
	ANDI AT, AT, 0xFFF7
	SH AT, 0xB26A (T0)

	LI A0, g_mario
	LI A1, ACT_NOP
	J set_mario_action
	MOVE A2, R0
	
render_end_screen:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LHU T0, g_level_num
	SETU AT, 0x1F
	BNE T0, AT, @@return

	LUI A0, 0xFFFF
	JAL begin_print_encoded_text
	ORI A0, A0, 0xFFFF
	
	LI A2, @text1
	SETU A0, 16
	JAL print_encoded_text
	SETU A1, 208
	
	LI A2, @text3
	SETU A0, 257
	JAL print_encoded_text
	SETU A1, 192
	
	LI A2, @text4
	SETU A0, 16
	JAL print_encoded_text
	SETU A1, 176
	
	JAL end_print_encoded_text
	NOP
	
	LUI A0, 0x00FF
	JAL begin_print_encoded_text
	ORI A0, A0, 0xFFFF
	
	LI A2, @text2
	SETU A0, 161
	JAL print_encoded_text
	SETU A1, 192
	
	JAL end_print_encoded_text
	NOP
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

beh_flower_impl:
	; BHV_START OBJ_LIST_DEFAULT
	BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
	BHV_BILLBOARD
	BHV_SET_FLOAT o_render_distance, 0x7FFF
	BHV_SLEEP 30
	BHV_EXEC @thanks
	BHV_END

@thanks:
	LUI A0, 0x7D1F
	J play_sound
	ORI A0, A0, 0xFF81
	
@text1:
.string "Thanks for playing!\nThis hack was created using"
@text2:
.string "Bowser's Blueprints"
@text3:
.string ", my new"
@text4:
.string "comprehensive ROMhacking tool. Check it out at\nhttps:@@blueprint64.ca"
.align 4
NOP
