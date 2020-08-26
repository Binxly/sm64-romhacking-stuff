handle_spikes:
	LI T0, g_mario
	LW T1, m_action (T0)
	LI AT, ACT_IMPALED
	BEQ T1, AT, @@return
	LI AT, ACT_VOID_OUT
	BEQ T1, AT, @@return
	LW T1, m_floor_ptr (T0)
	BEQ T1, R0, @@return
	LUI AT, 0x4000
	MTC1 AT, F6
	L.S F4, m_y (T0)
	L.S F5, m_floor_height (T0)
	SUB.S F4, F4, F5
	ABS.S F4, F4
	C.LE.S F4, F6
	LH T1, t_collision_type (T1)
	BC1F @@return
	SETU AT, 0x26
	BNE T1, AT, @@return
	MOVE A0, T0
	LI A1, ACT_IMPALED
	J set_mario_action
	MOVE A2, R0
	@@return:
	JR RA
	NOP

act_impaled_impl:
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
		LI.U A0, g_mario
		JAL bbp_9f5317da4fb645b89267ec1bc50d9aad_void_out
		LI.L A0, g_mario
	
	@@return:
	MOVE V0, R0
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@blood_particles:
.byte 0 ; behaviour argument
.byte 10 ; # of particles
.byte 81 ; model
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
