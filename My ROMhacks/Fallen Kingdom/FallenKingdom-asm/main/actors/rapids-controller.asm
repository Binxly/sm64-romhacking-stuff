beh_rapids_controller_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_SET_WORD 0xF4, @obstacle_table
BHV_LOOP_BEGIN
	BHV_EXEC @restrict_mario_movement
	BHV_EXEC @move_obstacles
	BHV_EXEC @spawn_obstacles
	BHV_EXEC @make_water_sound
	BHV_EXEC @check_goal
BHV_LOOP_END

@restrict_mario_movement:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI T0, g_mario
	SW R0, m_z (T0)
	LW T1, m_controller (T0)
	BEQ T1, R0, @@endif_straighten
	LH V0, m_angle_yaw (T0)
	LHU T1, c_analog_short_x (T1)
	ABS T1, T1
	SLTIU AT, T1, 20
	BEQ AT, R0, @@endif_straighten
		LH A0, m_angle_yaw (T0)
		MOVE A1, R0
		JAL turn_angle
		SETU A2, 0x100
	@@endif_straighten:
	
	LI A0, g_mario
	MINI V0, V0, 0x2800
	MAXI V0, V0, 0xD800
	SH V0, m_angle_yaw (A0)
	
	LW T0, m_action (A0)
	LI T1, 0x380022C0
	BNE T0, T1, @@endif_idle
		LI A1, 0x300024D0
		JAL set_mario_action
		MOVE A2, R0
		B @@endif_swimming
	@@endif_idle:
	LI T1, 0x300024D1
	BNE T0, T1, @@endif_swimming
		ADDIU A1, T1, 0xFFFF
		JAL set_mario_action
		MOVE A2, R0
		B @@endif_swimming
	@@endif_swimming:
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	

@move_obstacles:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL @process_object_list
	SETU A0, OBJ_LIST_EXPLOSION
	
	JAL @process_object_list
	SETU A0, OBJ_LIST_LEVEL
	
	JAL @process_object_list
	SETU A0, OBJ_LIST_SURFACE
	
	JAL @process_object_list
	SETU A0, OBJ_LIST_PARTICLES
	
	JAL @process_object_list
	SETU A0, OBJ_LIST_DEFAULT
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@process_object_list:
	SETU AT, 0x68
	MULTU A0, AT
	LW T0, 0x803610E8
	MFLO AT
	NOP
	ADDU T1, T0, AT
	MOVE T0, T1
	
	@@loop:
	LW T0, 0x60 (T0)
	BEQ T0, T1, @@break
		LI.S F5, 60
		L.S F4, o_z (T0)
		SUB.S F4, F4, F5
		LI.S F5, -4096
		S.S F4, o_z (T0)
		C.LT.S F4, F5
		NOP
		BC1F @@loop
		NOP
		B @@loop
		SH R0, o_active_flags (T0)
	@@break:
	
	JR RA
	NOP
	
@spawn_obstacles:
	ADDIU SP, SP, 0xFFE0
	SW RA, 0x1C (SP)
	SW S0, 0x18 (SP)
	SW S1, 0x14 (SP)
	SW S2, 0x10 (SP)
	
	LW S2, g_current_obj_ptr
	LW S1, o_timer (S2)
	LW S0, 0xF4 (S2)
	
	@@loop:
	LI T0, @obstacle_table_end
	BEQ S0, T0, @@return
		LW T0, 0x0 (S0)
		SLTU AT, S1, T0
		BNE AT, R0, @@return
		NOP
		
		MOVE A0, S2
		MOVE A1, R0
		JAL spawn_object
		LW A2, 0x4 (S0)
		
		LW AT, 0x8 (S0)
		SW AT, o_x (V0)
		LW AT, 0xC (S0)
		SW AT, o_y (V0)
		LI AT, float( 8196 )
		SW AT, o_z (V0)
		SW AT, o_render_distance (V0)
		SW R0, o_intangibility_timer (V0)
		SETU AT, SHROOM_RAPIDS
		SH AT, o_arg0 (V0)
		SETU AT, 1
		SB AT, o_arg3 (V0)
		
		B @@loop
		ADDIU S0, S0, 16
	
	@@return:
	SW S0, 0xF4 (S2)
	
	LW S2, 0x10 (SP)
	LW S1, 0x14 (SP)
	LW S0, 0x18 (SP)
	LW RA, 0x1C (SP)
	JR RA
	ADDIU SP, SP, 0x20
	
@make_water_sound:
	LI A0, 0x40010001
	LW A1, g_current_obj_ptr
	J set_sound
	ADDIU A1, A1, 0x54
	
@check_goal:
	LW T0, g_current_obj_ptr
	LW T0, o_timer (T0)
	SLTI AT, T0, 3975
	BNE AT, R0, @@return
	NOP
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)
		
		SETU A0, 0x16
		SETU A1, 1
		SETU A2, 10
		JAL 0x8024A700
		MOVE A3, R0
		
		MOVE A0, R0
		JAL 0x802497B8
		MOVE A1, R0
		
		SETU T0, 4
		SH T0, 0x8033BACC
		
		LW RA, 0x14 (SP)
		ADDIU SP, SP, 0x18
	@@return:
	JR RA
	NOP
	
.include "./rapids-objects.asm"

.macro @DEFINE_OBSTACLE, time, behaviour, x, y
	.word (time * 15), behaviour, float( x ), float( y )
.endmacro

@obstacle_table:
	@DEFINE_OBSTACLE 6, beh_rapids_bomb, 0, -150
	@DEFINE_OBSTACLE 14, beh_rapids_stake, -180, -300
	@DEFINE_OBSTACLE 14, beh_rapids_stake, 180, -300
	@DEFINE_OBSTACLE 20, beh_rapids_stake, 0, -300
	@DEFINE_OBSTACLE 30, beh_rapids_bomb, 0, 0
	@DEFINE_OBSTACLE 30, beh_rapids_bomb, -180, 0
	@DEFINE_OBSTACLE 30, beh_rapids_bomb, 180, 0
	@DEFINE_OBSTACLE 36, beh_rapids_grate, 0, -300
	
	@DEFINE_OBSTACLE 46, beh_rapids_bouncing_bomb, 0, 25
	@DEFINE_OBSTACLE 46, beh_rapids_bouncing_bomb, 0, -150
	@DEFINE_OBSTACLE 50, beh_rapids_log, 0, 25
	@DEFINE_OBSTACLE 50, beh_rapids_bomb, -180, -150
	@DEFINE_OBSTACLE 56, beh_rapids_stake, 180, -300
	@DEFINE_OBSTACLE 59, beh_rapids_stake, 0, -300
	@DEFINE_OBSTACLE 62, beh_rapids_stake, -180, -300
	@DEFINE_OBSTACLE 66, beh_rapids_grate, 0, -300
	@DEFINE_OBSTACLE 72, beh_rapids_log, 0, 75
	@DEFINE_OBSTACLE 78, beh_rapids_stake, 0, -300
	@DEFINE_OBSTACLE 81, beh_rapids_stake, 180, -300
	@DEFINE_OBSTACLE 81, beh_rapids_bomb, -180, -50
	@DEFINE_OBSTACLE 90, beh_rapids_log, 0, -75
	@DEFINE_OBSTACLE 90, beh_rapids_bouncing_bomb, -150, 125
	@DEFINE_OBSTACLE 95, beh_rapids_log, 0, 0
	@DEFINE_OBSTACLE 95, beh_rapids_bomb, 0, -150
	@DEFINE_OBSTACLE 100, beh_rapids_log, 0, 0
	@DEFINE_OBSTACLE 100, beh_super_shroom, 0, 125
	@DEFINE_OBSTACLE 108, beh_rapids_bouncing_bomb, 215, 25
	@DEFINE_OBSTACLE 108, beh_rapids_bouncing_bomb, -215, -150
	@DEFINE_OBSTACLE 114, beh_rapids_grate, 0, -300
	
	@DEFINE_OBSTACLE 120, beh_rapids_log, 0, 25
	@DEFINE_OBSTACLE 122, beh_rapids_log, 0, 150
	@DEFINE_OBSTACLE 122, beh_golden_shroom, 0, 250

	@DEFINE_OBSTACLE 132, beh_rapids_bomb, 0, -150
	@DEFINE_OBSTACLE 132, beh_rapids_bomb, 0, 25
	@DEFINE_OBSTACLE 132, beh_rapids_bomb, -180, 25
	@DEFINE_OBSTACLE 132, beh_rapids_bomb, 180, -150
	@DEFINE_OBSTACLE 135, beh_rapids_log, -180, -300
	@DEFINE_OBSTACLE 135, beh_rapids_log, 180, -300
	@DEFINE_OBSTACLE 142, beh_rapids_bomb, 180, 0
	@DEFINE_OBSTACLE 142, beh_super_shroom, 180, 150
	@DEFINE_OBSTACLE 147, beh_rapids_grate, 0, -300
	@DEFINE_OBSTACLE 150, beh_rapids_log, 0, 75
	@DEFINE_OBSTACLE 158, beh_rapids_bouncing_bomb, 0, 25
	@DEFINE_OBSTACLE 158, beh_rapids_bouncing_bomb, 215, 25
	@DEFINE_OBSTACLE 158, beh_rapids_grate, 0, -425
	@DEFINE_OBSTACLE 163, beh_super_shroom, 0, 0
	@DEFINE_OBSTACLE 164, beh_rapids_bomb, 0, 0
	@DEFINE_OBSTACLE 170, beh_rapids_stake, -25, -300
	@DEFINE_OBSTACLE 170, beh_rapids_stake, -200, -300
	@DEFINE_OBSTACLE 173, beh_rapids_stake, 25, -300
	@DEFINE_OBSTACLE 173, beh_rapids_stake, 200, -300
	@DEFINE_OBSTACLE 176, beh_rapids_stake, -25, -300
	@DEFINE_OBSTACLE 176, beh_rapids_stake, -200, -300
	@DEFINE_OBSTACLE 180, beh_rapids_stake, 25, -300
	@DEFINE_OBSTACLE 180, beh_rapids_stake, 200, -300
	@DEFINE_OBSTACLE 183, beh_rapids_grate, 0, -300
	
	@DEFINE_OBSTACLE 193, beh_rapids_grate, 0, -300
	@DEFINE_OBSTACLE 197, beh_rapids_grate, 0, -300
	@DEFINE_OBSTACLE 202, beh_rapids_grate, 0, -300
	@DEFINE_OBSTACLE 206, beh_rapids_stake, 180, -300
	@DEFINE_OBSTACLE 206, beh_rapids_stake, -180, -300
	@DEFINE_OBSTACLE 206, beh_rapids_bomb, 0, 75
	@DEFINE_OBSTACLE 210, beh_super_shroom, 0, 125
	@DEFINE_OBSTACLE 216, beh_rapids_bomb, -200, 75
	@DEFINE_OBSTACLE 216, beh_rapids_bomb, 0, 75
	@DEFINE_OBSTACLE 216, beh_rapids_bomb, 200, 75
	@DEFINE_OBSTACLE 216, beh_rapids_bouncing_bomb, 116, -150
	@DEFINE_OBSTACLE 220, beh_rapids_grate, 0, -300
	@DEFINE_OBSTACLE 224, beh_rapids_stake, 180, -300
	@DEFINE_OBSTACLE 228, beh_rapids_grate, 0, -300
	@DEFINE_OBSTACLE 232, beh_rapids_stake, 0, -300
	@DEFINE_OBSTACLE 236, beh_rapids_grate, 0, -300
	@DEFINE_OBSTACLE 240, beh_rapids_stake, -180, -300
	
	@DEFINE_OBSTACLE 248, beh_ultra_shroom, 0, 75
	@DEFINE_OBSTACLE 256, beh_rapids_goal, 0, 0
@obstacle_table_end:
NOP
