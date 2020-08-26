beh_torii_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_COLLISION bb_level_23_object_Torii__Solid__collision
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 10000
BHV_SET_FLOAT o_collision_distance, 1550
BHV_EXEC @reset_opacity
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC process_collision
BHV_LOOP_END

@reset_opacity:
	J @set_opacity
	MOVE A0, R0
	
@loop:
	LW T0, g_current_obj_ptr
	
	LW T1, o_state (T0)
	BNE T1, R0, @@endif_far_away
		LI.S F5, 2048
		L.S F4, o_distance_to_mario (T0)
		C.LE.S F4, F5
		NOP
		BC1F @@return
		SETU AT, 1
		B @@return
		SW AT, o_state (T0)
	@@endif_far_away:
	
	SETU AT, 1
	BNE T1, AT, @@endif_fading_in
		LW T1, o_timer (T0)
		SLTIU AT, T1, 32
		BNE AT, R0, @@endif_done_fadein
			SETU AT, 2
			SW AT, o_state (T0)
			J 0x802A04C0
			SETU A0, 40
		@@endif_done_fadein:
		
		J @set_opacity
		SLL A0, T1, 3
	@@endif_fading_in:
	
	@@return:
	JR RA
	NOP

@set_opacity:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW A0, 0x10 (SP)
	
	LI.U A0, bb_level_23_object_Torii__Fade_In__Sign_opacity_byte
	JAL segmented_to_virtual
	LI.L A0, bb_level_23_object_Torii__Fade_In__Sign_opacity_byte
	
	LW A0, 0x10 (SP)
	SB A0, 0x0 (V0)
	
	LI.U A0, bb_level_23_object_Torii__Fade_In__Torii_opacity_byte
	JAL segmented_to_virtual
	LI.L A0, bb_level_23_object_Torii__Fade_In__Torii_opacity_byte
	
	LW A0, 0x10 (SP)
	SB A0, 0x0 (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
