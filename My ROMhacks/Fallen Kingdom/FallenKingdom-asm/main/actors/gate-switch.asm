beh_gate_switch_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SCALE 150
BHV_SET_COLLISION 0x0800C7A8
BHV_SET_INT o_state, 0
BHV_SET_INT o_intangibility_timer, 0
BHV_EXEC @switch_init
BHV_LOOP_BEGIN
	BHV_EXEC @switch_loop
	BHV_EXEC process_collision
BHV_LOOP_END

.definelabel @beh_gate, (org() - 0x80000000)
BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO | OBJ_ALWAYS_ACTIVE
BHV_SET_COLLISION bb_level_22_object_Gate_collision
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INT o_state, 0
BHV_SET_FLOAT o_collision_distance, 1133
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_LOOP_BEGIN
	BHV_EXEC @gate_loop
	BHV_EXEC process_collision
BHV_LOOP_END

@gate_loop:
	LW T0, g_current_obj_ptr
	LW AT, o_state (T0)
	BEQ AT, R0, @@return
	LI.S F5, 50
	LW T1, o_timer (T0)
	SLTIU AT, T1, 14
	BNE AT, R0, @@return
	SLTIU AT, T1, 30
	BNE AT, R0, @@endif_despawn
		NOP
		J 0x803220F0
		SH R0, o_active_flags (T0)
	@@endif_despawn:
	LBU AT, o_arg0 (T0)
	SLTIU AT, AT, 2
	BNE AT, R0, @@endif_horizontal
		L.S F4, o_z (T0)
		ADD.S F4, F4, F5
		B @@return
		S.S F4, o_z (T0)
	@@endif_horizontal:
	L.S F4, o_y (T0)
	ADD.S F4, F4, F5
	S.S F4, o_y (T0)
	@@return:
	JR RA
	NOP
	
/*
GateData:
0x00 [float[3]] gate position
0x0C [float[3]] camera position
0x18 [float] scale
0x1C [short] yaw
0x1E [short] pitch
*/

@gate_data:
	; gate 1
	.word float( -1375 ), float( -2100 ), float( 0 )
	.word float( -850 ), float( -1400 ), float( 0 )
	.word float( 1 )
	.halfword 0x0000, 0x0000
	; gate 2
	.word float( 2550 ), float( 400 ), float( 2550 )
	.word float( 4000 ), float( 1100 ), float( 2550 )
	.word float( 2 )
	.halfword 0x0000, 0x0000
	; gate 3
	.word float( 0 ), float( 1470 ), float( -200 )
	.word float( 0 ), float( 1950 ), float( -1200 )
	.word float( 1 )
	.halfword 0x4000, 0x4000

@switch_init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LW T0, g_current_obj_ptr
	LI T1, @switch_flags
	LBU AT, o_arg0 (T0)
	SLL AT, AT, 2
	ADDU T1, T1, AT
	
	LW T2, (global_vars + gv_env_flags)
	LW AT, 0x0 (T1)
	AND AT, AT, T2
	BEQ AT, R0, @@endif_pressed
		SETU AT, 2
		SW AT, o_state (T0)
		LUI AT, 0x3E80
		B @@return
		SW AT, o_scale_y (T0)
	@@endif_pressed:
	
	SW T1, 0x10 (SP)
	LI A2, @beh_gate
	SETU A1, 49
	JAL spawn_object
	MOVE A0, T0
	
	LW T0, g_current_obj_ptr
	SW V0, 0xF4 (T0)
	
	LBU T2, o_arg0 (T0)
	SB T2, o_arg0 (V0)
	
	LI T1, @gate_data
	SLL AT, T2, 5
	ADDU T0, T1, AT
	
	MOVE A0, T0
	JAL copy_vector
	ADDIU A1, V0, o_position
	
	LH AT, 0x1C (T0)
	SW AT, o_face_angle_yaw (V0)
	
	LH AT, 0x1E (T0)
	SW AT, o_face_angle_roll (V0)
	
	MOVE A0, V0
	JAL scale_object
	LW A1, 0x18 (T0)
	
	JAL save_game
	NOP
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@switch_flags:
.word FLAG_WATER_GATE_1
.word FLAG_WATER_GATE_2
.word FLAG_WATER_GATE_3

@switch_loop:
	LW T0, g_current_obj_ptr
	LW T0, o_state (T0)
	LI T1, @action_table
	SLL AT, T0, 2
	ADDU AT, T1, AT
	LW AT, 0x0 (AT)
	JR AT
	NOP
	
@action_table:
.word @action_unpressed
.word @action_pressing
.word @action_pressed

@action_unpressed:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LW A0, g_current_obj_ptr
	LW A1, g_mario_obj_ptr
	LW T0, 0x214 (A1)
	BNE T0, A0, @@return
	NOP
		JAL get_dist_2d
		NOP
		LI.S F4, 127.5
		C.LT.S F0, F4
		LW T0, g_current_obj_ptr
		BC1F @@return
		SETU AT, 1
		SW AT, o_state (T0)
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_pressing:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI A2, float( 1.5 )
	LI A3, float( 0.2 )
	SETU A0, 2
	JAL 0x802A3B40
	SETU A1, 3
	
	LW T0, g_current_obj_ptr
	LW AT, o_timer (T0)
	SLTIU AT, AT, 3
	BNE AT, R0, @@return
	
	SETU AT, 2
	SW AT, o_state (T0)
	
	LHU AT, o_active_flags (T0)
	ORI AT, AT, AF_ACTIVE_IN_TIMESTOP
	SH AT, o_active_flags (T0)
	
	LW T1, 0xF4 (T0)
	LHU AT, o_active_flags (T1)
	ORI AT, AT, AF_ACTIVE_IN_TIMESTOP
	SH AT, o_active_flags (T1)
	
	SETU AT, 1
	SW AT, o_state (T1)
	
	LBU T0, o_arg0 (T0)
	SLL T0, T0, 5
	LI T1, @gate_data
	ADDU A1, T1, T0
	
	ADDIU A0, A1, 0xC
	JAL play_basic_cutscene
	SETU A2, 45
	
	LUI A0, 0x803E
	JAL play_sound
	ORI A0, A0, 0xC081
	
	JAL shake_screen
	SETU A0, 1
	
	LW T0, g_current_obj_ptr
	LBU T2, o_arg0 (T0)
	LI T1, @switch_flags
	SLL AT, T2, 2
	ADDU T1, T1, AT
	LW T1, 0x0 (T1)
	LI T3, global_vars
	LW AT, gv_env_flags (T3)
	OR AT, AT, T1
	JAL save_game
	SW AT, gv_env_flags (T3)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@action_pressed:
	JR RA
	NOP
