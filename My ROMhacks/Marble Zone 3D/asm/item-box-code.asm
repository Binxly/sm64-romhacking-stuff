beh_item_box_init:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LI A1, 0x803303B0
JAL set_object_hitbox
SLL A0, S0, 0x0

SLL A0, S0, 0x0
LI A2, beh_item_box_icon
JAL spawn_object
ORI A1, R0, 0x4F

SW V0, 0xFC (S0)
LW AT, o_arg0 (S0)
SW AT, o_arg0 (V0)

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

beh_item_box_loop: 
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

JAL obj_was_attacked
NOP
BEQ V0, R0, @return
NOP

LW T0, 0xFC (S0)
ORI AT, R0, 0x1
SW AT, o_state (T0)
SW R0, o_timer (T0)

LBU T0, o_arg0 (S0)
BEQ T0, R0, @ring_box
ORI AT, R0, 0x1
BEQ T0, AT, @shield_box
NOP

@explode:
JAL spawn_explosion
SLL A0, S0, 0x0

JAL mark_object_for_deletion
SLL A0, S0, 0x0

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
J process_collision
ADDIU SP, SP, 0x18

@ring_box:
LI T0, g_mario
LHU T1, m_coins (T0)
ADDIU T1, T1, 0xA
SH T1, m_coins (T0)
SLTI AT, T1, 0x64
BNE AT, R0, @explode
SLTI AT, T1, 0x6E
BEQ AT, R0, @explode
ORI A0, R0, 0x6
LI.U RA, @explode
J 0x802AB558
LI.L RA, @explode

@shield_box:
LI A0, beh_shield
JAL get_nearest_object_with_behaviour
NOP
BNE V0, R0, @explode
NOP
LI RA, @explode
LW A0, g_mario_obj_ptr
LI A2, beh_shield
J spawn_object
ORI A1, R0, 0x49
