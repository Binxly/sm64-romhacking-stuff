@prepare_texture_16x16 equ 0x02011AF8

render_pause_screen:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LH T0, g_play_mode
SETU AT, PLAY_MODE_PAUSED
BNE T0, AT, @@return
NOP

LI A0, @boxes_dl
JAL exec_display_list
NOP

LW T0, g_selected_item
SETU AT, 96
MULTU T0, AT
SETU A0, 108
MFLO AT
SETU A1, 432
ADDU A0, A0, AT
SETU A2, 79
JAL create_draw_rect_command
SETU A3, 79
LI T0, @selected_box
SW V0, 0x0 (T0)
SW V1, 0x4 (T0)

LUI A0, 0xFFFF
JAL begin_print_encoded_text
ORI A0, A0, 0xFFFF

LI A2, @str_controls
SETU A0, 26
JAL print_encoded_text
SETU A1, 200

LI A2, @str_items
SETU A0, 26
JAL print_encoded_text
SETU A1, 138

LI A2, @str_talismans
SETU A0, 26
JAL print_encoded_text
SETU A1, 82

LI T0, @item_info_table
LW AT, g_selected_item
SLL AT, AT, 2
ADDU T0, T0, AT
LW A2, 0x0 (T0)
SETU A0, 162
JAL print_encoded_text
SETU A1, 200

JAL end_print_encoded_text
NOP

JAL start_icon_rendering
NOP

JAL disable_texture_interpolation
NOP

LI A0, @@item_icon_table
LBU A1, (global_vars + gv_items)
SETU A2, 440
JAL @draw_icons
SETU A3, ICON_SIZE_16x16 | ICON_SCALE_x4

LI A0, @@talisman_icon_table
LBU A1, (global_vars + gv_talismans)
SETU A2, 664
JAL @draw_icons
SETU A3, ICON_SIZE_32x32 | ICON_SCALE_x2

JAL end_icon_rendering
NOP

JAL enable_texture_interpolation
NOP

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@@item_icon_table:
.word icon_star
.word icon_boots
.word icon_bombs
.word icon_lens
.word icon_feather

@@talisman_icon_table:
.word icon_wood
.word icon_fire
.word icon_earth
.word icon_metal
.word icon_water

@draw_icons:
; a0 = icon table
; a1 = flags
; a2 = y position
; a3 = size and scale
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)
SW A0, 0x18 (SP)
SW A1, 0x1C (SP)
SW A2, 0x20 (SP)
SW A3, 0x24 (SP)
MOVE S0, R0

@@loop:
	SETU AT, 1
	SLLV T0, AT, S0
	LW AT, 0x1C (SP)
	AND AT, AT, T0
	BEQ AT, R0, @@endif_show_icon
		LW T0, 0x18 (SP)
		SLL AT, S0, 2
		ADDU T0, T0, AT
		LW A0, 0x0 (T0)
		SETU AT, 96
		MULTU S0, AT
		SETU T0, 116
		MFLO AT
		LW A2, 0x20 (SP)
		ADDU A1, T0, AT
		JAL render_icon
		LW A3, 0x24 (SP)
	@@endif_show_icon:
	SLTI AT, S0, 4
	BNE AT, R0, @@loop
	ADDIU S0, S0, 1

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

.definelabel @boxes_dl, (org() - 0x80000000)
G_RDPPIPESYNC
G_SET_CYCLE_TYPE G_CYC_FILL
G_SETFILLCOLOR_RGBA5551 0, 0, 0, 1
G_FILLRECT 84, 92, 595, 304
G_FILLRECT 84, 336, 595, 527
G_FILLRECT 84, 560, 595, 751
G_FILLRECT 628, 92, 1191, 751
G_SETFILLCOLOR_RGBA5551 19, 19, 19, 1
G_FILLRECT 108, 432, 187, 511
G_FILLRECT 204, 432, 283, 511
G_FILLRECT 300, 432, 379, 511
G_FILLRECT 396, 432, 475, 511
G_FILLRECT 492, 432, 571, 511
G_SETFILLCOLOR_RGBA5551 10, 10, 10, 1
G_FILLRECT 108, 656, 187, 735
G_FILLRECT 204, 656, 283, 735
G_FILLRECT 300, 656, 379, 735
G_FILLRECT 396, 656, 475, 735
G_FILLRECT 492, 656, 571, 735
G_SETFILLCOLOR_RGBA5551 31, 31, 23, 1
@selected_box: G_NOOP
G_RDPFULLSYNC
G_ENDDL

@str_controls:
.string "<D> Browse Items\n { Warp to Star Road\n } Save Game"
.align 4

@str_items:
.string "ITEMS"
.align 4

@str_talismans:
.string "TALISMANS"
.align 4

@item_info_table:
.word @@str_item_star
.word @@str_item_boots
.word @@str_item_bombs
.word @@str_item_lens
.word @@str_item_feather

@@str_item_star:
.string "WARP STAR\nThe warp star allows you\nto return to Star Road at\nany time by pressing { on\nthe pause screen. Up, up,\nand awaaaaaay!"
.align 4

@@str_item_boots:
.string "PEGASUS BOOTS\nThese winged boots allow\nyou to effortlessly run\nalong vertical walls. While\nwall running, you can\npress [ to perform a wall\njump or press { to drop\noff of the wall."
.align 4

@@str_item_bombs:
.string "BOMB BAG\nThis trusty bag allows you\nto carry up to 10 bombs.\nJust press { while holding\na blue Bob-omb to store it\nin your bag. Press |^ or\n+while crouched to pull\nout a stored bomb."
.align 4

@@str_item_lens:
.string "LENS OF TRUTH\nThis mysterious lens lets\nyou see spirits that have\nnot yet found peace. This\nitem is always active...\nand always spooky!"
.align 4

@@str_item_feather:
.string "ROC'S FEATHER\nThis unassuming feather\nbestows the ability to\njump off of thin air!\nPress [ while in the air\nto perform a double jump.\nAfter double jumping, you\nmust touch the floor\nbefore you may double\njump again."
.align 4
