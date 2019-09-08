@RESPAWN_TIME equ 90
@MAX_SPEED_F16 equ 0x41F0 ; 30

skull_ref:
.word 0

@beh_skull:
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_INTERACTION 0x00000008
BHV_SET_HITBOX 50, 100, 50
BHV_SET_INT o_intangibility_timer, 32
BHV_SET_INT o_collision_damage, 6
BHV_SET_FLOAT o_x, -2596
BHV_SET_FLOAT o_y, -4200
BHV_SET_FLOAT o_z, -6800
BHV_SET_WORD o_state, @action_fade_in
BHV_EXEC @init
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC move_simple
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

@_speed equ 0xF4

@init:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LUI A0, 0x5048
JAL play_sound
ORI A0, A0, 0x8081

LI.U A0, beh_barrier
JAL get_nearest_object_with_behaviour
LI.L A0, beh_barrier
BEQ V0, R0, @@return
NOP
JAL mark_object_for_deletion
MOVE A0, V0

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

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

@action_fade_in:
	LW T0, o_opacity (S0)
	ADDIU T0, T0, 0x8
	SLTI AT, T0, 0xFF
	BNE AT, R0, @return
	SW T0, o_opacity (S0)
	SETU AT, 0xFF
	SW AT, o_opacity (S0)
	LI A0, (g_mario+m_x)
	ADDIU A1, S0, o_x
	JAL subtract_vectors_3d
	ADDIU A2, S0, o_speed_x
	MOVE A0, A2
	JAL normalize_vector
	MOVE A1, A2
	LI T0, @action_accelerate
	SW T0, o_state (S0)
	LUI AT, 0x3F80
	SW AT, @_speed (S0)
	JAL angle_to_unit_vector
	LW A0, o_face_angle_yaw (S0)
	S.S F0, o_speed_x (S0)
	S.S F1, o_speed_z (S0)
	B @return
	SW R0, o_timer (S0)

@action_accelerate:
	LUI AT, 0x40A0
	MTC1 AT, F5
	LUI AT, @MAX_SPEED_F16
	MTC1 AT, F6
	L.S F4, @_speed (S0)
	ADD.S F4, F4, F5
	C.LT.S F4, F6
	S.S F4, @_speed (S0)
	BC1T @action_chasing
	LI T0, @action_chasing
	SW T0, o_state (S0)
	JR T0
	S.S F6, @_speed (S0)

@action_chasing:
	JAL is_mario_voiding_out
	NOP
	BNE V0, R0, @@fade_out
	LW T0, o_interaction_status (S0)
	BEQ T0, R0, @@endif_hit_mario
		@@fade_out:
		LUI A0, 0x5048
		JAL play_sound
		ORI A0, A0, 0x8081
		LI T0, @action_fade_out
		SW T0, o_state (S0)
		SETU AT, (@RESPAWN_TIME+64)
		B @return
		SW AT, o_intangibility_timer (S0)
	@@endif_hit_mario:
	ADDIU SP, SP, 0xFFE0
	LI A0, (g_mario+m_x)
	JAL copy_vector
	ADDIU A1, SP, 0x14
	LUI AT, 0x42C8
	MTC1 AT, F5
	L.S F4, 0x18 (SP)
	ADD.S F4, F4, F5
	S.S F4, 0x18 (SP)
	ADDIU A0, SP, 0x14
	ADDIU A1, S0, o_x
	JAL subtract_vectors_3d
	ADDIU A2, SP, 0x14
	ADDIU A0, S0, o_speed_x
	ADDIU A1, SP, 0x14
	SETU A2, 0x800
	JAL turn_vector_3d
	MOVE A3, A1
	L.S F12, @_speed (S0)
	MOVE A0, A3
	JAL scale_vector_3d
	ADDIU A1, S0, o_speed_x
	ADDIU SP, SP, 0x20
	JAL vector_to_yaw_and_pitch
	ADDIU A0, S0, o_speed_x
	SW V0, o_face_angle_yaw (S0)
	B @return
	SW V1, o_face_angle_pitch (S0)
	
@action_fade_out:
	LW T0, o_opacity (S0)
	ADDIU T0, T0, 0xFFF8
	SLT AT, T0, R0
	BEQ AT, R0, @return
	SW T0, o_opacity (S0)
	SW T0, o_opacity (S0)
	SW R0, o_opacity (S0)
	SW R0, @_speed (S0)
	SW R0, o_speed_x (S0)
	SW R0, o_speed_y (S0)
	SW R0, o_speed_z (S0)
	LI T0, @action_respawning
	SW T0, o_state (S0)
	B @return
	SW R0, o_timer (S0)
	
@action_respawning:
	SW R0, o_face_angle_pitch (S0)
	LW T0, o_timer (S0)
	SLTI T0, @RESPAWN_TIME
	BNE T0, R0, @return
	LI T0, @action_fade_in
	SW T0, o_state (S0)
	LUI A0, 0x5048
	JAL play_sound
	ORI A0, A0, 0x8081
	B @return
	NOP

spawn_skull:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LW A0, g_mario_obj_ptr
LI A2, beh_music_switcher
JAL spawn_object
SETU A1, 0
LI T0, 0x447A7F26
SW T0, o_arg0 (V0)

LW A0, g_mario_obj_ptr
LI A2, (@beh_skull-0x80000000)
JAL spawn_object
SETU A1, 0x4C
SW V0, skull_ref

LW A0, g_mario_obj_ptr
LI A2, beh_door
JAL spawn_object
SETU A1, 0x48
LI AT, float( -2026 )
SW AT, o_x (V0)
LI AT, float( -2300 )
SW AT, o_y (V0)
LI AT, float( 3400 )
SW AT, o_z (V0)
SETU AT, 0x4000
SW AT, o_face_angle_yaw (V0)

LW A0, g_mario_obj_ptr
LI A2, beh_door
JAL spawn_object
SETU A1, 0x48
LI AT, float( -6600 )
SW AT, o_x (V0)
LI AT, float( -4500 )
SW AT, o_y (V0)
LI AT, float( -7126 )
SW AT, o_z (V0)

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
