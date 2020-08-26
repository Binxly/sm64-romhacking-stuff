; HE'S FREEEEEEEEEEEEEE

dead_chomp_flags:
.word 0

beh_free_range_chomp_impl:
; BHV_START OBJ_LIST_INTERACTIVE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_AUTO_FACE_FORWARDS_HORIZONTAL | OBJ_STORE_DISTANCE_TO_MARIO | OBJ_STORE_ANGLE_TO_MARIO | OBJ_ALWAYS_ACTIVE
BHV_DROP_TO_FLOOR
BHV_STORE_HOME
BHV_SET_WORD o_animation_pointer, 0x06025178
BHV_SET_ANIMATION 0
BHV_SET_FLOAT o_gfx_y_offset, 240
BHV_SCALE 200
BHV_SET_PHYSICS 120, -400, 0, 0, 1000, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_INT o_state, 0
BHV_SET_INT o_intangibility_timer, 0
BHV_EXEC @free_range_chomp_init
BHV_LOOP_BEGIN
	BHV_EXEC @bomb_check
	BHV_EXEC @free_range_chomp_loop
	BHV_SET_INT o_interaction_status, 0
	BHV_SET_INT o_move_flags, 0
BHV_LOOP_END

@hitbox:
.word INT_DAMAGE ; interaction
.byte 0 ; downOffset
.byte 4 ; collision damage
.byte 1 ; health
.byte 0 ; loot coins
.halfword 120 ; hitbox radius
.halfword 240 ; hitbox height
.halfword 120 ; hurtbox radius
.halfword 240 ; hurtbox height


@HOME_RADIUS equ 750
@WANDER_RADIUS equ 2000
@CHASE_RADIUS equ 6000
@AGGRO_RADIUS equ 2500

@LUNGE_STRENGTH equ 45
@CHASE_SPEED equ 75
@CHASE_PAUSE_TIME equ 8

@HOP_STRENGTH equ 40
@WANDER_SPEED equ 35
@WANDER_PAUSE_TIME equ 30
@TURN_SPEED equ 0x1000

@STATE_REST equ 0
@STATE_WANDER equ 4
@STATE_CHASE equ 8
@STATE_TURN equ 12
@STATE_RETURN equ 16
@STATE_DEAD equ 20

@action_table:
.word @do_rest
.word @do_wander
.word @do_chase
.word @do_turn
.word @do_return
.word @do_death

@free_range_chomp_init:
	LW A0, g_current_obj_ptr
	LHU AT, o_active_flags (A0)
	ORI AT, AT, AF_IGNORES_WATER
	SH AT, o_active_flags (A0)
	LW T0, dead_chomp_flags
	LBU AT, o_arg0 (A0)
	AND AT, T0, AT
	BEQ AT, R0, @@endif_dead
	NOP
		SH R0, o_active_flags (A0)
	@@endif_dead:
	LI.U A1, @hitbox
	J set_object_hitbox
	LI.L A1, @hitbox

@free_range_chomp_loop:
	LW T0, g_current_obj_ptr
	LW T0, o_state (T0)
	LI T1, @action_table
	ADDU T0, T0, T1
	LW T0, 0x0 (T0)
	JR T0
	NOP

@bomb_check:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LW T1, o_state (T0)
	SETU AT, @STATE_DEAD
	BEQ T1, AT, @@return
	
	LI A1, beh_explosion
	JAL colliding_with_type
	MOVE A0, T0
	
	BEQ V0, R0, @@return
		LW T0, g_current_obj_ptr
		SETU AT, -1
		SW AT, o_intangibility_timer (T0)
		LI AT, float( 45 )
		SW AT, o_speed_y (T0)
		LI AT, float( -10 )
		SW AT, o_speed_h (T0)
		LI AT, float( -2 )
		SW AT, o_gravity (T0)
		SETU AT, @STATE_DEAD
		SW AT, o_state (T0)
		; play sound?
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@move:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)
	
	JAL obj_update_floor
	NOP
	
	JAL decompose_speed
	NOP
	
	JAL obj_move_standard
	SETU A0, 78
	
	JAL obj_resolve_wall_collisions
	NOP
	
	LW T0, g_current_obj_ptr
	BEQ V0, R0, @@endif_hit_wall
	LW V0, o_move_flags (T0)
		ORI V0, V0, MF_HIT_WALL
		SW V0, o_move_flags (T0)
	@@endif_hit_wall:
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@do_rest:
	LW T0, g_current_obj_ptr
	LI.S F5, @AGGRO_RADIUS
	L.S F4, o_distance_to_mario (T0)
	C.LE.S F4, F5
	LW T1, o_timer (T0)
	BC1F @@endif_aggro
		SETU AT, @STATE_TURN
		JR RA
		SW AT, o_state (T0)
	@@endif_aggro:
	SLTI AT, T1, @WANDER_PAUSE_TIME
	BNE AT, R0, @@endif_hop
	NOP
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		JAL obj_xz_dist_from_home
		LW.U T0, g_current_obj_ptr
		LI.S F4, @WANDER_RADIUS
		LW.L T0, g_current_obj_ptr
		C.LT.S F0, F4
		SETU AT, @STATE_RETURN
		BC1F @@return
		SW AT, o_state (T0)
			JAL get_random_short
			NOP
			LW T0, g_current_obj_ptr
			SLL AT, V0, 16
			SRA AT, AT, 18
			LW T1, o_move_angle_yaw (T0)
			ADDU T1, T1, AT
			SHORT AT, T1
			SW AT, o_move_angle_yaw (T0)
			LI AT, float( @HOP_STRENGTH )
			SW AT, o_speed_y (T0)
			LI AT, float( @WANDER_SPEED )
			SW AT, o_speed_h (T0)
			SETU AT, @STATE_WANDER
			SW AT, o_state (T0)
		@@return:
		LW RA, 0x14 (SP)
		ADDIU SP, SP, 0x18
	@@endif_hop:
	JR RA
	NOP
	
@do_wander:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP) 
	
	JAL @move
	NOP
	
	ANDI AT, V0, (MF_JUST_LANDED | MF_GROUNDED)
	BEQ AT, R0, @@return
	
	LW T0, g_current_obj_ptr
	SETU AT, @STATE_REST
	SW AT, o_state (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@do_chase:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP) 
	
	JAL @move
	NOP
	
	ANDI AT, V0, (MF_JUST_LANDED | MF_GROUNDED)
	BEQ AT, R0, @@return
	
	LW T0, g_current_obj_ptr
	SETU AT, @STATE_TURN
	SW AT, o_state (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@do_turn:
	LW T0, g_current_obj_ptr
	LW AT, o_timer (T0)
	SLTI AT, AT, @CHASE_PAUSE_TIME
	BNE AT, R0, @@endif_lunge
		LW AT, o_angle_to_mario (T0)
		SW AT, o_move_angle_yaw (T0)
		LI AT, float( @LUNGE_STRENGTH )
		SW AT, o_speed_y (T0)
		LI AT, float( @CHASE_SPEED )
		SW AT, o_speed_h (T0)
		SETU AT, @STATE_CHASE
		SW AT, o_state (T0)
		LUI A0, 0x303A
		J play_sound
		ORI A0, A0, 0x0081
	@@endif_lunge:
	
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP) 
	
	JAL get_mario_dist_from_home
	NOP
	
	LI.S F4, @CHASE_RADIUS
	LW.U T0, g_current_obj_ptr
	C.LT.S F0, F4
	LW.L T0, g_current_obj_ptr
	BC1T @@endif_go_home
		SETU AT, @STATE_RETURN
		SW AT, o_state (T0)
	@@endif_go_home:
	
	LW A0, o_angle_to_mario (T0)
	JAL turn_move_angle_towards_target_angle
	SETU A1, @TURN_SPEED
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@do_return:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL @move
	NOP
	
	ANDI AT, V0, (MF_JUST_LANDED | MF_GROUNDED)
	BEQ AT, R0, @@return
	NOP
	
	JAL obj_xz_dist_from_home
	NOP
	
	LI.S F4, @HOME_RADIUS
	NOP
	C.LE.S F0, F4
	NOP
	BC1F @@endif_home
		LW T0, g_current_obj_ptr
		SETU AT, @STATE_REST
		B @@return
		SW AT, o_state (T0)
	@@endif_home:
	
	JAL obj_angle_to_home
	NOP
	
	LW T0, g_current_obj_ptr
	SW V0, o_move_angle_yaw (T0)
	LI AT, float( @HOP_STRENGTH )
	SW AT, o_speed_y (T0)
	LI AT, float( @WANDER_SPEED )
	SW AT, o_speed_h (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@do_death:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LW T1, o_timer (T0)
	
	SLTI AT, T1, 40
	BNE AT, R0, @@endif_despawn
		SW T0, 0x10 (SP)
		MOVE A0, T0
		LI A2, 0x130017F4
		JAL spawn_object
		SETU A1, 0x96
		LW T0, g_current_obj_ptr
		LW T1, dead_chomp_flags
		LBU AT, o_arg0 (T0)
		OR T0, T1, AT
		SW T0, dead_chomp_flags
		SETU AT, 0x1F
		BNE T0, AT, @@endif_last_chomp_defeated
			LW A0, 0x10 (SP)
			LI A2, beh_golden_shroom
			JAL spawn_object
			SETU A1, 0xD4
			SETU AT, SHROOM_PLAINS_CHOMPS
			SH AT, o_arg0 (V0)
			LI.U RA, @@delete
			J 0x803220F0
			LI.L RA, @@delete
		@@endif_last_chomp_defeated:
			JAL count_bits
			MOVE A0, T0
			ADDIU A0, V0, 0x7030
			SLL A0, A0, 16
			ORI A0, A0, 0x2081
			LW A1, g_mario_obj_ptr
			JAL set_sound
			ADDIU A1, A1, 0x54
			LW A0, 0x10 (SP)
			LI A2, beh_super_shroom
			JAL spawn_object
			SETU A1, 0xD4
		@@delete:
		LW T0, 0x10 (SP)
		B @@return
		SH R0, o_active_flags (T0)
	@@endif_despawn:
	
	LW AT, o_face_angle_pitch (T0)
	ADDIU AT, AT, 0xF99A
	SHORT AT, AT
	SW AT, o_face_angle_pitch (T0)
	
	LI.S F5, 40
	LI.S F6, 120
	L.S F4, o_timer (T0)
	CVT.S.W F4, F4
	SUB.S F4, F5, F4
	DIV.S F4, F4, F5
	ADD.S F4, F4, F4
	MUL.S F5, F4, F6
	S.S F5, o_gfx_y_offset (T0)
	MFC1 A1, F4
	JAL scale_object
	MOVE A0, T0
	
	JAL @move
	NOP
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
