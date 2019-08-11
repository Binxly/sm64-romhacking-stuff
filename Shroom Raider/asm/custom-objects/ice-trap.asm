@_trigger_radius equ 0xF4

.definelabel beh_ice_trap_impl,(org()-0x80000000)
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_FLOAT @_trigger_radius, 600
BHV_EXEC @init
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@beh_coldfire:
BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_AUTO_MOVE_XZ
BHV_BILLBOARD
BHV_SET_HITBOX 48, 48, 24
BHV_SET_INTERACTION 0x20000000
BHV_SET_INT o_intangibility_timer, 0
BHV_SCALE 0
BHV_SET_FLOAT o_speed_h, 10
BHV_REPEAT_BEGIN 16
	BHV_EXEC @scale_up
	BHV_SET_INT o_interaction_status, 0
BHV_REPEAT_END
BHV_REPEAT_BEGIN 2
	BHV_SET_INT o_interaction_status, 0
BHV_REPEAT_END
BHV_DELETE
BHV_END

@init:
LW T0, g_current_obj_ptr
LBU T1, o_arg0 (T0)
BEQ T1, R0, @@endif_alternating
	SETU AT, 0x1
	BEQ T1, AT, @@endif_start_off
		LI T1, @action_alternating_off
		JR RA
		SW T1, o_state (T0)
	@@endif_start_off:
		LI T1, @action_alternating_on
		JR RA
		SW T1, o_state (T0)
@@endif_alternating:
	LI T1, @action_sensor
	JR RA
	SW T1, o_state (T0)

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr
LW T0, o_state (S0)
JR T0
NOP

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@action_sensor:
	LW A0, g_mario_obj_ptr
	JAL get_dist_2d
	MOVE A1, S0
	L.S F4, @_trigger_radius (S0)
	C.LE.S F0, F4
	NOP
	BC1F @return
	NOP
	B @active
	NOP

@action_alternating_on:
	LW T0, o_timer (S0)
	SLTI AT, T0, 90
	BNE AT, R0, @active
	LI T0, @action_alternating_off
	B @return
	SW T0, o_state (S0)

@action_alternating_off:
	LW T0, o_timer (S0)
	SLTI AT, T0, 105
	BNE AT, R0, @return
	LI T0, @action_alternating_on
	B @return
	SW T0, o_state (S0)

@active:
LUI A0, 0x4005
JAL play_sound
ORI A0, A0, 0x0001
LW T0, o_timer (S0)
ANDI T0, T0, 0x1
BEQ T0, R0, @return
LI A2, (@beh_coldfire-0x80000000)
SETU A1, 0x91
JAL spawn_object
MOVE A0, S0
LW AT, o_face_angle_yaw (S0)
B @return
SW AT, o_move_angle_yaw (V0)

@scale_up:
LW T0, g_current_obj_ptr
LUI AT, 0x4020
MTC1 AT, F5
L.S F4, o_speed_h (T0)
ADD.S F4, F4, F5
S.S F4, o_speed_h (T0)
LUI AT, 0x3E80
MTC1 AT, F5
L.S F4, o_scale_x (T0)
ADD.S F4, F4, F5
MFC1 A1, F4
J scale_object
MOVE A0, T0
