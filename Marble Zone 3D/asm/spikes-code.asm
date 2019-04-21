beh_spikes_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr
LW T0, o_timer (S0)
ANDI T0, T0, 0x3F

L.S F4, o_home_y (S0)

ORI AT, R0, 0x1F
BEQ T0, AT, @up_one_thirds
ORI AT, R0, 0x3E
BEQ T0, AT, @up_one_thirds
ORI AT, R0, 0x1E
BEQ T0, AT, @up_two_thirds
ORI AT, R0, 0x3F
BEQ T0, AT, @up_one_thirds
SLTI AT, T0, 0x1E
BNE AT, R0, @collision_check

LUI AT, 0x4389
MTC1 AT, F5
B @collision_check
SUB.S F4, F4, F5

@up_one_thirds:
LUI A0, 0x9043
JAL play_sound_2
ORI A0, 0x8081
LUI AT, 0x4305
MTC1 AT, F5
B @collision_check
SUB.S F4, F4, F5

@up_two_thirds:
LUI AT, 0x4285
MTC1 AT, F5
NOP
SUB.S F4, F4, F5

@collision_check:
S.S F4, o_y (S0)

LHU T0, g_is_invulnerable
BNE T0, R0, @return
NOP

LI T0, g_mario
LW T1, m_floor_ptr (T0)
BEQ T1, R0, @return
NOP
LW T1, t_object (T1)
BNE T1, S0, @return
L.S F5, o_y (S0)
LUI AT, 0x434A
MTC1 AT, F6
L.S F4, m_y (T0)
ADD.S F5, F5, F6
C.LE.S F4, F5
ORI AT, R0, 0x8
BC1F @return
SLL A0, T0, 0x0
SB AT, m_hurt_counter (T0)
ORI AT, 0x3C
SH AT, m_hitstun (T0)
JAL take_damage_and_knockback
SLL A1, S0, 0x0

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
J process_collision
ADDIU SP, SP, 0x18
