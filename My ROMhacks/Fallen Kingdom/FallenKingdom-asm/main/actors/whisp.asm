@_waypoint equ 0xF4
@_timer equ 0xF8

@SPEED equ 30
@WAIT_TIMER equ 30

beh_whisp_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_SET_WORD @_waypoint, @waypoint_table
BHV_SET_INT @_timer, 0
BHV_BILLBOARD
BHV_SCALE 200
BHV_SET_FLOAT o_render_distance, 10000
BHV_STORE_HOME
BHV_EXEC @whisp_init
BHV_SLEEP 1
BHV_LOOP_BEGIN
	BHV_EXEC @update_gfx
	BHV_EXEC @spawn_trail
	BHV_EXEC @main_loop
	BHV_ADD_INT @_timer, 1 ; state-independant timer
BHV_LOOP_END

.definelabel @beh_whisp_trail, (org() - 0x80000000)
BHV_START OBJ_LIST_PARTICLES
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_BILLBOARD
BHV_SET_INT o_animation_state, -1
BHV_SCALE 200
BHV_SET_FLOAT o_render_distance, 10000
BHV_REPEAT_BEGIN 15
	BHV_ADD_INT o_animation_state, 1
	BHV_EXEC @shrink
BHV_REPEAT_END
BHV_DELETE
BHV_END

.macro @WAY, x, z
	.word float( x ), float( z )
.endmacro

@waypoint_table:
	@WAY -656, 3995
	@WAY 1281, 2502
	@WAY 3219, 3592
	@WAY 2976, 605
	@WAY 2210, -242
	@WAY 3622, -1936
	@WAY 3622, -3349
	@WAY 2088, -4277
	@WAY 30, -3550
	@WAY -1826, 243
	@WAY 878, 1332
	@WAY -1867, 2381
	@WAY -4127, 2462
	@WAY -4975, -1452
	@WAY -2916, -2421
	@WAY -2889, -7000
@waypoint_table_end:
NOP

@whisp_init:
	LBU T0, (global_vars + gv_items)
	ANDI T0, T0, ITEM_LENS
	BNE T0, R0, @@return
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@return:
	J @main_loop
	NOP

@main_loop:
	LW T0, g_current_obj_ptr
	LW T1, @_waypoint (T0)
	
	LHU T2, 0x8033B252
	SETU AT, 0x13
	BNE T2, AT, @@endif_reset
	LHU T2, 0x8033B254
	SETU AT, 1
	BNE T2, AT, @@endif_reset
		LW AT, o_home_x (T0)
		SW AT, o_x (T0)
		LW AT, o_home_y (T0)
		SW AT, o_y (T0)
		LW AT, o_home_z (T0)
		SW AT, o_z (T0)
		SW R0, @_timer (T0)
		LI T2, @waypoint_table
		SW T2, @_waypoint (T0)
	@@endif_reset:
	
	LW AT, @_timer (T0)
	SLTIU AT, AT, 90
	BNE AT, R0, @@return
	
	LW T2, o_state (T0)
	BNE T2, R0, @@endif_moving
		L.S F4, o_x (T0)
		L.S F5, o_z (T0)
		L.S F6, 0x0 (T1)
		L.S F7, 0x4 (T1)
		
		SUB.S F4, F6, F4
		SUB.S F5, F7, F5
		
		MUL.S F6, F4, F4
		MUL.S F7, F5, F5
		ADD.S F6, F6, F7
		LI.S F7, @SPEED
		SQRT.S F6, F6
		
		C.LE.S F6, F7
		MUL.S F4, F4, F7
		BC1F @@endif_hit_waypoint
		MUL.S F5, F5, F7
			ADDIU T1, T1, 0x8
			SW T1, @_waypoint (T0)
			SETU AT, 1
			B @@return
			SW AT, o_state (T0)
		@@endif_hit_waypoint:
		DIV.S F4, F4, F6
		DIV.S F5, F5, F6
		L.S F6, o_x (T0)
		L.S F7, o_z (T0)
		ADD.S F4, F6, F4
		ADD.S F5, F7, F5
		S.S F4, o_x (T0)
		B @@return
		S.S F5, o_z (T0)
	@@endif_moving:
	
	SETU AT, 1
	BNE T2, AT, @@endif_pausing
		LW AT, o_timer (T0)
		SLTIU AT, AT, @WAIT_TIMER
		BNE AT, R0, @@return
		LI T2, @waypoint_table_end
		BNE T1, T2, @@endif_done
		MOVE AT, R0
			SETU AT, 2
		@@endif_done:
		B @@return
		SW AT, o_state (T0)
	@@endif_pausing:
	
	LW AT, o_timer (T0)
	SLTIU AT, AT, 90
	BNE AT, R0, @@endif_despawn
	NOP
		B @@return
		SH R0, o_active_flags (T0)
	@@endif_despawn:
	
	LI.S F5, (@SPEED * 1.5)
	L.S F4, o_y (T0)
	ADD.S F4, F4, F5
	S.S F4, o_y (T0)
	
	@@return:
	JR RA
	NOP
	
@update_gfx:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)
	
	LW S0, g_current_obj_ptr
	
	LW A0, @_timer (S0)
	JAL angle_to_unit_vector
	SLL A0, A0, 10
	
	LI.S F6, 50
	L.S F4, o_x (S0)
	L.S F5, o_z (S0)
	MUL.S F0, F0, F6
	MUL.S F1, F1, F6
	ADD.S F4, F4, F0
	ADD.S F5, F5, F1
	S.S F4, o_gfx_x (S0)
	S.S F5, o_gfx_z (S0)
	
	LW A0, @_timer (S0)
	JAL sin_u16
	SLL A0, A0, 8
	
	LI.S F5, 25
	L.S F4, o_y (S0)
	MUL.S F5, F5, F0
	ADD.S F4, F4, F5
	S.S F4, o_gfx_y (S0)
	
	LW S0, 0x10 (SP)
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@spawn_trail:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LW AT, @_timer (A0)
	ANDI AT, AT, 1
	BEQ AT, R0, @@return
	
	LI A2, @beh_whisp_trail
	JAL spawn_object
	SETU A1, 0x8F
	
	LW T0, g_current_obj_ptr
	ADDIU A0, T0, o_gfx_position
	JAL copy_vector
	ADDIU A1, V0, o_position
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@shrink:
	LW T0, g_current_obj_ptr
	LI.S F6, 0.125
	L.S F4, o_scale_x (T0)
	L.S F5, o_scale_y (T0)
	SUB.S F4, F4, F6
	SUB.S F5, F5, F6
	S.S F4, o_scale_x (T0)
	JR RA
	S.S F5, o_scale_y (T0)
