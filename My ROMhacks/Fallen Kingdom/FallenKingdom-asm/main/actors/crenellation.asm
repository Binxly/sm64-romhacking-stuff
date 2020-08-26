@_num_destroyed equ 0xF4

beh_crenellation_spawner_impl:
; BHV_START OBJ_LIST_SPANER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_SET_INT @_num_destroyed, 0
BHV_EXEC @spawn_crenellations
BHV_END

.definelabel @beh_crenellation, (org() - 0x80000000)
BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO | OBJ_ALWAYS_ACTIVE
BHV_SET_COLLISION bb_level_34_object_Crenellation_collision
BHV_SET_FLOAT o_collision_distance, 275
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_y, 6400
BHV_SET_INTERACTION 0
BHV_SET_HITBOX 152, 147, 0
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC process_collision
BHV_LOOP_END

@spawn_crenellations:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)
	
	SETU S0, 0x400
	@@loop:
		LW A0, g_current_obj_ptr
		LI A2, @beh_crenellation
		JAL spawn_object
		SETU A1, 33
		
		SW S0, o_face_angle_yaw (V0)
		JAL angle_to_unit_vector
		MOVE A0, S0
		
		LI.S F4, 1456
		NOP
		MUL.S F0, F0, F4
		MUL.S F1, F1, F4
		S.S F0, o_x (V0)
		S.S F1, o_z (V0)
		
		ADDIU S0, S0, 0x1000
		LUI AT, 0x1
		SLTU AT, S0, AT
		BNE AT, R0, @@loop
		NOP
		
	LW S0, 0x10 (SP)
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
		

@loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI.U A0, beh_explosion
	JAL get_nearest_object_with_behaviour
	LI.L A0, beh_explosion
	
	BEQ V0, R0, @@check_bowser
	LW A0, g_current_obj_ptr
	
	JAL check_if_hitboxes_overlap
	MOVE A1, V0
	
	BNE V0, R0, @@explode
	
	@@check_bowser:
	LI.U A0, beh_bowser
	JAL get_nearest_object_with_behaviour
	LI.L A0, beh_bowser
	
	BEQ V0, R0, @@return
	LW A0, g_current_obj_ptr
	
	JAL check_if_hitboxes_overlap
	MOVE A1, V0
	
	BEQ V0, R0, @@return
	NOP
	
	LUI A0, 0x3049
	JAL play_sound
	ORI A0, A0, 0xA081
	
	@@explode:
	LI.U A0, @brick_particles
	JAL spawn_particles
	LI.L A0, @brick_particles
	
	LW T0, g_current_obj_ptr
	SH R0, o_active_flags (T0)
	
	LW T1, o_parent (T0)
	LW T2, @_num_destroyed (T1)
	ADDIU T3, T2, 1
	SW T3, @_num_destroyed (T1)
	
	BEQ T2, R0, @@return
	AND AT, T2, T3
	BNE AT, R0, @@return
	
	MOVE A0, T0
	LI A2, beh_super_shroom
	JAL spawn_object
	SETU A1, 0xD4
	
	LI T0, float( 100 )
	SW T0, o_speed_y (V0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@brick_particles:
.byte 0 ; behaviour argument
.byte 3 ; number of particles
.byte 40 ; modelId
.byte 0 ; vertical offset
.byte 10 ; base horizontal velocity
.byte 5 ; random horizontal velocity range
.byte 20 ; base vertical velocity
.byte 18 ; random vertical velocity range
.byte -4 ; gravity
.byte 0 ; drag
.align 4
.word float( 4.0 ) ; base size
.word float( 1.0 ) ; random size range
