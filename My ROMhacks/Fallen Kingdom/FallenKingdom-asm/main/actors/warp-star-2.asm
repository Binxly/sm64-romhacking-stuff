beh_warp_star_coloured_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_INTERACTION INT_COIN
BHV_SET_INT o_collision_damage, 0
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_HITBOX 95, 190, 0
BHV_EXEC @check_warp_available
BHV_SET_RANDOM_SHORT o_face_angle_yaw, 0, 0
BHV_LOOP_BEGIN
	BHV_ADD_INT o_face_angle_yaw, 0x100
	BHV_EXEC @loop
BHV_LOOP_END

.definelabel @warp_star_rising, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE | OBJ_AUTO_MOVE_Y
BHV_REPEAT_BEGIN 30
	BHV_ADD_FLOAT o_speed_y, 4
	BHV_EXEC @update_mario_gfx
BHV_REPEAT_END
BHV_EXEC @warp
BHV_DELETE
BHV_END

@warp_display_flags:
.word 0

@check_warp_available:
	LW T0, g_current_obj_ptr
	LBU T1, (global_vars + gv_warps)
	LBU AT, o_arg0 (T0)
	ORI T1, T1, WARP_BOWSER
	AND T1, T1, AT
	BNE T1, R0, @@return
	NOP
		SH R0, o_active_flags (T0)
	@@return:
	JR RA
	NOP

@loop:
	LW T0, g_current_obj_ptr
	
	LW AT, o_interaction_status (T0)
	BNE AT, R0, @spawn_rising_star
	MOVE A0, T0
	
	LI.S F5, 1000
	L.S F4, o_distance_to_mario (T0)
	C.LE.S F4, F5
	LW T1, @warp_display_flags
	BC1F @@endif_close
	LBU T2, o_arg0 (T0)
		B @@update_flags
		OR T1, T1, T2
	@@endif_close:
		SETU AT, 0xFFFF
		SUBU T2, AT, T2
		AND T1, T1, T2
	@@update_flags:
	SW.U T1, @warp_display_flags
	JR RA
	SW.L T1, @warp_display_flags
	
@spawn_rising_star:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW A0, 0x10 (SP)
	
	LI A2, @warp_star_rising
	JAL spawn_object
	MOVE A1, R0
	
	LW T0, 0x10 (SP)
	LW AT, o_arg0 (T0)
	SW AT, o_arg0 (V0)
	LW AT, 0x14 (T0)
	SW AT, 0x14 (V0)
	SH R0, o_active_flags (T0)
	
	LI A0, g_mario
	LH AT, m_angle_yaw (A0)
	SW AT, o_face_angle_yaw (V0)
	
	LI A1, ACT_NOP
	JAL set_mario_action
	MOVE A2, R0
	
	LI A0, g_mario
	JAL set_mario_animation
	SETU A1, 0x33
	
	LUI A0, 0x701E
	JAL play_sound
	ORI A0, A0, 0xFF81
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@update_mario_gfx:
	LW T0, g_current_obj_ptr
	LI.S F5, 120
	L.S F4, o_y (T0)
	ADD.S F4, F4, F5
	LW T1, g_mario_obj_ptr
	S.S F4, o_gfx_y (T1)
	LW AT, o_x (T0)
	SW AT, o_gfx_x (T1)
	LW AT, o_z (T0)
	JR RA
	SW AT, o_gfx_z (T1)

@warp:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LI A0, g_mario
	LI A1, 0x00001300
	JAL set_mario_action
	MOVE A2, R0
	
	LW T0, g_current_obj_ptr
	LBU A0, o_arg1 (T0)
	LBU A1, o_arg2 (T0)
	LBU A2, o_arg3 (T0)
	JAL 0x8024A700
	MOVE A3, R0
	
	MOVE A0, R0
	JAL 0x802497B8
	MOVE A1, R0
	
	LUI T0, 0x8034
	SH R0, 0xBACC (T0)
	LHU AT, 0xC848 (T0)
	ANDI AT, AT, 0x7FFF
	SH AT, 0xC848 (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
render_warp_destination:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LHU T0, g_level_num
	SETU AT, 0x10
	BEQ T0, AT, @@endif_not_star_road
		SW.U R0, @warp_display_flags
		B @@return
		SW.L R0, @warp_display_flags
	@@endif_not_star_road:
	
	LW T0, @warp_display_flags
	BEQ T0, R0, @@return
	
	SETU AT, WARP_BOWSER
	BEQ T0, AT, @@return
	
	SETU AT, WARP_CHASM
	BNE T0, AT, @@endif_w1
		LI.U A2, @txt_chasm
		B @@render_text
		LI.L A2, @txt_chasm
	@@endif_w1:
	
	SETU AT, WARP_TOWN
	BNE T0, AT, @@endif_w2
		LW T1, (global_vars + gv_env_flags)
		ANDI AT, T1, FLAG_VTEXT_TOWN
		BNE AT, R0, @@endif_first_visit
			LI.U A2, @txt_town_1
			B @@render_text
			LI.L A2, @txt_town_1
		@@endif_first_visit:
		LI.U A2, @txt_town_2
		B @@render_text
		LI.L A2, @txt_town_2
	@@endif_w2:
	
	SETU AT, WARP_SUNKEN_TEMPLE
	BNE T0, AT, @@endif_w3
		LI.U A2, @txt_water
		B @@render_text
		LI.L A2, @txt_water
	@@endif_w3:
	
	SETU AT, WARP_MOUNTAIN
	BNE T0, AT, @@endif_w4
		LI.U A2, @txt_mines
		B @@render_text
		LI.L A2, @txt_mines
	@@endif_w4:
	
	LI A2, @txt_forest
	
	@@render_text:
	SW A2, 0x10 (SP)
	
	LUI A0, 0xFFFF
	JAL begin_print_encoded_text
	ORI A0, A0, 0xFFFF
	
	LW A2, 0x10 (SP)
	LBU A0, 0xFFFF (A2)
	JAL print_encoded_text
	SETU A1, 200
	
	JAL end_print_encoded_text
	NOP

	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

.byte 113
@txt_chasm:
.string "Chasm of Lost Hope"

.byte 136
@txt_town_1:
.string "Toad Town"

.byte 121
@txt_town_2:
.string "Toad Town Ruins"

.byte 125
@txt_water:
.string "Flooded Temple"

.byte 128
@txt_mines:
.string "Tal Tal Mines"

.byte 95
@txt_forest:
.string "Bamboo Forest of the Lost"

.align 4
