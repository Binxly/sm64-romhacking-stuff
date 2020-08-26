beh_final_boss_trigger_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_EXEC @reset_barrier
BHV_EXEC @talisman_check
BHV_LOOP_BEGIN
	BHV_EXEC @trigger_loop
BHV_LOOP_END

.definelabel @beh_cutscene_script, (org() - 0x80000000)
BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_EXEC @activate_talismans
BHV_SLEEP 50
BHV_EXEC @flash_start
BHV_SLEEP 10
BHV_EXEC @flash_end
BHV_SLEEP 25
BHV_EXEC @ride_warp_star
BHV_DELETE
BHV_END

.definelabel @beh_orb, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_BILLBOARD
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_speed_h, 15
BHV_ADD_FLOAT o_y, 100
BHV_EXEC decompose_speed
BHV_REPEAT_BEGIN 30
	BHV_EXEC move_simple
BHV_REPEAT_END
BHV_EXEC @target_barrier
BHV_REPEAT_BEGIN 30
	BHV_EXEC move_simple
BHV_REPEAT_END
BHV_DELETE
BHV_END

@reset_barrier:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI.U A0, bb_level_6_area_3_Barrier_opacity_byte
	JAL segmented_to_virtual
	LI.L A0, bb_level_6_area_3_Barrier_opacity_byte
	
	SETU AT, 0x7F
	SB AT, 0x0 (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@talisman_check:
	LBU T0, (global_vars + gv_talismans)
	SETU AT, TALISMAN_ALL
	AND T0, T0, AT
	BEQ T0, AT, @@okay
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@okay:
	JR RA
	NOP

@trigger_loop:
	LI.S F5, -7800
	L.S F4, (g_mario + m_x)
	C.LE.S F4, F5
	LW A0, g_current_obj_ptr
	BC1F @@endif_triggered
		MOVE A1, R0
		LI A2, @beh_cutscene_script
		J spawn_object
		SH R0, o_active_flags (A0)
	@@endif_triggered:
	JR RA
	NOP
	
@activate_talismans:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)
	
	MOVE S0, R0
	@@loop:
		LW A0, g_mario_obj_ptr
		LI A2, @beh_orb
		LI T0, @orb_models
		ADDU T0, T0, S0
		JAL spawn_object
		LBU A1, 0x0 (T0)
		
		SETU AT, 0x3333
		MULTU AT, S0
		SW R0, o_face_angle_yaw (V0)
		MFLO AT
		SW R0, o_face_angle_pitch (V0)
		SW AT, o_move_angle_yaw (V0)
		
		ADDIU S0, S0, 1
		SLTIU AT, S0, 5
		BNE AT, R0, @@loop
		SW R0, o_face_angle_roll (V0)
	
	LUI A0, 0x3D0E
	JAL play_sound
	ORI A0, A0, 0xFF81
	
	LW S0, 0x10 (SP)
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@flash_start:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	SETU A0, 1
	SETU A1, 10
	SETU A2, 0xFF
	SETU A3, 0xFF
	JAL play_transition
	SW A2, 0x10 (SP)
	
	LI A0, 0x302F8D81
	LW A1, g_mario_obj_ptr
	JAL set_sound
	ADDIU A1, A1, 0x54
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@flash_end:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	SETU A0, 0
	SETU A1, 10
	SETU A2, 0xFF
	SETU A3, 0xFF
	JAL play_transition
	SW A2, 0x10 (SP)
	
	LI.U A0, bb_level_6_area_3_Barrier_opacity_byte
	JAL segmented_to_virtual
	LI.L A0, bb_level_6_area_3_Barrier_opacity_byte
	
	JAL save_game
	SB R0, 0x0 (V0)

	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@ride_warp_star:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_mario_obj_ptr
	LI A2, beh_warp_star_coloured
	JAL spawn_object
	SETU A1, 49
	
	LI T0, ((WARP_BOWSER << 24) | (0x22 << 16) | (1 << 8) | 10)
	SW T0, o_arg0 (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@target_barrier:
	ADDIU SP, SP, 0xFFE0
	SW RA, 0x1C (SP)
	
	LI T0, float( -12000 )
	SW T0, 0x10 (SP)
	LI T0, float( 2260 )
	SW T0, 0x14 (SP)
	LI T0, float( 2575 )
	SW T0, 0x18 (SP)
	
	LW T0, g_current_obj_ptr
	ADDIU A0, SP, 0x10
	ADDIU A1, T0, o_position
	JAL subtract_vectors_3d
	MOVE A2, A0
	
	JAL get_vector_magnitude
	ADDIU A0, SP, 0x10
	
	LI.S F12, 0.025
	ADDIU A0, SP, 0x10
	JAL scale_vector_3d
	MOVE A1, A0
	
	LW T0, g_current_obj_ptr
	ADDIU A0, SP, 0x10
	JAL copy_vector
	ADDIU A1, T0, o_speed
	
	LUI A0, 0x3D57
	JAL play_sound
	ORI A0, A0, 0xFF81
	
	LW RA, 0x1C (SP)
	JR RA
	ADDIU SP, SP, 0x20
	
@orb_models:
.byte 50, 51, 52, 81, 82
.align 4
NOP

