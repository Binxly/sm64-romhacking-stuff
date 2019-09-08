.definelabel beh_lost_ring_script, (org()-0x80000000)
.word 0x000C0000
.word 0x11010041
.word 0x21000000
.word 0x2F000000, 0x00000010
.word 0x30000000, 0x001EFE70, 0xFFBA03E8, 0x03E800C8, 0x00000000
;.word 0x30000000, 0x001EFE70, 0xFFBA0000, 0x000000C8, 0x00000000
.word 0x0C000000, @beh_lost_ring_init
.word 0x08000000
.word 0x0C000000, 0x802AB860 ; beh_coin_loop
.word 0x0F1A0001
.word 0x09000000

@beh_lost_ring_init:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

JAL 0x802ab7a4 ; beh_coin_init
NOP

LUI AT, 0x4120
MTC1 AT, F5

LUI AT, 0x4000
MTC1 AT, F6

LW S0, g_current_obj_ptr

L.S F4, o_speed_h (S0)
ADD.S F4, F4, F5
MUL.S F4, F4, F6
S.S F4, o_speed_h (S0)

L.S F4, o_speed_y (S0)
MUL.S F4, F4, F6
S.S F4, o_speed_y (S0)

ORI AT, R0, 0xF
SW AT, o_intangibility_timer (S0)

ORI AT, R0, 0x11D
SW AT, o_timer (S0)

LI A0, beh_lost_ring_script
JAL 0x802A148C ; set_object_behaviour
NOP

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

/*
I put lost rings in the unimportant objects list so that they would just get
despawned instead of crashing the game if we ran out of object slots. However,
this means Mario can't interact with them. This patch makes it so that Mario
checks for collision with objects in the unimportant objects list as well.
*/
mario_ineractions_shim:
SW RA, 0x10 (SP)

LUI AT, 0x8036
LW T0, 0x10E8 (AT)
LW A0, 0x18 (SP)
LW A1, 0x540 (T0)
JAL 0x802C93F8
ADDIU A2, T0, 0x4E0

LW RA, 0x10 (SP)
LW T8, 0x18 (SP)
JR RA
LW T9, 0x60 (T8)
