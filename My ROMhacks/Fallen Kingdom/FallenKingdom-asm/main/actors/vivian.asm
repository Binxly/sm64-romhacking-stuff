; bp1 = trigger index
; bp2 = radius (r = 100*bp2 + 50)
; bp3 = height (h = 100*bp3)
; bp4 = activation delay

beh_vivian_trigger_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_EXEC @init_props
BHV_EXEC @check_active
BHV_EXEC @set_delay
BHV_SLEEP_VAR 0x108
BHV_LOOP_BEGIN
	BHV_EXEC @trigger_loop
BHV_LOOP_END

beh_sequence_break_trigger_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_SET_WORD o_arg0, ((21 << 24) | (3 << 16) | (11 << 8))
BHV_EXEC @init_props
BHV_EXEC @check_active
BHV_LOOP_BEGIN
	BHV_EXEC @sb_trigger_loop
BHV_LOOP_END


.definelabel beh_vivian, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_BILLBOARD
BHV_STORE_HOME
BHV_LOOP_BEGIN
	BHV_EXEC @vivian_loop
BHV_LOOP_END

@_flag equ 0xF4
@_dialog equ 0xF8
@_radius equ 0xFC
@_height equ 0x100
@_condition equ 0x104
@_delay equ 0x108

@set_delay:
	LW T0, g_current_obj_ptr
	LBU AT, o_arg3 (T0)
	ADDIU AT, AT, 1
	JR RA
	SW AT, @_delay (T0)

@init_props:
	LW T0, g_current_obj_ptr
	LI T1, @trigger_info
	
	LBU AT, o_arg1 (T0)
	MTC1 AT, F4
	LBU AT, o_arg2 (T0)
	MTC1 AT, F5
	LI.S F6, 100
	LI.S F7, 50
	CVT.S.W F4, F4
	CVT.S.W F5, F5
	MUL.S F4, F4, F6
	MUL.S F5, F5, F6
	ADD.S F4, F4, F7
	S.S F4, @_radius (T0)
	S.S F5, @_height (T0)
	
	LBU AT, o_arg0 (T0)
	SLL AT, AT, 4
	ADDU T1, T1, AT
	
	LW AT, 0x0 (T1)
	SW AT, @_flag (T0)
	LW AT, 0x4 (T1)
	SW AT, @_condition (T0)
	LW AT, 0x8 (T1)
	SW AT, @_dialog (T0)
	
	JR RA
	NOP
	
@check_active:
	LW T0, g_current_obj_ptr
	LW T1, (global_vars + gv_env_flags)
	
	LW AT, @_flag (T0)
	AND AT, AT, T1
	BNE AT, R0, @@despawn
	
	LW T1, @_condition (T0)
	JR T1
	MOVE A0, T0

	@@despawn:
	JR RA
	SH R0, o_active_flags (T0)
	
@trigger_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LW.U A1, g_mario_obj_ptr
	JAL get_dist_2d
	LW.L A1, g_mario_obj_ptr
	
	LW T0, g_current_obj_ptr
	L.S F4, @_radius (T0)
	C.LE.S F0, F4
	L.S F5, @_height (T0)
	BC1F @@return
	L.S F4, o_y (T0)
	L.S F6, (g_mario + m_y)
	ADD.S F5, F4, F5
	C.LT.S F5, F6
	LI.S F5, 160
	BC1T @@return
	SUB.S F4, F4, F5
	C.LE.S F4, F6
	MOVE A2, R0
	BC1F @@return
	MOVE A0, T0
	JAL spawn_vivian
	LW A1, @_dialog (T0)
	
	LW T0, g_current_obj_ptr
	LW AT, @_flag (T0)
	SW AT, @_flag (V0)
	
	SH R0, o_active_flags (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@sb_trigger_loop:
	LBU T0, (global_vars + gv_items)
	ANDI T0, T0, ITEM_BOOTS
	BEQ T0, R0, @@endif_has_boots
		LW T0, g_current_obj_ptr
		B @@return
		SH R0, o_active_flags (T0)
	@@endif_has_boots:
	
	LW T0, (g_mario + m_action)
	ANDI T0, T0, 0x2000
	BNE T0, R0, @@return
	NOP
		J @trigger_loop
		NOP
	@@return:
	JR RA
	NOP
	
@vivian_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)
	
	LW S0, g_current_obj_ptr

	LW AT, o_state (S0)
	BNE AT, R0, @@endif_waiting
	LI T0, g_mario
		LW AT, m_x (T0)
		SW AT, o_x (S0)
		LW AT, m_z (T0)
		JAL 0x802575A8
		SW AT, o_z (S0)
		BEQ V0, R0, @@return
		LUI A0, 0x700A
		JAL play_sound
		ORI A0, A0, 0x8081
		SETU AT, 1
		JAL obj_angle_to_home
		SW AT, o_state (S0)
		JAL angle_to_unit_vector
		MOVE A0, V0
		SW R0, o_scale_y (S0)
		LI.S F4, 250
		LHU AT, o_gfx_flags (S0)
		ANDI AT, AT, 0xFFEF
		SH AT, o_gfx_flags (S0)
		LI T0, g_mario
		MUL.S F0, F0, F4
		MUL.S F1, F1, F4
		L.S F5, m_x (T0)
		L.S F6, m_z (T0)
		ADD.S F5, F5, F0
		ADD.S F6, F6, F1
		S.S F5, o_x (S0)
		S.S F6, o_z (S0)
		L.S F5, m_y (T0)
		LI.S F4, 200
		ADD.S F4, F4, F5
		S.S F4, o_y (S0)
		JAL 0x80381470
		MOVE A0, S0
		B @@return
		S.S F0, o_y (S0)
	@@endif_waiting:
	
	LW T0, o_state (S0)
	SETU AT, 3
	BNE T0, AT, @@endif_disappearing
		LW AT, o_timer (S0)
		SLTIU AT, 10
		BEQ AT, R0, @@endif_scale_down
			L.S F4, o_timer (S0)
			LI.S F5, 10
			CVT.S.W F4, F4
			SUB.S F4, F5, F4
			DIV.S F4, F4, F5
			B @@return
			S.S F4, o_scale_y (S0)
		@@endif_scale_down:
		B @@return
		SH R0, o_active_flags (S0)
	@@endif_disappearing:
	
	SETU A0, 2
	SETU A1, 1
	SETU A2, 0xA2
	JAL obj_show_dialog
	LW A3, @_dialog (S0)
	
	BEQ V0, R0, @@endif_dialog_finished
		SETU AT, 3
		SW AT, o_state (S0)
		LI T0, global_vars
		LW T1, gv_env_flags (T0)
		LW AT, @_flag (S0)
		BEQ AT, R0, @@saved
		OR T1, T1, AT
		JAL save_game
		SW T1, gv_env_flags (T0)
		@@saved:
		LUI A0, 0x700B
		JAL play_sound
		ORI A0, A0, 0x8081
		B @@return
		NOP
	@@endif_dialog_finished:
	
	LW T0, o_state (S0)
	SETU AT, 1
	BNE T0, AT, @@endif_appearing
		LW AT, o_timer (S0)
		SLTIU AT, 11
		BEQ AT, R0, @@endif_scale_up
			L.S F4, o_timer (S0)
			LI.S F5, 0.1
			CVT.S.W F4, F4
			MUL.S F4, F4, F5
			B @@return
			S.S F4, o_scale_y (S0)
		@@endif_scale_up:
		SETU AT, 2
		SW AT, o_state (S0)
	@@endif_appearing:
	
	@@return:
	LW S0, 0x10 (SP)
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
spawn_vivian:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW A1, 0x10 (SP)
	SW A2, 0x18 (SP)
	
	LI A2, beh_vivian
	JAL spawn_object
	SETU A1, 30
	
	SW R0, @_flag (V0)
	LW AT, 0x10 (SP)
	SW AT, @_dialog (V0)
	
	LHU AT, o_active_flags (V0)
	ORI AT, AT, AF_ACTIVE_IN_TIMESTOP
	SH AT, o_active_flags (V0)
	
	LHU AT, o_gfx_flags (V0)
	ORI AT, AT, 0x10
	SH AT, o_gfx_flags (V0)
	
	L.S F4, o_x (V0)
	L.S F5, 0x18 (SP)
	ADD.S F4, F4, F5
	S.S F4, o_x (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

/* Vivian Triggers */
@trigger_info:
	/* 0 - Story Intro */
	.word FLAG_VTEXT_INTRO
	.word @set_intro_action
	.word 27
	NOP
	/* 1 - Warp Star Room */
	.word FLAG_VTEXT_WARP_STAR 
	.word @condition_none
	.word 28
	NOP
	/* 2 - Star Road */
	.word FLAG_VTEXT_STAR_ROAD ; FIXME: softlocks on Star Road because reasons
	.word @condition_none
	.word 29
	NOP
	/* 3 - Ruined Town */
	.word FLAG_VTEXT_TOWN
	.word @condition_none
	.word 30
	NOP
	/* 4 - Directions to Sunken Temple */
	.word FLAG_VTEXT_FIELD
	.word @condition_none
	.word 31
	NOP
	/* 5 - Sunken Temple */
	.word FLAG_VTEXT_TEMPLE
	.word @condition_none
	.word 32
	NOP
	/* 6 - Pegassus Boots Required */
	.word FLAG_VTEXT_BOOTS
	.word @condition_no_boots
	.word 33
	NOP
	/* 7 - Water Talisman Acquired */
	.word FLAG_VTEXT_WATER
	.word @condition_water_talisman
	.word 34
	NOP
	/* 8 - Mines Before Boots */
	.word FLAG_VTEXT_MINES_EARLY
	.word @condition_no_boots
	.word 35
	NOP
	/* 9 - Mines 2 - Boss Fakeout */
	.word FLAG_NONE
	.word @condition_no_metal_talisman
	.word 36
	NOP
	/* 10 - Feather Required */
	.word FLAG_VTEXT_METAL_EARLY
	.word @condition_no_feather
	.word 37
	NOP
	/* 11 - Fire Talisman Acquired */
	.word FLAG_VTEXT_FIRE
	.word @condition_fire_talisman
	.word 38
	NOP
	/* 12 - Lens Required */
	.word FLAG_VTEXT_FOREST_EARLY
	.word @condition_no_lens
	.word 39
	NOP
	/* 13 - Wood Talisman Acquired */
	.word FLAG_VTEXT_WOOD
	.word @condition_wood_talisman
	.word 40
	NOP
	/* 14 - Metal Talisman Acquired */
	.word FLAG_VTEXT_METAL
	.word @condition_metal_talisman
	.word 41
	NOP
	/* 15 - Earth Talisman Acquired */
	.word FLAG_VTEXT_EARTH
	.word @condition_earth_talisman
	.word 42
	NOP
	/* 16 - All Talismans Required */
	.word FLAG_VTEXT_BARRIER_EARLY
	.word @condition_missing_talismans
	.word 43
	NOP
	/* 17 - All Talismans Acquired */
	.word FLAG_VTEXT_ALL_TALISMANS
	.word @condition_all_talismans
	.word 44
	NOP
	/* 18 - Point of No Return */
	.word FLAG_VTEXT_POINT_OF_NO_RETURN
	.word @condition_all_talismans
	.word 45
	NOP
	/* 19 - Bowser Defeated */
	.word FLAG_NONE
	.word @condition_none
	.word 51
	NOP
	/* 20 - End Game */
	.word FLAG_NONE
	.word @condition_none
	.word 52
	NOP
	/* 21 - Sequence Break */
	.word FLAG_NONE
	.word @condition_no_boots
	.word 53
	NOP
	
@set_intro_action:
	LI A0, g_mario
	LI A1, 0x00020461
	J set_mario_action
	MOVE A2, R0
	
@condition_none:
	JR RA
	NOP
	
@condition_no_boots:
	LBU T0, (global_vars + gv_items)
	ANDI T0, T0, ITEM_BOOTS
	BEQ T0, R0, @@okay
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@okay:
	JR RA
	NOP
	
@condition_no_feather:
	LBU T0, (global_vars + gv_items)
	ANDI T0, T0, ITEM_FEATHER
	BEQ T0, R0, @@okay
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@okay:
	JR RA
	NOP
	
@condition_no_lens:
	LBU T0, (global_vars + gv_items)
	ANDI T0, T0, ITEM_LENS
	BEQ T0, R0, @@okay
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@okay:
	JR RA
	NOP
	
@condition_water_talisman:
	LBU T0, (global_vars + gv_talismans)
	ANDI T0, T0, TALISMAN_WATER
	BNE T0, R0, @@okay
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@okay:
	JR RA
	NOP
	
@condition_fire_talisman:
	LBU T0, (global_vars + gv_talismans)
	ANDI T0, T0, TALISMAN_FIRE
	BNE T0, R0, @@okay
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@okay:
	JR RA
	NOP
	
@condition_wood_talisman:
	LBU T0, (global_vars + gv_talismans)
	ANDI T0, T0, TALISMAN_WOOD
	BNE T0, R0, @@okay
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@okay:
	JR RA
	NOP
	
@condition_metal_talisman:
	LBU T0, (global_vars + gv_talismans)
	ANDI T0, T0, TALISMAN_METAL
	BNE T0, R0, @@okay
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@okay:
	JR RA
	NOP
	
@condition_earth_talisman:
	LBU T0, (global_vars + gv_talismans)
	ANDI T0, T0, TALISMAN_EARTH
	BNE T0, R0, @@okay
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@okay:
	JR RA
	NOP
	
@condition_missing_talismans:
	LBU T0, (global_vars + gv_talismans)
	SETU T1, TALISMAN_ALL
	AND T0, T0, T1
	BNE T0, T1, @@okay
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@okay:
	JR RA
	NOP
	
@condition_all_talismans:
	LBU T0, (global_vars + gv_talismans)
	SETU T1, TALISMAN_ALL
	AND T0, T0, T1
	BEQ T0, T1, @@okay
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@okay:
	JR RA
	NOP

@condition_no_metal_talisman:
	LBU T0, (global_vars + gv_talismans)
	ANDI T0, T0, TALISMAN_METAL
	BEQ T0, R0, @@okay
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@okay:
	JR RA
	NOP
	
