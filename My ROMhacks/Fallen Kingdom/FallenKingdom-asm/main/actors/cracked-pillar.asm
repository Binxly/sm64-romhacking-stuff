beh_cracked_pillar_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO | OBJ_ALWAYS_ACTIVE
BHV_SET_COLLISION bb_level_8_object_Cracked_Pillar_collision
BHV_SET_INTERACTION 0
BHV_SET_HITBOX 250, 400, 200
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_collision_distance, 2048
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INT o_num_loot_coins, 0
BHV_EXEC @check_flags
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC process_collision
BHV_LOOP_END

@check_flags:
	LHU T0, (global_vars + gv_shrooms)
	ANDI T0, T0, SHROOM_MINES_1
	BEQ T0, R0, @@return
		LW T0, g_current_obj_ptr
		J @spawn_shroom
		SH R0, o_active_flags (T0)
	@@return:
	JR RA
	NOP
	
@loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LI.U A1, beh_explosion
	JAL colliding_with_type
	LI.L A1, beh_explosion
	
	BEQ V0, R0, @@return
	
	SETU A0, 30
	SETU A1, 138
	LUI A2, 0x4040
	JAL 0x802AE0CC
	SETU A3, 4
	
	LUI A0, 0x300C
	JAL create_sound_spawner
	ORI A0, A0, 0x8081
	
	LW T0, g_current_obj_ptr
	JAL @spawn_shroom
	SH R0, o_active_flags (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@spawn_shroom:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LI A2, beh_golden_shroom
	JAL spawn_object
	SETU A1, 0xD4
	
	SETU AT, SHROOM_MINES_1
	SH AT, o_arg0 (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
