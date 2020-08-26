beh_grotto_hole_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_COLLISION bb_level_6_object_Grotto_Entrance_collision
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_collision_distance, 300
BHV_SET_INT o_intangibility_timer, 0
BHV_EXEC @init
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@init:
	LHU T0, (global_vars + gv_shrooms)
	ANDI T0, T0, SHROOM_PLAINS_GROTTO
	BEQ T0, R0, @@return
	LW T0, g_current_obj_ptr
	SH R0, o_active_flags (T0)
	@@return:
	JR RA
	NOP
	
@loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LI.U A0, beh_explosion
	JAL get_nearest_object_with_behaviour
	LI.L A0, beh_explosion
	
	BEQ V0, R0, @@return
	LW A0, g_current_obj_ptr
	JAL get_dist_3d
	MOVE A1, V0
	
	LI.S F4, 600
	NOP
	C.LE.S F0, F4
	LW.U T0, g_current_obj_ptr
	BC1F @@return
	LW.L T0, g_current_obj_ptr
	
	JAL 0x803220F0
	SH R0, o_active_flags (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	J process_collision
	ADDIU SP, SP, 0x18
	
