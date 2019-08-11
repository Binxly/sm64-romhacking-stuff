@state:
.word 0 :: @_active_text equ 0x0
.word 0 :: @_next_text equ 0x4
.halfword 0 :: @_timer equ 0x8
.halfword 0 :: @_x equ 0xA
.byte 0 :: @_alpha equ 0xC
.byte 0 :: @_action equ 0xD
.byte 0xFF :: @_requires_initialization equ 0xE
.align 4

@SCREEN_WIDTH equ 1280

set_music_info:
LI T0, @state
SW A0, @_active_text (T0)
SW A1, @_next_text (T0)
SH R0, @_timer (T0)
SETU AT, @SCREEN_WIDTH
SH AT, @_x (T0)
SETU AT, 0xFF
SB AT, @_alpha (T0)
SETU AT, 0x1
JR RA
SB AT, @_action (T0)

@FLYOUT_MIN_X equ 684
@FLYOUT_SPEED equ 50
@DISPLAY_TIME equ 60
@FLYOUT_Y equ 700
@FLYOUT_HEIGHT equ 150


@STATE_HIDDEN equ 0
@STATE_FLY_IN equ 1
@STATE_TEXT_1 equ 2
@STATE_TEXT_FADE_OUT equ 3
@STATE_TEXT_FADE_IN equ 4
@STATE_TEXT_2 equ 5
@STATE_FLY_OUT equ 6

render_music_info:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LI S0, @state

LBU AT, @_requires_initialization (S0)
BEQ AT, R0, @endif_init_text
	SB R0, @_requires_initialization (S0)
	JAL init_music_info
	NOP
@endif_init_text:

LBU T0, @_action (S0)
SLL T0, T0, 0x2
LI T1, @action_table
ADDU T0, T1, T0
LW T0, 0x0 (T0)
JR T0
NOP

; Draw music info
@continue:
LHU A0, @_x (S0)
SETU A1, @FLYOUT_Y
SETU A2, (@SCREEN_WIDTH-@FLYOUT_MIN_X)
JAL create_draw_rect_command
SETU A3, @FLYOUT_HEIGHT

LI T0, @draw_rect_cmd
SW V0, 0x0 (T0)
SW V1, 0x4 (T0)

LI A0, (@box_fast3d-0x80000000)
JAL exec_display_list
NOP

LUI A0, 0xFFFF
ORI A0, A0, 0xFF00
LBU AT, @_alpha (S0)
JAL begin_print_encoded_text
OR A0, A0, AT

LHU A0, @_x (S0)
SRA A0, A0, 0x2
ADDIU A0, A0, 8
SETU A1, (240 - ((@FLYOUT_Y + ( @FLYOUT_HEIGHT >> 1 )) >> 2))
JAL print_encoded_text
LW A2, @_active_text (S0)

JAL end_print_encoded_text
NOP

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@box_fast3d:
G_RDPPIPESYNC
G_SET_CYCLE_TYPE G_CYC_FILL
G_SETFILLCOLOR_RGBA5551 31, 0, 0, 1
@draw_rect_cmd:
	NOP :: NOP
G_RDPFULLSYNC
G_ENDDL

@action_table:
.word @return
.word @action_fly_in
.word @action_text
.word @action_text_fade_out
.word @action_text_fade_in
.word @action_text
.word @action_fly_out

@action_fly_in:
LHU T0, @_x (S0)
SETU AT, @FLYOUT_SPEED
SUBU T0, T0, AT
SH T0, @_x (S0)
SETU T1, @FLYOUT_MIN_X
SLT AT, T0, T1
BEQ AT, R0, @continue
SETU AT, @STATE_TEXT_1
SB AT, @_action (S0)
SH T1, @_x (S0)
B @continue
SH R0, @_timer (S0)

@action_text:
LHU T0, @_timer (S0)
ADDIU T0, T0, 0x1
SETU AT, @DISPLAY_TIME
BNE T0, AT, @continue
SH T0, @_timer (S0)
LBU T0, @_action (S0)
ADDIU T0, T0, 0x1
SB T0, @_action (S0)
B @continue
SH R0, @_timer (S0)

@action_text_fade_out:
LBU T0, @_alpha (S0)
ADDIU T0, T0, 0xFFE9
SLTI AT, T0, 0x1
BEQ AT, R0, @continue
SB T0, @_alpha (S0)
SB R0, @_alpha (S0)
LW AT, @_next_text (S0)
SW AT, @_active_text (S0)
SETU AT, @STATE_TEXT_FADE_IN
B @continue
SB AT, @_action (S0)

@action_text_fade_in:
LBU T0, @_alpha (S0)
ADDIU T0, T0, 0x11
SLTI AT, T0, 0xFF
BNE AT, R0, @continue
SB T0, @_alpha (S0)
SETU AT, 0xFF
SB AT, @_alpha (S0)
SETU AT, @STATE_TEXT_2
B @continue
SB AT, @_action (S0)

@action_fly_out:
LHU T0, @_x (S0)
ADDIU T0, T0, @FLYOUT_SPEED
SETU T1, @SCREEN_WIDTH
SLT AT, T0, T1
BNE AT, R0, @continue
SH T0, @_x (S0)
SH T1, @_x (S0)
B @continue
SB R0, @_action (S0)
