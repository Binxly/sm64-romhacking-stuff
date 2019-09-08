beh_rainbow_ring_init:
LW T0, g_current_obj_ptr
SW R0, o_state (T0)
LBU AT, o_arg1 (T0)
BEQ AT, R0, @skip_init
LUI AT, 0x4000
SW AT, o_scale_x (T0)
SW AT, o_scale_y (T0)
SW AT, o_scale_z (T0)
SW R0, @rings_collected
SW R0, @ring_timer
LI T1, @master_ring_position
LW AT, o_x (T0)
SW AT, 0x0 (T1)
LW AT, o_y (T0)
SW AT, 0x4 (T1)
LW AT, o_z (T0)
SW AT, 0x8 (T1)
@skip_init:
JR RA
NOP

beh_rainbow_ring_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LI A1, @rainbow_ring_hitbox
JAL set_object_hitbox
SLL A0, S0, 0x0

LW AT, @ring_timer
BNE AT, R0, @endif_timeup
NOP
	SW R0, o_state (S0)
	SW R0, @rings_collected
@endif_timeup:

LW AT, o_state (S0)
BNE AT, R0, @hidden
LW T0, @ring_timer
LBU AT, o_arg1 (S0)
OR T0, T0, AT
BEQ T0, R0, @hidden
LHU T0, 0x2 (S0)
ANDI T0, T0, 0xFFEF
B @check_collision
SH T0, 0x2 (S0)

@hidden:
LHU T0, 0x2 (S0)
ORI T0, T0, 0x10
B @finish
SH T0, 0x2 (S0)

@check_collision:
LW AT, o_interaction_status (S0)
ANDI AT, AT, 0x8000
BEQ AT, R0, @finish

LW T0, @rings_collected
ADDIU T0, T0, 0x1
SW T0, @rings_collected

ORI AT, R0, 0x1
SW AT, o_state (S0)

ORI AT, R0, 0x8
BEQ T0, AT, @last_ring_collected

SLL A0, T0, 0x0
SLL A1, R0, 0x0
SLL A2, R0, 0x0
JAL spawn_orange_number
SLL A3, R0, 0x0

LI A0, 0x78279081
LW AT, @rings_collected
SLL AT, AT, 0x10
ADDU A0, A0, AT
LUI A1, 0x8033
JAL set_sound
ORI A1, A1, 0x31F0

LBU AT, o_arg1 (S0)
BEQ AT, R0, @finish
ORI T0, R0, 0x23A
SW T0, @ring_timer
B @finish
NOP

@last_ring_collected:
LI AT, @master_ring_position
L.S F12, 0x0 (AT)
L.S F14, 0x4 (AT)
JAL spawn_star
LW A2, 0x8 (AT)
B @despawn_when_all_collected
NOP

@finish:
SW R0, o_interaction_status (S0)

LBU AT, o_arg1 (S0)
BEQ AT, R0, @despawn_when_all_collected
LW T0, @ring_timer
BEQ T0, R0, @despawn_when_all_collected
ADDIU T0, T0, 0xFFFF
SW T0, @ring_timer
SLTI AT, T0, 0x50
BEQ AT, R0, @play_timer_sound
LUI A0, 0x8054
	LUI A0, 0x8055
@play_timer_sound:
ORI A0, A0, 0xF011
LUI A1, 0x8033
JAL set_sound
ORI A1, A1, 0x31F0

@despawn_when_all_collected:
LW T0, @rings_collected
SLTI T0, T0, 0x8
BNE T0, R0, @return
ORI T0, R0, 0x2
SW T0, @ring_timer
JAL mark_object_for_deletion
SLL A0, S0, 0x0

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@rings_collected:
.word 0
@ring_timer:
.word 0
@master_ring_position:
.word 0, 0, 0

@rainbow_ring_hitbox:
.word 0x00000010
.word 0x00000000
.word 0x00640040
.word 0x00000000
