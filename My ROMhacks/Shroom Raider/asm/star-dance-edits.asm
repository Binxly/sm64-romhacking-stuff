.orga 0xA80C0
NOP

.orga 0x131F8
SETU A1, 0x4D

.orga 0x132C8
NOP

.orga 0x132F0
NOP

.orga 0x132FE
.halfword 2

.orga 0x13390
.area 0x7C
JAL 0x80248DC0
NOP
LI A0, g_mario
LI A1, 0x0C400201
JAL set_mario_action
MOVE A2, R0
JAL spawn_skull
NOP
J 0x8025840C
NOP
.endarea
