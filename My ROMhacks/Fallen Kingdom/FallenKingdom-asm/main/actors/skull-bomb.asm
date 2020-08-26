beh_skull_bomb_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_BILLBOARD
BHV_SET_FLOAT o_render_distance, 8196
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_HITBOX 100, 200, 100
BHV_SET_INT o_collision_damage, 2
BHV_SET_INT o_intangibility_timer, 0
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@loop:
	LW A0, g_current_obj_ptr
	LW AT, o_interaction_status (A0)
	BEQ AT, R0, @@return
	LI A2, beh_explosion
	SETU A1, 0xCD
	J spawn_object
	SH R0, o_active_flags (A0)
	@@return:
	JR RA
	NOP
