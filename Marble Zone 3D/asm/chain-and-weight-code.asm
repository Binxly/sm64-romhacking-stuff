beh_weight_init:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LBU AT, o_arg1 (S0)
SW AT, o_timer (S0)
SW R0, o_speed_y (S0)

SLL A0, S0, 0x0
LI A2, beh_chain
JAL spawn_object
ORI A1, R0, 0x4D

LBU AT, o_arg0 (S0)
BNE AT, R0, @is_spike_platform
	LI AT, 0x433B8000
	SW AT, o_arg0 (V0)
	LI A0, weight_collision
	JAL segmented_to_virtual
	NOP
	B @finish_init
	SW V0, o_collision_pointer (S0)
@is_spike_platform:
	LI AT, 0x43C1C000
	SW AT, o_arg0 (V0)
	LI A0, spike_platform_collision
	JAL segmented_to_virtual
	NOP
	SW V0, o_collision_pointer (S0)
	
@finish_init:
SW R0, o_intangibility_timer (S0)
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

beh_weight_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

; Fix bug where there is a small chance of the rising platform eating your
; longjump height, but making it intangible for a few frames after longjumping
LI T0, g_mario
LW T1, m_action (T0)
LW AT, 0xFC (S0)
BEQ T1, AT, @end_longjump_fix
SW T1, 0xFC (S0)

LI AT, 0x03000888
BNE T1, AT, @end_longjump_fix

LW AT, m_floor_ptr (T0)
BEQ AT, R0, @end_longjump_fix
NOP
LW AT, t_object (AT)
BNE AT, S0, @end_longjump_fix
ORI AT, R0, 0x5
SW AT, o_intangibility_timer (S0)

@end_longjump_fix:
LW T0, o_timer (S0)

ORI AT, R0, 0x1
BNE T0, AT, @skip_whomp_sound
LUI AT, 0x44BC
MTC1 AT, F5
L.S F4, o_distance_to_mario (S0)
C.LE.S F4, F5
NOP
BC1F @skip_whomp_sound
LUI A0, 0x3044
JAL play_sound_2
ORI A0, A0, 0x8081

@skip_whomp_sound:
LW T0, o_timer (S0)
ORI AT, R0, 0xC0
BNE T0, AT, @endif_loop_cycle
NOP
	SLL T0, R0, 0x0
	SW T0, o_timer (S0)
@endif_loop_cycle:

SLTI AT, T0, 0x1E
BNE AT, R0, @fallen
SLTI AT, T0, 0xB4
BNE AT, R0, @rising
NOP

@falling:
ORI AT, R0, 0xC0
SUBU T0, AT, T0
MTC1 T0, F5
LI AT, 0x42885D17
MTC1 AT, F6
L.S F4, o_home_y (S0)
CVT.S.W F5, F5
MUL.S F5, F5, F6
ADD.S F4, F4, F5
B @handle_spike_platform_collision
S.S F4, o_y (S0)

@rising:
LUI AT, 0x44BC
MTC1 AT, F5
L.S F4, o_distance_to_mario (S0)
C.LE.S F4, F5
NOP
BC1F @skip_chain_sound
LUI A0, 0x400C
JAL play_sound_2
ORI A0, 0x8001
@skip_chain_sound:
LUI AT, 0x40A0
SW AT, o_speed_y (S0)
ADDIU T0, T0, 0xFFE3
SLL AT, T0, 0x2
ADDU T0, T0, AT
MTC1 T0, F5
L.S F4, o_home_y (S0)
CVT.S.W F5, F5
ADD.S F4, F4, F5
B @handle_spike_platform_collision
S.S F4, o_y (S0)

@fallen:
LW AT, o_home_y (S0)
SW AT, o_y (S0)

@handle_spike_platform_collision:
LBU AT, o_arg0 (S0)
BEQ AT, R0, @return

LHU AT, g_is_invulnerable
BNE AT, R0, @return

LI T0, g_mario
LW AT, m_ceiling_ptr (T0)
BEQ AT, R0, @return
NOP
LW AT, t_object (AT)
BNE AT, S0, @return
LUI AT, 0x4320
MTC1 AT, F6
L.S F4, o_y (S0)
L.S F5, m_y (T0)
ADD.S F5, F5, F6
L.S F6, m_speed_y (T0)
ADD.S F5, F5, F6
C.LE.S F4, F5
NOP
BC1F @return
ORI AT, R0, 0x8
SB AT, m_hurt_counter (T0)
ORI AT, 0x3C
SH AT, m_hitstun (T0)
SLL A0, T0, 0x0
JAL take_damage_and_knockback
SLL A1, S0, 0x0

@return:
LW AT, o_intangibility_timer (S0)
BNE AT, R0, @actually_return
NOP
JAL process_collision
NOP

@actually_return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
