mario_health_loop_shim:

LHU T0, g_level_num
ORI AT, R0, 0x9
BEQ T0, AT, @sonic_mode
NOP

J 0x80254060
NOP

@sonic_mode:
ADDIU SP, SP, 0xFFE8
SW A0, 0x18 (SP)
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LH AT, m_health (A0)
SLTI AT, AT, 0x100
BNE AT, R0, @shim_return
ORI AT, R0, 0x8FF
SH AT, m_health (A0)

LBU AT, m_hurt_counter (A0)
BEQ AT, R0, @disable_fall_damage
SB R0, m_hurt_counter (A0)

; crush death is instant kill
LI T0, g_mario
LW T1, m_action (T0)
LI T2, 0x00020339
BNE T1, T2, @not_being_crushed
	ORI AT, R0, 0xFF
	B @disable_fall_damage
	SH AT, m_health (T0)
@not_being_crushed:

; if Mario has a blue shield, remove it and return
SLL S0, A1, 0x0
LI A0, beh_shield
JAL get_nearest_object_with_behaviour
NOP
BEQ V0, R0, @no_shield
NOP
JAL mark_object_for_deletion
SLL A0, V0, 0x0
; TODO: play sound
B @disable_fall_damage
NOP

@no_shield:
SLL A1, S0, 0x0
LW A0, 0x18 (SP)

LHU S0, m_coins (A0)
BNE S0, R0, @endif_out_of_rings
ORI AT, R0, 0xFF
	B @disable_fall_damage
	SH AT, m_health (A0)
@endif_out_of_rings:

; spawn a maximum of 25 rings
SLTI AT, S0, 0x19
BNE AT, R0, @endif_coins_capped
NOP
	ORI S0, R0, 0x19
@endif_coins_capped:

@scatter_coins_loop:
	ADDIU S0, S0, 0xFFFF
	
	LW AT, 0x80361150
	BEQ AT, R0, @scatter_coins_loop_end
	
	LW A0, g_mario_obj_ptr
	LI A2, beh_lost_ring_script
	JAL spawn_object
	ORI A1, R0, 0x75
	
	BNE S0, R0, @scatter_coins_loop
	NOP
@scatter_coins_loop_end:

LI AT, g_mario
SH R0, m_coins (AT)
SH R0, g_displayed_coins

@disable_fall_damage:
LI T0, g_mario
LUI AT, 0xC680
SW AT, m_peak_height (T0)

@shim_return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
LW A0, 0x18 (SP)
JR RA
ADDIU SP, SP, 0x18
