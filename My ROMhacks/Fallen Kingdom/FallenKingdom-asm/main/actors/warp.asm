beh_warp_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_AUTO_FACE_FORWARDS_HORIZONTAL
BHV_SET_INTERACTION INT_WARP
BHV_SET_INT o_intangibility_timer, 0
BHV_EXEC @set_hitbox
BHV_LOOP_BEGIN
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

@set_hitbox:
	LW T0, g_current_obj_ptr
	LI.S F6, 10
	LBU AT, o_arg0 (T0)
	MTC1 AT, F4
	LBU AT, o_arg2 (T0)
	MTC1 AT, F5
	CVT.S.W F4, F4
	CVT.S.W F5, F5
	MUL.S F4, F4, F6
	MUL.S F5, F5, F6
	S.S F4, o_hitbox_radius (T0)
	JR RA
	S.S F5, o_hitbox_height (T0)
