@_pound_count equ 0xF4

beh_nail_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_COLLISION bb_level_4_object_Nail_collision
BHV_SET_FLOAT o_collision_distance, 225
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INTERACTION INT_SOLID
BHV_SET_HITBOX 50, 122, 0
BHV_SET_INT @_pound_count, 0
BHV_LOOP_BEGIN
	BHV_EXEC @nail_loop
	BHV_EXEC process_collision
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

@nail_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LW T1, o_state (T0)
	
	BNE T1, R0, @@endif_s0
	NOP
		JAL 0x802A3754
		NOP
		BEQ V0, R0, @@return
		LUI A0, 0x3065
		JAL play_sound
		ORI A0, A0, 0xC081
		LW T0, g_current_obj_ptr
		SETU T1, 1
		SW T1, o_state (T0)
		SW R0, o_timer (T0)
	@@endif_s0:
	
	SETU AT, 1
	BNE T1, AT, @@endif_s1
		LW AT, o_timer (T0)
		SLTIU AT, AT, 3
		BNE AT, R0, @@endif_done_s1
			LW AT, @_pound_count (T0)
			ADDIU AT, AT, 1
			SW AT, @_pound_count (T0)
			SLTIU AT, AT, 2
			BNE AT, R0, @@endif_despawn
				SETU AT, 3
				SH AT, o_state (T0)
				LBU AT, o_arg0 (T0)
				BEQ AT, R0, @@return
					MOVE A0, T0
					LI A2, beh_super_shroom
					JAL spawn_object
					SETU A1, 0xD4
					LI.S F5, 360
					L.S F4, o_y (V0)
					ADD.S F4, F4, F5
					S.S F4, o_y (V0)
					LI T0, float( 70 )
					B @@return
					SW T0, o_speed_y (V0)
			@@endif_despawn:
			SETU AT, 2
			B @@return
			SW AT, o_state (T0)
		@@endif_done_s1:
		LI.S F5, 23.75
		L.S F4, o_y (T0)
		SUB.S F4, F4, F5
		B @@return
		S.S F4, o_y (T0)
	@@endif_s1:
	
	SETU AT, 2
	BNE T1, AT, @@return
	NOP
		JAL 0x802A3754
		NOP
		BNE V0, R0, @@return
			LW T0, g_current_obj_ptr
			SW R0, o_state (T0)
		
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
