beh_water_mine_impl:
; BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_HITBOX 100, 200, 100
BHV_SET_INT o_collision_damage, 2
BHV_SET_FLOAT o_render_distance, 4500
BHV_EXEC @spawn_chain
BHV_LOOP_BEGIN
	BHV_EXEC @mine_loop
BHV_LOOP_END

.definelabel @beh_chain, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_FLOAT o_render_distance, 4500
BHV_LOOP_BEGIN
	BHV_EXEC horizontally_billboard
BHV_LOOP_END

@spawn_chain:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LI A2, @beh_chain
	JAL spawn_object
	SETU A1, 52
	
	LW T0, g_current_obj_ptr
	SW V0, 0xF4 (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@mine_loop:
	LW T0, g_current_obj_ptr
	LW AT, o_interaction_status (T0)
	BEQ AT, R0, @@return
	
	LW AT, 0xF4 (T0)
	SH R0, o_active_flags (AT)
	SH R0, o_active_flags (T0)
	
	LI A2, beh_explosion
	MOVE A0, T0
	J spawn_object
	SETU A1, 0xCD
	
	@@return:
	JR RA
	NOP
