.definelabel beh_sawblade_impl,(org()-0x80000000)
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_INTERACTION 0x00000008
BHV_SET_HITBOX 275, 20, 10
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INT o_collision_damage, 8
BHV_STORE_HOME
BHV_SET_WORD o_state, @action_hidden
BHV_EXEC @init
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

@init:
LW T0, g_current_obj_ptr
LHU T1, o_gfx_flags (T0)
ORI T1, T1, 0x10
JR RA
SH T1, o_gfx_flags (T0)

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LW T0, o_face_angle_yaw (S0)
LB T1, o_arg0 (S0)
BEQ T1, R0, @@endif_reversed
SETU AT, 0xC80
	SUBU AT, R0, AT
@@endif_reversed:
ADDU T0, T0, AT
SW T0, o_face_angle_yaw (S0)

LW T0, o_state (S0)
JR T0
NOP

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@action_hidden:
	LI T0, g_mario
	LUI AT, 0xC51C
	MTC1 AT, F5
	L.S F4, m_y (T0)
	C.LE.S F4, F5
	LUI AT, 0x449C
	BC1T @return
	MTC1 AT, F5
	L.S F4, m_z (T0)
	C.LT.S F4, F5
	LUI AT, 0xC40A
	BC1F @return
	MTC1 AT, F5
	LI T1, @action_extending
	C.LE.S F4, F5
	LHU T0, o_gfx_flags (S0)
	BC1T @return
	ANDI T0, T0, 0xFFEF
	SH T0, o_gfx_flags (S0)
	SW T1, o_state (S0)
	B @return
	SW R0, o_timer (S0)

@action_extending:
	SETU AT, 4
	LW T0, o_timer (S0)
	BNE T0, AT, @@endif_fully_extended
		LI T0, @action_moving
		SW T0, o_state (S0)
		B @action_moving
		SW R0, o_timer (S0)
	@@endif_fully_extended:
	LUI A0, 0x4018
	JAL play_sound
	ORI A0, A0, 0x8001
	LUI AT, 0x425C
	MTC1 AT, F5
	LB AT, o_arg0 (S0)
	BEQ AT, R0, @@endif_flip_direction
	L.S F4, o_x (S0)
		NEG.S F5, F5
	@@endif_flip_direction:
	ADD.S F4, F4, F5
	B @return
	S.S F4, o_x (S0)
	
@action_moving:
	SETU AT, 69
	LW T0, o_timer (S0)
	BNE T0, AT, @@endif_end_of_track
		LI T0, @action_retracting
		SW T0, o_state (S0)
		B @return
		SW R0, o_timer (S0)
	@@endif_end_of_track:
	LUI A0, 0x4018
	JAL play_sound
	ORI A0, A0, 0x8001
	LUI AT, 0x4248
	MTC1 AT, F5
	L.S F4, o_z (S0)
	ADD.S F4, F4, F5
	B @return
	S.S F4, o_z (S0)
	
@action_retracting:
	SETU AT, 4
	LW T0, o_timer (S0)
	BNE T0, AT, @@endif_fully_retracted
		LI T0, @action_delay
		SW T0, o_state (S0)
		LHU T0, o_gfx_flags (S0)
		ORI T0, T0, 0x10
		SH T0, o_gfx_flags (S0)
		L.S F4, o_home_z (S0)
		S.S F4, o_z (S0)
		L.S F4, o_home_x (S0)
		S.S F4, o_x (S0)
		B @return
		SW R0, o_timer (S0)
	@@endif_fully_retracted:
	LUI A0, 0x4018
	JAL play_sound
	ORI A0, A0, 0x8001
	LUI AT, 0x425C
	MTC1 AT, F5
	LB AT, o_arg0 (S0)
	BEQ AT, R0, @@endif_flip_direction
	L.S F4, o_x (S0)
		NEG.S F5, F5
	@@endif_flip_direction:
	SUB.S F4, F4, F5
	B @return
	S.S F4, o_x (S0)
	
@action_delay:
	LW T0, o_timer (S0)
	SETU AT, 40
	BNE T0, AT, @return
	LI T0, @action_hidden
	B @return
	SW T0, o_state (S0)
