beh_tree_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_INTERACTION INT_SOLID
BHV_SET_HITBOX 50, 1500, 0
BHV_DROP_TO_FLOOR
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_INT o_intangibility_timer, 0
BHV_LOOP_BEGIN
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END
