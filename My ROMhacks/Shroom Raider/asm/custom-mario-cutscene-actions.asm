.definelabel ACT_CHECKPOINT_RESPAWN,0x0002190B
.definelabel ACT_INTRO_TEXT,0x0002130C
.definelabel ACT_IMPALED,0x0002130D
.definelabel ACT_ENDGAME,0x0002130E

@ORB_SPEED equ float(50)

mario_cutscene_actions_shim:
LI T0, g_mario
LW T1, m_action (T0)
LI AT, ACT_CHECKPOINT_RESPAWN
BEQ T1, AT, @checkpoint_respawn
LI AT, ACT_INTRO_TEXT
BEQ T1, AT, @intro_text
LI AT, ACT_IMPALED
BEQ T1, AT, @impaled
LI AT, ACT_ENDGAME
BEQ T1, AT, @endgame
NOP
J 0x8025D798
NOP

@checkpoint_respawn:
	L.S F4, m_x (T0)
	L.S F5, m_y (T0)
	L.S F6, m_z (T0)
	LW T1, m_action_arg (T0)
	L.S F7, o_x (T1)
	L.S F8, o_y (T1)
	L.S F9, o_z (T1)
	SUB.S F7, F7, F4
	SUB.S F8, F8, F5
	SUB.S F9, F9, F6
	MUL.S F10, F7, F7
	MUL.S F11, F8, F8
	ADD.S F10, F10, F11
	MUL.S F11, F9, F9
	ADD.S F10, F10, F11
	LI AT, @ORB_SPEED
	MTC1 AT, F11
	SQRT.S F10, F10
	C.LE.S F10, F11
	DIV.S F10, F10, F11
	BC1T @respawn
	NOP
	DIV.S F7, F7, F10
	DIV.S F8, F8, F10
	DIV.S F9, F9, F10
	ADD.S F4, F4, F7
	ADD.S F5, F5, F8
	ADD.S F6, F6, F9
	S.S F4, m_x (T0)
	S.S F5, m_y (T0)
	S.S F6, m_z (T0)
	LW T1, g_mario_obj_ptr
	S.S F4, o_x (T1)
	S.S F5, o_y (T1)
	S.S F6, o_z (T1)
	LHU T2, o_gfx_flags (T1)
	ANDI T2, T2, 0xFFFE
	SH T2, o_gfx_flags (T1)
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	MOVE A0, T1
	LI A2, beh_respawn_orb
	JAL spawn_object
	SETU A1, 0x8F
	LUI AT, 0x4290
	MTC1 AT, F5
	L.S F4, o_y (V0)
	ADD.S F4, F4, F5
	S.S F4, o_y (V0)
	S.S F4, 0x24 (V0)
	LW RA, 0x14 (SP)
	MOVE V0, R0
	JR RA
	ADDIU SP, SP, 0x18
	@respawn:
	LW AT, o_x (T1)
	SW AT, m_x (T0)
	LW AT, o_y (T1)
	SW AT, m_y (T0)
	SW AT, m_peak_height (T0)
	LW AT, o_z (T1)
	SW AT, m_z (T0)
	LW AT, o_face_angle_yaw (T1)
	SH AT, m_angle_yaw (T0)
	SH AT, 0x24 (T0)
	SW R0, m_speed_h (T0)
	SW R0, m_speed_y (T0)
	LW T1, g_mario_obj_ptr
	LHU T2, o_gfx_flags (T1)
	ORI T2, T2, 0x1
	SH T2, o_gfx_flags (T1)
	MOVE A0, T0
	LI A1, 0x010208B6 ; ACT_SOFT_BONK
	MOVE A2, R0
	J set_mario_action
	SETU V0, 0x1

@intro_text:
	LI T0, g_mario
	LHU T1, m_action_timer (T0)
	ADDIU T1, T1, 0x1
	SH T1, m_action_timer (T0)
	SLTI AT, T1, 45
	BNE AT, R0, @@return
	LW T1, m_controller (T0)
	BEQ T1, R0, @@return
	NOP
	LHU T1, c_buttons_pressed (T1)
	ANDI T1, T1, C_BUTTON_A
	BEQ T1, R0, @@return
	LH T1, m_action_state (T0)
	BNE T1, R0, @@endif_next_slide
		SETU T1, 0x1
		SH T1, m_action_state (T0)
		B @@return
		SH R0, m_action_timer (T0)
	@@endif_next_slide:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	MOVE A0, T0
	LI A1, 0x0C000203 ; ACT_SLEEPING
	JAL set_mario_action
	MOVE A2, R0
	LW RA, 0x14 (SP)
	ADDIU SP, SP, 0x18
	LI T0, g_mario
	SETU AT, 0x2
	SH AT, m_action_state (T0)
	@@return:
	JR RA
	MOVE V0, R0

@impaled:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI T0, g_mario
	LHU T1, m_action_timer (T0)
	BNE T1, R0, @@endif_init
		MOVE A0, T0
		JAL set_mario_animation
		SETU A1, 0x2C
		LUI A0, 0x2417
		JAL play_sound
		ORI A0, A0, 0x8081
	@@endif_init:
	LI T0, g_mario
	LHU T1, m_action_timer (T0)
	ADDIU T1, T1, 0x1
	SH T1, m_action_timer (T0)
	
	SETU AT, 0x7
	BNE T1, AT, @@endif_spawn_blood
		LW T1, g_current_obj_ptr
		SW T1, 0x10 (SP)
		LW T0, g_mario_obj_ptr
		SW T0, g_current_obj_ptr
		LI.U A0, @blood_particles
		JAL spawn_particles
		LI.L A0, @blood_particles
		LW T0, 0x10 (SP)
		SW T0, g_current_obj_ptr
		B @@endif_freeze_animation
	@@endif_spawn_blood:
	LW T0, g_mario_obj_ptr
	LH T1, o_animation_frame (T0)
	SLTI AT, T1, 0x8
	BNE AT, R0, @@endif_freeze_animation
		SETU AT, 0x8
		SH AT, o_animation_frame (T0)
	@@endif_freeze_animation:
	
	LI T0, g_mario
	LHU T1, m_action_timer (T0)
	SLTI AT, T1, 23
	BEQ AT, R0, @@endif_sink
		LW T0, g_mario_obj_ptr
		LUI AT, 0x4080
		MTC1 AT, F5
		L.S F4, o_gfx_y (T0)
		SUB.S F4, F4, F5
		S.S F4, o_gfx_y (T0)
	@@endif_sink:
	
	SETU AT, 30
	BNE T1, AT, @@return
	NOP
		JAL force_respawn
		SETU A0, 20
	
	@@return:
	MOVE V0, R0
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@endgame:
	JR RA
	MOVE V0, R0
	
check_for_endgame:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
LH T0, g_level_num
SETU AT, 0x5
BNE T0, AT, @@return
LI T0, g_mario
LW T0, m_action (T0)
LI T1, ACT_ENDGAME
BEQ T0, T1, @@return
LW A1, g_mario_obj_ptr
JAL start_cutscene
SETU A0, 178
LI A0, g_mario
LI A1, ACT_ENDGAME
JAL set_mario_action
MOVE A2, R0
LW A1, g_mario_obj_ptr
LUI A0, 0x701F
JAL set_sound
ORI A0, A0, 0x8081
@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@blood_particles:
.byte 0 ; behaviour argument
.byte 10 ; # of particles
.byte 70 ; model
.byte 0 ; vertical offset
.byte 11 ; base hvel
.byte 4 ; random hvel
.byte 27 ; base vvel
.byte 15 ; random vvel
.byte -3 ; gravity
.byte 0 ; drag
.align 4
.word float( 4 ) ; base size
.word float( 2 ) ; random size
