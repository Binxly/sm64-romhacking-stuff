beh_sand_block_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_COLLISION bb_level_4_object_Sand_Block_collision
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_collision_distance, 454
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC process_collision
BHV_LOOP_END

@loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LW T1, o_state (T0)
	
	BNE T1, R0, @@endif_idle
		LW T2, g_mario_obj_ptr
		LW AT, 0x214 (T2)
		BNE T0, AT, @@return
		LW T2, (g_mario + m_action)
		ANDI AT, T2, 0x800
		BNE AT, R0, @@return
		SETU AT, 1
		B @@return
		SW AT, o_state (T0)
	@@endif_idle:
	
	SETU AT, 1
	BNE T1, AT, @@endif_shrinking
		LI.S F5, 0.01
		MTC1 R0, F6
		L.S F4, o_scale_y (T0)
		SUB.S F4, F4, F5
		C.LE.S F4, F6
		S.S F4, o_scale_y (T0)
		BC1F @@endif_gone
			LHU AT, o_gfx_flags (T0)
			ORI AT, AT, 0x10
			SH AT, o_gfx_flags (T0)
			SW R0, o_collision_distance (T0)
			SETU AT, 2
			B @@return
			SW AT, o_state (T0)
		@@endif_gone:
		; todo: spawn particles
		LUI A0, 0x400E
		JAL play_sound
		ORI A0, A0, 0x0001
		B @@return
		NOP
	@@endif_shrinking:
	
	LW AT, o_timer (T0)
	SLTIU AT, AT, 150
	BNE AT, R0, @@return
		LI T1, float( 1 )
		SW T1, o_scale_y (T0)
		LI T1, float( 454 )
		SW T1, o_collision_distance (T0)
		LHU AT, o_gfx_flags (T0)
		ANDI AT, AT, 0xFFEF
		SH AT, o_gfx_flags (T0)
		B @@return
		SW R0, o_state (T0)
		
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
