.definelabel beh_shield, (org()-0x80000000)
.word 0x00060000
.word 0x11010001
.word 0x21000000
.word 0x3200007D
.word 0x08000000
.word 0x0C000000, @beh_shield_loop
.word 0x09000000

@beh_shield_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LW A0, g_mario_obj_ptr
LI AT, g_camera_position
L.S F12, 0x0 (AT)
L.S F13, 0x4 (AT)
JAL unit_vector_from_object_to_point
L.S F14, 0x8 (AT)

LUI AT, 0x4310
MTC1 AT, F4
NOP
MUL.S F0, F0, F4
MUL.S F1, F1, F4
MUL.S F2, F2, F4

LI AT, g_mario
L.S F4, m_x (AT)
L.S F5, m_y (AT)
L.S F6, m_z (AT)
ADD.S F4, F4, F0
ADD.S F5, F5, F1
ADD.S F6, F6, F2

LW T0, g_current_obj_ptr
S.S F4, o_x (T0)
S.S F5, o_y (T0)
S.S F6, o_z (T0)

LW T1, o_timer (T0)
ORI AT, R0, 0x6
DIVU T1, AT
NOP
MFHI AT
LW RA, 0x14 (SP)
SW AT, o_animation_frame (T0)
JR RA
ADDIU SP, SP, 0x18
