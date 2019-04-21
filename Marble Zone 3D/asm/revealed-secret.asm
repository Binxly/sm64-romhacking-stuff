.definelabel beh_revealed_secret, (org()-0x80000000)
.word 0x00080000
.word 0x11010001
.word 0x21000000
.word 0x0E457FFF
.word 0x08000000
.word 0x09000000

spawn_revealed_secret:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW A0, 0x10 (SP)

LW A0, g_current_obj_ptr
LI A2, beh_revealed_secret
JAL spawn_object
ORI A1, R0, 0x4A

LW AT, 0x10 (SP)
ADDIU AT, AT, 0xFFFF
SW AT, o_animation_frame (V0)

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
