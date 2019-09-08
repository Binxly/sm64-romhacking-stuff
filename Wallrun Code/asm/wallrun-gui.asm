@STAMINA_BAR_WIDTH equ (WALLRUN_STAMINA_BAR_WIDTH << 2)
@STAMINA_BAR_HEIGHT equ (WALLRUN_STAMINA_BAR_HEIGHT << 2)
@SCREEN_WIDTH equ 1280
@SCREEN_HEIGHT equ 960

render_wallrun_stamina:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LW T0, g_mario_obj_ptr
BEQ T0, R0, @@return

LI T0, g_mario
LW T1, m_action (T0)
LI T2, ACT_WALLRUN
BNE T1, T2, @@return

LI.S F4, 144
L.S F12, m_x (T0)
L.S F13, m_y (T0)
L.S F14, m_z (T0)
JAL perspective_transform
ADD.S F13, F13, F4

LI.S F4, (16 + @STAMINA_BAR_HEIGHT)
MTC1 R0, F6
SUB.S F5, F1, F4
C.LT.S F5, F6
LI.S F4, (@STAMINA_BAR_WIDTH / 2)
BC1T @@return
SUB.S F4, F0, F4
C.LT.S F4, F6
BEQ V0, R0, @@return
NOP
BC1T @@return

LI.S F7, @SCREEN_WIDTH
C.LE.S F4, F7
LI.S F8, @SCREEN_HEIGHT
BC1F @@return
CVT.W.S F4, F4
C.LE.S F5, F8
CVT.W.S F5, F5
BC1F @@return

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

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@stamina_bar_fast3d:
G_RDPPIPESYNC
G_SET_CYCLE_TYPE G_CYC_FILL
G_SETFILLCOLOR_RGBA5551 WALLRUN_STAMINA_BAR_BORDER_COLOUR,1
@draw_border: G_NOOP
G_SETFILLCOLOR_RGBA5551 WALLRUN_STAMINA_BAR_BACKGROUND_COLOUR,1
@draw_background: G_NOOP
G_SETFILLCOLOR_RGBA5551 WALLRUN_STAMINA_BAR_FILL_COLOUR,1
@draw_bar: G_NOOP
G_RDPFULLSYNC
G_ENDDL
