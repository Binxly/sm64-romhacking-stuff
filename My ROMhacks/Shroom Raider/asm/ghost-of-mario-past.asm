pms_x equ 0x0
pms_y equ 0x4
pms_z equ 0x8
pms_action equ 0xC

mario_state_at_frame_start:
.word 0, 0, 0, 0

previous_mario_state:
.word 0, 0, 0, 0

.macro @double_copy, pms_field, m_field
	LW AT, pms_field (T1)
	SW AT, pms_field (T2)
	LW AT, m_field (T0)
	SW AT, pms_field (T1)
.endmacro

mario_behaviour_shim:
LI T0, g_mario
LI T1, mario_state_at_frame_start
LI T2, previous_mario_state
@double_copy pms_x, m_x
@double_copy pms_y, m_y
@double_copy pms_z, m_z
@double_copy pms_action, m_action
J 0x8029CA58
NOP
