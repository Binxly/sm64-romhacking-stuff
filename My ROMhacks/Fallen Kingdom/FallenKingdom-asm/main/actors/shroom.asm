.include "./shroom-model.asm"

@collected_shroom_type:
.halfword 0
@shroom_dialog_id:
.halfword 0

beh_super_shroom_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_SET_INT o_animation_state, 0
BHV_SET_INT o_collision_damage, 2
BHV_JUMP @beh_healing_shroom


beh_ultra_shroom_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_SET_INT o_animation_state, 1
BHV_SET_INT o_collision_damage, 24
BHV_JUMP @beh_healing_shroom

beh_golden_shroom_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_MODEL 0xD4
BHV_SET_INT o_animation_state, 2
BHV_SET_HITBOX 100, 200, 0
BHV_SET_INTERACTION INT_STAR_OR_KEY
BHV_SET_INT o_interaction_arg, IA_NO_EXIT
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_INT o_intangibility_timer, 0
BHV_EXEC @golden_shroom_init
BHV_LOOP_BEGIN
	BHV_ADD_INT o_face_angle_yaw, 0x100
	BHV_EXEC @sparkle
	BHV_EXEC @golden_shroom_loop
BHV_LOOP_END

beh_life_shroom_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_MODEL 0xD4
BHV_SET_INT o_animation_state, 3
BHV_SET_HITBOX 100, 200, 0
BHV_SET_INTERACTION INT_STAR_OR_KEY
BHV_SET_INT o_interaction_arg, IA_NO_EXIT
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_INT o_intangibility_timer, 0
BHV_EXEC @life_shroom_init
BHV_LOOP_BEGIN
	BHV_ADD_INT o_face_angle_yaw, 0x100
	BHV_EXEC @sparkle
	BHV_EXEC @life_shroom_loop
BHV_LOOP_END

.definelabel @beh_healing_shroom, (org() - 0x80000000)
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_AUTO_MOVE_Y
BHV_SET_MODEL 0xD4
BHV_SET_HITBOX 100, 200, 0
BHV_SET_INTERACTION INT_COIN
BHV_SET_FLOAT o_render_distance, 4000
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_speed_y, 25
BHV_LOOP_BEGIN
	BHV_ADD_INT o_face_angle_yaw, 0x100
	BHV_ADD_FLOAT o_speed_y, -3
	BHV_EXEC obj_update_floor
	BHV_EXEC @healing_shroom_loop
BHV_LOOP_END


@healing_shroom_loop:
	LW T0, g_current_obj_ptr
	LBU AT, o_arg3 (T0)
	BNE AT, R0, @@stop_falling
	LW T1, o_interaction_status (T0)
	L.S F4, o_y (T0)
	L.S F5, o_floor_height (T0)
	C.LE.S F4, F5
	NOP
	BC1F @@endif_below_floor
	ANDI T1, T1, 0x8000
		S.S F5, o_y (T0)
		@@stop_falling:
		SW R0, o_speed_y (T0)
	@@endif_below_floor:
	BEQ T1, R0, @@return
	SW R0, o_interaction_status (T0)
		SH R0, o_active_flags (T0)
		LI A0, 0x30587F81
		LW A1, g_mario_obj_ptr
		J set_sound
		ADDIU A1, A1, 0x54
	@@return:
	JR RA
	NOP
	
@golden_shroom_init:
	LW A0, g_current_obj_ptr
	LHU T0, (global_vars + gv_shrooms)
	LHU AT, o_arg0 (A0)
	AND AT, T0, AT
	BEQ AT, R0, @@return
	NOP
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		SH R0, o_active_flags (A0)
		LI A2, beh_ultra_shroom
		JAL spawn_object
		SETU A1, 0xD4
		SETU AT, 1
		SB AT, o_arg3 (V0)
		LW RA, 0x14 (SP)
		ADDIU SP, SP, 0x18
	@@return:
	JR RA
	NOP
	
@life_shroom_init:
	LW A0, g_current_obj_ptr
	LW T0, (global_vars + gv_env_flags)
	LW AT, o_arg0 (A0)
	AND AT, T0, AT
	BEQ AT, R0, @@return
	NOP
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		SH R0, o_active_flags (A0)
		LI A2, beh_ultra_shroom
		JAL spawn_object
		SETU A1, 0xD4
		SETU AT, 1
		SW AT, o_arg0 (V0)
		LW RA, 0x14 (SP)
		ADDIU SP, SP, 0x18
	@@return:
	JR RA
	NOP

collect_shroom_shim:
	LI T0, g_mario
	SW R0, m_speed_x (T0)
	SW R0, m_speed_z (T0)
	SW R0, m_speed_h (T0)
	LI T0, (beh_life_shroom+0x80000000)
	LW AT, o_behaviour (A0)
	BNE T0, AT, @@else_if_golden_shroom
		SETU T0, 3
		SH T0, @collected_shroom_type
		SETU T0, 6
		SH T0, @shroom_dialog_id
		B @@endif_life_shroom
		NOP
	@@else_if_golden_shroom:
		SETU T0, 2
		SH T0, @collected_shroom_type
		SETU T0, 3
		SH T0, @shroom_dialog_id
	@@endif_life_shroom:
	J spawn_object
	NOP
	
shroom_trophy_init:
	LW T0, g_current_obj_ptr
	LHU T1, @collected_shroom_type
	J 0x802ECFAC
	SW T1, o_animation_state (T0)
	
shroom_dialog_shim:
	LHU.U A0, @shroom_dialog_id
	J 0x802D8D48
	LHU.L A0, @shroom_dialog_id
	
shroom_dance_done_shim:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, (g_mario + m_area)
	LHU A1, 0x38 (T0)
	MOVE A0, R0
	JAL set_music
	MOVE A2, R0
	
	JAL reset_camera
	NOP
	
	LW RA, 0x14 (SP)
	J 0x80248DC0
	ADDIU SP, SP, 0x18

@golden_shroom_loop:
	LW T0, g_current_obj_ptr
	LW AT, o_interaction_status (T0)
	BEQ AT, R0, @@return
	LI T1, global_vars
		SH R0, o_active_flags (T0)
		LHU T2, gv_shrooms (T1)
		LHU AT, o_arg0 (T0)
		OR T2, T2, AT
		SH T2, gv_shrooms (T1)
		SETU T2, 48
		SB T2, (g_mario + m_heal_counter)
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		LHU A0, gv_max_health (T1)
		JAL set_max_health
		ADDIU A0, A0, 0x100
		LI T0, bbp_8e976b2074834d4d9e4cc902cef39f90_MAX_AIR
		SW T0, bbp_8e976b2074834d4d9e4cc902cef39f90_mario_air
		LW RA, 0x14 (SP)
		J save_game
		ADDIU SP, SP, 0x18
	@@return:
	JR RA
	NOP
	
@life_shroom_loop:
	LW T0, g_current_obj_ptr
	LW AT, o_interaction_status (T0)
	BEQ AT, R0, @@return
	LI T1, global_vars
		SH R0, o_active_flags (T0)
		LW T2, gv_env_flags (T1)
		LW AT, o_arg0 (T0)
		OR T2, T2, AT
		SW T2, gv_env_flags (T1)
		SETU T2, 48
		SB T2, (g_mario + m_heal_counter)
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		LHU A0, gv_max_health (T1)
		JAL set_max_health
		ADDIU A0, A0, 0x200
		LW RA, 0x14 (SP)
		J save_game
		ADDIU SP, SP, 0x18
	@@return:
	JR RA
	NOP
	
@sparkle:
	LW A0, g_current_obj_ptr
	LW AT, o_timer (A0)
	ANDI AT, AT, 0x4
	BEQ AT, R0, @@return
	LI A2, 0x13002AF0
	J spawn_object
	SETU A1, 0x8F
	@@return:
	JR RA
	NOP
