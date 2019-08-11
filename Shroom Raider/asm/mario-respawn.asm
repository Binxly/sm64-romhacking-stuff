.macro @average_vertex_posn, reg, off
	LH T1, (0x0A+off) (T0)
	LH AT, (0x10+off) (T0)
	ADDU T1, T1, AT
	LH AT, (0x16+off) (T0)
	ADDU T1, T1, AT
	SLL T1, T1, 0x2
	LUI AT, 0x4040
	MTC1 T1, F4
	MTC1 AT, F5
	CVT.S.W F4, F4
	DIV.S reg, F4, F5
.endmacro

@last_safe_position:
.word 0, 0, 0

@warp_timer:
.halfword -1
@death_timer:
.halfword -1

.align 4

save_last_safe_location:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LI T0, g_mario
LW T1, m_y (T0)
LW T2, m_floor_height (T0)
BNE T1, T2, @@return
LW T0, m_floor_ptr (T0)
BEQ T0, R0, @@return
NOP
LW AT, t_collision_type (T0)
BNE AT, R0, @@return
LW AT, t_object (T0)
BNE AT, R0, @@return
SW T0, 0x10 (SP)
JAL get_floor_steepness
MOVE A0, T0
SLTI AT, V0, 0x100
BEQ AT, R0, @@return
LW T0, 0x10 (SP)
@average_vertex_posn F0, 0
@average_vertex_posn F1, 2
@average_vertex_posn F2, 4
LI T0, @last_safe_position
S.S F0, 0x0 (T0)
S.S F1, 0x4 (T0)
S.S F2, 0x8 (T0)

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

handle_respawn:
LH T0, @death_timer
SLT AT, T0, R0
BNE AT, R0, @@endif_dying
	ADDIU T1, T0, 0xFFFF
	SH T1, @death_timer
	BNE T0, R0, @@return
		LI T0, g_mario
		SETU AT, 0x180
		SH AT, m_health (T0)
		SETU AT, 0x60
		SB AT, m_heal_counter (T0)
		SETU AT, 0x1E
		SH AT, m_hitstun (T0)
		LW T1, active_checkpoint ; I place a checkpoint at the start of every level, so this should never be NULL
		LW AT, o_x (T1)
		SW AT, m_x (T0)
		LW AT, o_z (T1)
		SW AT, m_z (T0)
		LUI AT, 0x437A
		MTC1 AT, F5
		L.S F4, o_y (T1)
		ADD.S F4, F4, F5
		S.S F4, m_y (T0)
		S.S F4, m_peak_height (T0)
		SW R0, m_speed_y (T0)
		LUI AT, 0xC1F0
		SW AT, m_speed_h (T0)
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		MOVE A0, T0
		LI A1, 0x010208B3
		JAL set_mario_action
		MOVE A2, R0
		JAL @update_mario_floor
		NOP
		LW T0, g_mario_obj_ptr
		LHU T1, o_gfx_flags (T0)
		ANDI T1, T1, 0xFFEF
		SH T1, o_gfx_flags (T0)
		SW R0, o_intangibility_timer (T0)
		LI A0, 0x24208081
		JAL set_sound
		ADDIU A1, T0, 0x54
		SETU A0, 0x12
		SETU A1, 0x30
		SETU A2, 0x20
		SETU A3, 0x0
		JAL play_transition
		SW R0, 0x10 (SP)
		LW RA, 0x14 (SP)
		J reset_camera
		ADDIU SP, SP, 0x18
@@endif_dying:

LI T0, g_mario
LB T1, m_health (T0)
BNE T1, R0, @@endif_cancel_warp
	SETS T2, 0xFFFF
	SH T2, @warp_timer
	B @@return
	NOP
@@endif_cancel_warp:
LH T1, @warp_timer
SLT AT, T1, R0
BNE AT, R0, @@return
NOP
BNE T1, R0, @@endif_respawn
ADDIU T1, T1, 0xFFFF
	SH T1, @warp_timer
	LI T2, @last_safe_position
	L.S F4, 0x0 (T2)
	L.S F5, 0x4 (T2)
	L.S F6, 0x8 (T2)
	S.S F4, m_x (T0)
	S.S F5, m_y (T0)
	S.S F6, m_z (T0)
	S.S F5, m_peak_height (T0)
	SW R0, m_speed_h (T0)
	SW R0, m_speed_y (T0)
	SETU AT, 0x2D
	SH AT, m_hitstun (T0)
	SETU AT, 0x10
	SB AT, m_hurt_counter (T0)
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	MOVE A0, T0
	LI A1, 0x00020462 ; soft backwards knockback
	JAL set_mario_action
	MOVE A2, R0
	JAL @update_mario_floor
	NOP
	SETU A0, 0x0
	SETU A1, 0x14
	SETU A2, 0x40
	SETU A3, 0x0
	JAL play_transition
	SW R0, 0x10 (SP)
	LUI A0, 0x1300
	JAL get_nearest_object_with_behaviour
	ORI A0, A0, 0x1478
	BEQ V0, R0, @@endif_switch_active
		SETU AT, 0x2
		LW T0, o_state (V0)
		BNE T0, AT, @@endif_switch_active
			SETU AT, 0x4
			SW AT, o_state (V0)
			SW R0, o_timer (V0)
	@@endif_switch_active:
	LW RA, 0x14 (SP)
	J reset_camera
	ADDIU SP, SP, 0x18
@@endif_respawn:
SH T1, @warp_timer
@@return:
JR RA
NOP

check_void_plane_shim:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LH T0, @warp_timer
SLT AT, T0, R0
BEQ AT, R0, @@return
LUI AT, 0x4500
MTC1 AT, F6
LI T0, g_mario
L.S F4, m_y (T0)
L.S F5, m_floor_height (T0)
ADD.S F5, F5, F6
C.LT.S F4, F5
LH T1, m_health (T0)
BC1F @@return
SLTI AT, T1, 0x500
BNE AT, R0, @@death_warp
SETU T1, 0x14
SH T1, @warp_timer
SETU A0, 0x1
SETU A1, 0x14
SETU A2, 0x40
SETU A3, 0x0
JAL play_transition
SW R0, 0x10 (SP)
LI T0, g_mario
LW T1, 0x04 (T0)
LUI AT, 0x4
AND T2, T1, AT
BNE T2, R0, @@return
OR T1, T1, AT
SW T1, 0x04 (T0)
LW T0, g_mario_obj_ptr
LI A0, 0x2410C081
JAL set_sound
ADDIU A1, T0, 0x54
@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
@@death_warp:
LW RA, 0x14 (SP)
SETU A0, 0x1B
J kill_mario
ADDIU SP, SP, 0x18

kill_mario:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

SH R0, 0x8033B252 ; Clear delayed warp

LH T0, @death_timer
SLT AT, T0, R0
BEQ AT, R0, @@return
SH A0, @death_timer

MOVE A1, A0
SETU A0, 0x13
SETU A2, 0x20
SETU A3, 0x0
JAL play_transition
SW R0, 0x10 (SP)
LW T0, g_mario_obj_ptr
LI A0, 0x70188081
JAL set_sound
ADDIU A1, T0, 0x54

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

force_mario_void_out:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LI T0, g_mario
LW AT, m_floor_height (T0)
SW AT, 0x10 (SP)

LW AT, m_y (T0)
JAL check_void_plane_shim
SW AT, m_floor_height (T0)

LI T0, g_mario
LW AT, 0x10 (SP)
SW AT, m_floor_height (T0)

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

is_mario_voiding_out:
LH T0, @warp_timer
SLT AT, T0, R0
BEQ AT, R0, @@yes
LH T0, @death_timer
SLT AT, T0, R0
BEQ AT, R0, @@yes
NOP
JR RA
SETU V0, 0x0
@@yes:
JR RA
SETU V0, 0x1

is_mario_dead_or_dying:
LH T0, @death_timer
SLT AT, T0, R0
BEQ AT, R0, @@yes
LI T0, g_mario
LH T0, m_health (T0)
SLTI AT, T0, 0x100
BNE AT, R0, @@yes
NOP
JR RA
SETU V0, 0x0
@@yes:
JR RA
SETU V0, 0x1

force_respawn:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LI T0, g_mario
LH T0, m_health (T0)
SLTI AT, T0, 0x500
BEQ AT, R0, @@endif_death_warp
	LW RA, 0x14 (SP)
	J kill_mario
	ADDIU SP, SP, 0x18
@@endif_death_warp:
SH A0, @warp_timer
MOVE A1, A0
SETU A0, 0x1
SETU A2, 0x40
JAL play_transition
SETU A3, 0x0

LI T0, g_mario
LW T1, 0x04 (T0)
LUI AT, 0x4
AND T2, T1, AT
BNE T2, R0, @@return
OR T1, T1, AT
	SW T1, 0x04 (T0)
@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@update_mario_floor:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
LI T0, g_mario
L.S F12, m_x (T0)
L.S F14, m_y (T0)
LW A2, m_z (T0)
JAL find_floor
ADDIU A3, SP, 0x10
LI T0, g_mario
S.S F0, m_floor_height (T0)
LW AT, 0x10 (SP)
SW AT, m_floor_ptr (T0)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
