.definelabel beh_fireball, (org()-0x80000000)
.word 0x00060000
.word 0x11010001
.word 0x21000000
.word 0x2D000000
.word 0x320001F4
.word 0x08000000
.word 0x0C000000, @beh_fireball_loop
.word 0x0F1A0001
.word 0x09000000

@beh_fireball_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LI A1, @hitbox
JAL set_object_hitbox
SLL A0, S0, 0x0

LBU AT, o_arg0 (S0)
BNE AT, R0, @flying_fireball
NOP

/* jumping fireball */
L.S F4, o_y (S0)
L.S F5, o_speed_y (S0)
LUI AT, 0x4040
MTC1 AT, F6
ADD.S F4, F4, F5
S.S F4, o_y (S0)
SUB.S F5, F5, F6
S.S F5, o_speed_y (S0)
L.S F5, o_home_y (S0)
C.LT.S F4, F5
NOP
BC1F @return
NOP
JAL mark_object_for_deletion
SLL A0, S0, 0x0
B @return
NOP
	
/* flying fireball */
@flying_fireball:
L.S F4, o_x (S0)
L.S F5, o_speed_x (S0)
ADD.S F4, F4, F5
S.S F4, o_x (S0)

L.S F4, o_z (S0)
L.S F5, o_speed_z (S0)
ADD.S F4, F4, F5
S.S F4, o_z (S0)

LW T0, o_timer (S0)
LBU AT, o_arg2 (S0)
BNE T0, AT, @return
NOP

JAL mark_object_for_deletion
SLL A0, S0, 0x0

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@hitbox:
.word 0x00000008
.byte 0x11
.byte 0x01
.byte 0x00
.byte 0x00
.halfword 0x0011
.halfword 0x0022
.halfword 0x0011
.halfword 0x0022

