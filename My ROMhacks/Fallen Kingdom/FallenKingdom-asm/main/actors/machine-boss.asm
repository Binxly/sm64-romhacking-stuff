@WATER_SPEED equ 10
@WAVE_SPEED equ 40

beh_machine_boss_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_COLLISION bb_level_22_object_The_Machine__Undamaged__collision
BHV_SET_FLOAT o_collision_distance, 0x7FFF
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INT o_health, 3
BHV_EXEC @boss_init
BHV_SLEEP 1
BHV_LOOP_BEGIN
	BHV_EXEC @boss_loop
	BHV_EXEC process_collision
BHV_LOOP_END

beh_machine_boss_floor_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_COLLISION bb_level_22_object_Floor_Collision_collision
BHV_SET_FLOAT o_collision_distance, 0x7FFF
BHV_SET_INT o_intangibility_timer, 0
BHV_EXEC @reset_water_texture
BHV_LOOP_BEGIN
	BHV_EXEC @set_water_speed
	BHV_EXEC @move_bombs_and_shrooms
	BHV_EXEC @set_water_texture
	BHV_EXEC process_collision
BHV_LOOP_END

/* Machine properties */
@_attack_order equ 0xF4
@_attack_timer equ 0xF8
@_hammer equ 0xFC
@_flap equ 0x100
@_lasers equ 0x104
@_zapper1 equ 0x108
@_zapper2 equ 0x10C
@_needle equ 0x110

/* Hammer properties */
@_hammer_target equ 0xF4
@_slam_count equ 0xF8

/* Wave Spawner properties */
@_wave_count equ 0xF4

/* Needle properties */
@_mean_angle equ 0xF4
@_angle_variance equ 0xF6

/* Laser properties */
@_opacity_ptr_active equ 0xF4
@_opacity_ptr_other equ 0xF8

/* Flap properties */
@_spawn_count equ 0xF4

.definelabel @beh_machine_needle, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_ADD_FLOAT o_y, 255
BHV_ADD_FLOAT o_z, 1
BHV_SET_WORD 0xF4, 0x2AAB071D
BHV_LOOP_BEGIN
	BHV_EXEC @needle_loop
BHV_LOOP_END


.definelabel @beh_left_piston, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_ADD_FLOAT o_x, -200
BHV_ADD_FLOAT o_y, 230
BHV_ADD_FLOAT o_z, -50
BHV_SET_WORD 0xF4, float( 3.75 )
BHV_SET_WORD 0xF8, float( -7.5 )
BHV_LOOP_BEGIN
	BHV_REPEAT_BEGIN 20
		BHV_SUM_FLOATS o_y, o_y, 0xF4
		BHV_EXEC @require_parent_alive
	BHV_REPEAT_END
	BHV_REPEAT_BEGIN 10
		BHV_SUM_FLOATS o_y, o_y, 0xF8
		BHV_EXEC @require_parent_alive
	BHV_REPEAT_END
BHV_LOOP_END

.definelabel @beh_right_piston, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_ADD_FLOAT o_x, 200
BHV_ADD_FLOAT o_y, 305
BHV_ADD_FLOAT o_z, -50
BHV_SET_WORD 0xF4, float( 3.75 )
BHV_SET_WORD 0xF8, float( -7.5 )
BHV_LOOP_BEGIN
	BHV_REPEAT_BEGIN 10
		BHV_SUM_FLOATS o_y, o_y, 0xF8
		BHV_EXEC @require_parent_alive
	BHV_REPEAT_END
	BHV_REPEAT_BEGIN 20
		BHV_SUM_FLOATS o_y, o_y, 0xF4
		BHV_EXEC @require_parent_alive
	BHV_REPEAT_END
BHV_LOOP_END


.definelabel @beh_machine_hammer, (org() - 0x80000000)
BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_ADD_FLOAT o_z, -183
BHV_LOOP_BEGIN
	BHV_EXEC @hammer_loop
BHV_LOOP_END

.definelabel @beh_machine_zapper, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_WORD o_animation_pointer, 0x08004034
BHV_SET_FLOAT o_gfx_y_offset, -20
BHV_SCALE 50
BHV_SET_ANIMATION 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_ADD_FLOAT o_y, 125
BHV_ADD_FLOAT o_z, 50
BHV_LOOP_BEGIN
	BHV_EXEC @require_parent_alive
	BHV_EXEC @zapper_loop
BHV_LOOP_END

.definelabel @beh_machine_flap, (org() - 0x80000000)
BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_ADD_FLOAT o_y, 120
BHV_LOOP_BEGIN
	BHV_EXEC @flap_loop
BHV_LOOP_END

.definelabel @beh_wave_spawner, (org() - 0x80000000)
BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_ADD_FLOAT o_z, -100
BHV_REPEAT_BEGIN 6
	BHV_SLEEP 20
	BHV_EXEC @spawn_wave
BHV_REPEAT_END
BHV_DELETE
BHV_END

.definelabel @beh_wave, (org() - 0x80000000)
BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_COLLISION bb_level_22_object_Wave_collision
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_SET_FLOAT o_speed_z, @WAVE_SPEED
BHV_ADD_FLOAT o_y, 1
BHV_REPEAT_BEGIN int( 2000 / @WAVE_SPEED )
	BHV_EXEC @set_wave_tangibility
	BHV_ADD_FLOAT o_z, @WAVE_SPEED
	BHV_EXEC process_collision
BHV_REPEAT_END
BHV_DELETE
BHV_END

.definelabel @electified_water_hitbox, (org() - 0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_SET_INTERACTION INT_SHOCK
BHV_SET_INT o_collision_damage, 2
BHV_SET_INT o_intangibility_timer, 1
BHV_SET_HITBOX 1083, 40, 0
BHV_SET_FLOAT o_x, 0
BHV_SET_FLOAT o_y, 0
BHV_SET_FLOAT o_z, 0
BHV_REPEAT_BEGIN 45
	BHV_EXEC @electric_water_loop
BHV_REPEAT_END
BHV_DELETE
BHV_END

.definelabel @beh_shockwave, (org() - 0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_INT o_interaction_arg, IA_BIG_KNOCKBACK
BHV_SET_INT o_collision_damage, 2
BHV_SET_INT o_intangibility_timer, 0
BHV_ADD_FLOAT o_y, 40
BHV_SET_HITBOX 64, 296, 0
BHV_REPEAT_BEGIN 10
	BHV_SLEEP 3
	BHV_ADD_FLOAT o_z, 96
	BHV_SLEEP 3
	BHV_ADD_FLOAT o_z, 96
	BHV_SPAWN_OBJECT 0xA7, @beh_sploosh, 0
	BHV_SET_INT o_interaction_status, 0
BHV_REPEAT_END
BHV_DELETE
BHV_END

.definelabel @beh_sawblade, (org() - 0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_HITBOX 275, 20, 10
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INT o_collision_damage, 3
BHV_SET_FLOAT o_render_distance, 5000
BHV_ADD_FLOAT o_z, -275
BHV_ADD_FLOAT o_y, 140
BHV_REPEAT_BEGIN 125
	BHV_ADD_INT o_face_angle_yaw, 0xF380
	BHV_ADD_FLOAT o_z, 40
	BHV_EXEC @play_sawblade_sound
	BHV_SET_INT o_interaction_status, 0
BHV_REPEAT_END
BHV_DELETE
BHV_END

.definelabel @beh_mine, (org() - 0x80000000)
BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_INT o_collision_damage, 2
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INT o_face_angle_pitch, 0
BHV_SCALE 50
BHV_SET_HITBOX 50, 100, 50
BHV_DROP_TO_FLOOR
BHV_ADD_FLOAT o_y, 50
BHV_ADD_FLOAT o_z, -50
BHV_REPEAT_BEGIN int( ( 2050 / @WATER_SPEED ) + 1 )
	BHV_ADD_FLOAT o_z, @WATER_SPEED
	BHV_EXEC @mine_loop
BHV_REPEAT_END
BHV_OR_FLAGS o_flags, OBJ_AUTO_MOVE_Y
BHV_REPEAT_BEGIN 18
	BHV_ADD_FLOAT o_speed_y, -4
	BHV_EXEC @mine_loop
BHV_REPEAT_END
BHV_SET_INT o_intangibility_timer, -1
BHV_SLEEP 27
BHV_DELETE
BHV_END

.definelabel @beh_laser_hitbox, (org() - 0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_SET_INTERACTION INT_DAMAGE
BHV_SET_HITBOX 10, 800, 0
BHV_SET_INT o_collision_damage, 1
BHV_SET_INT o_intangibility_timer, 50
BHV_ADD_FLOAT o_x, -295
BHV_EXEC @laser_init
BHV_LOOP_BEGIN
	BHV_EXEC @laser_loop
BHV_LOOP_END

.definelabel @beh_zap_sfx, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_REPEAT_BEGIN 135
	BHV_EXEC @move_to_mario
	BHV_EXEC @play_zap_sound
BHV_REPEAT_END
BHV_DELETE
BHV_END

.definelabel @beh_sploosh, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_INT o_animation_state, -1
BHV_BILLBOARD
BHV_EXEC @play_sploosh_sound
BHV_REPEAT_BEGIN 8
	BHV_ADD_INT o_animation_state, 1
BHV_REPEAT_END
BHV_DELETE
BHV_END

@attack_permutations:
.word 0x01020304
.word 0x01020403
.word 0x01030204
.word 0x01030402
.word 0x01040203
.word 0x01040302
.word 0x02010304
.word 0x02010403
.word 0x02030104
.word 0x02030401
.word 0x02040103
.word 0x02040301
.word 0x03010204
.word 0x03010402
.word 0x03020104
.word 0x03020401
.word 0x03040102
.word 0x03040201
.word 0x04010203
.word 0x04010302
.word 0x04020103
.word 0x04020301
.word 0x04030102
.word 0x04030201

@attack_table:
.word @atk_bomb, 180
.word @atk_waves, 200
.word @atk_zap, 195
.word @atk_saw, 75
.word @atk_hammer, 210

@boss_init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)
	
	LW S0, g_current_obj_ptr
	
	SETU AT, 75
	SW AT, @_attack_timer (S0)
	
	LI A0, bb_level_22_area_2_Laser__Left__opacity_byte
	JAL segmented_to_virtual
	NOP
	SB R0, 0x0 (V0)
	
	LI A0, bb_level_22_area_2_Laser__Right__opacity_byte
	JAL segmented_to_virtual
	NOP
	SB R0, 0x0 (V0)
	
	LW T0, (global_vars + gv_env_flags)
	ANDI AT, T0, FLAG_WATER_BOSS
	BEQ AT, R0, @@endif_boss_defeated
		SETU AT, 4
		SW AT, o_state (S0)
		B @@return
		SW R0, o_health (S0)
	@@endif_boss_defeated:
	
	MOVE A0, S0
	LI A2, @beh_machine_needle
	JAL spawn_object
	SETU A1, 98
	SW V0, @_needle (S0)
	
	MOVE A0, S0
	LI A2, @beh_left_piston
	JAL spawn_object
	SETU A1, 108
	
	MOVE A0, S0
	LI A2, @beh_right_piston
	JAL spawn_object
	SETU A1, 108
	
	MOVE A0, S0
	LI A2, @beh_machine_flap
	JAL spawn_object
	SETU A1, 99
	SW V0, @_flap (S0)
	
	MOVE A0, S0
	LI A2, @beh_laser_hitbox
	JAL spawn_object
	MOVE A1, R0
	SW V0, @_lasers (S0)
	
	MOVE A0, S0
	LI A2, @beh_machine_zapper
	JAL spawn_object
	SETU A1, 0xC2
	SW V0, @_zapper1 (S0)
	LUI AT, 0xC357
	SW AT, o_x (V0)
	
	MOVE A0, S0
	LI A2, @beh_machine_zapper
	JAL spawn_object
	SETU A1, 0xC2
	SW V0, @_zapper2 (S0)
	LUI AT, 0x4357
	SW AT, o_x (V0)
	
	MOVE A0, S0
	LI A2, @beh_machine_hammer
	JAL spawn_object
	SETU A1, 96
	SW V0, @_hammer (S0)
	
	MOVE A0, R0
	SETU A1, 22
	JAL set_music
	MOVE A2, R0
	
	@@return:
	LW S0, 0x10 (SP)
	LW RA, 0x14 (SP)
	J @shuffle_attack_order
	ADDIU SP, SP, 0x18

@boss_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LI T1, g_mario
	L.S F5, o_z (T0)
	L.S F4, m_z (T1)
	MAX.S F4, F4, F5
	S.S F4, m_z (T1)
	
	LW T1, o_state (T0)
	BNE T1, R0, @@endif_normal
		LI.U A0, beh_bobomb
		JAL get_nearest_object_with_behaviour
		LI.L A0, beh_bobomb
		
		LW T0, g_current_obj_ptr
		BEQ V0, R0, @@done_bobomb_check
			LI.S F6, 400
			LW T1, o_state (V0)
			SETU AT, 3
			BEQ T1, AT, @@valid_action
			SETU AT, 1
			BNE T1, AT, @@done_bobomb_check
			SETU AT, 3
			@@valid_action:
			L.S F5, o_z (T0)
			ADD.S F5, F5, F6
			L.S F4, o_z (V0)
			C.LE.S F4, F5
			NOP
			BC1F @@done_bobomb_check
			SETU AT, 3
			SW AT, o_state (V0)
			SETU AT, 1
			B @@return
			SW AT, o_state (T0)
		@@done_bobomb_check:
	
		LW AT, o_timer (T0)
		LW T1, @_attack_timer (T0)
		SLTU AT, AT, T1
		BNE AT, R0, @@return
		NOP
		JAL @do_attack
		SW R0, o_timer (T0)
		B @@return
		NOP
	@@endif_normal:
	
	SETU AT, 1
	BNE T1, AT, @@endif_waiting_for_bobomb_explosion
		LW AT, o_timer (T0)
		SLTIU AT, AT, 75
		BNE AT, R0, @@endif_timeout_failsafe
		NOP
			B @@return
			SW R0, o_state (T0)
		@@endif_timeout_failsafe:
		
		LI.U A0, beh_explosion
		JAL get_nearest_object_with_behaviour
		LI.L A0, beh_explosion
		
		BEQ V0, R0, @@return
		
		LUI A0, 0x814C
		JAL play_sound
		ORI A0, A0, 0xF081
		
		JAL shake_screen
		SETU A0, 1
		
		LW T0, g_current_obj_ptr
		
		LW AT, o_health (T0)
		ADDIU AT, AT, -1
		SW AT, o_health (T0)
		BNE AT, R0, @@endif_dead
			SETU AT, 3
			SW AT, o_state (T0)
			SETU A0, 60
			SETU A1, 138
			LUI A2, 0x4040
			JAL 0x802AE0CC
			SETU A3, 4
			B @@return
			NOP
		@@endif_dead:
		
		SETU AT, 2
		SW AT, o_state (T0)
		
		LW T1, o_health (T0)
		SETU AT, 2
		BNE T1, AT, @@endif_damaged
			LW T1, @_needle (T0)
			SH R0, @_mean_angle (T1)
			SETU AT, 0x0E39
			SH AT, @_angle_variance (T1)
			JAL 0x802A04C0
			SETU A0, 94
		@@endif_damaged:
		
		LW T1, o_health (T0)
		SETU AT, 1
		BNE T1, AT, @@endif_very_damaged
			LW T1, @_needle (T0)
			SETS AT, 0xD555
			SH AT, @_mean_angle (T1)
			SETU AT, 0x2AAA
			SH AT, @_angle_variance (T1)
			JAL 0x802A04C0
			SETU A0, 95
		@@endif_very_damaged:
		
		LUI A0, 0x814C
		JAL play_sound
		ORI A0, A0, 0xF081
		
		LW A0, g_current_obj_ptr
		LI A2, beh_super_shroom
		JAL spawn_object
		SETU A1, 0xD4
		
		LI.S F4, 75
		B @@return
		S.S F4, o_speed_y (V0)
	@@endif_waiting_for_bobomb_explosion:
	
	SETU AT, 2
	BNE T1, AT, @@endif_took_damage
		LW AT, o_timer (T0)
		SLTIU AT, AT, 75
		BNE AT, R0, @@return
		NOP
		B @@return
		SW R0, o_state (T0)
	@@endif_took_damage:
	
	SETU AT, 3
	BNE T1, AT, @@endif_exploding
		LW AT, o_timer (T0)
		SLTIU AT, AT, 2
		BNE AT, R0, @@return
		LW AT, @_hammer (T0)
		SH R0, o_active_flags (AT)
		LW AT, @_flap (T0)
		SH R0, o_active_flags (AT)
		LW AT, @_zapper1 (T0)
		SH R0, o_active_flags (AT)
		LW AT, @_zapper2 (T0)
		SH R0, o_active_flags (AT)
		LW AT, @_needle (T0)
		SH R0, o_active_flags (AT)
		SH R0, o_active_flags (T0)
		MOVE A0, R0
		SETU A1, 5
		JAL set_music
		MOVE A2, R0
		SETU A0, 1
		SETU A1, 18
		JAL set_music
		MOVE A2, R0
		B @@return
		NOP
	@@endif_exploding:
	
	SETU AT, 4
	BNE T1, AT, @@endif_already_dead
		LW AT, o_timer (T0)
		SLTIU AT, AT, 2
		BNE AT, R0, @@return
		NOP
		SH R0, o_active_flags (T0)
	@@endif_already_dead:
		
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@shuffle_attack_order:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL get_random_short
	NOP

	SETU AT, 24
	DIVU V0, AT
	LI.U T0, @attack_permutations
	MFHI T1
	LI.L T0, @attack_permutations
	SLL AT, T1, 2
	ADDU T0, T0, AT
	LW T1, 0x0 (T0)

	LW T0, g_current_obj_ptr
	SW T1, @_attack_order (T0)

	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@do_attack:
	LW T0, g_current_obj_ptr
	LW T1, @_lasers (T0)
	SETU AT, 1
	SW AT, o_state (T1)
	LW T1, @_attack_order (T0)
	SRL AT, T1, 8
	SW AT, @_attack_order (T0)
	ANDI T1, T1, 0xFF
	SLL T1, T1, 3
	LI T2, @attack_table
	ADDU T1, T2, T1
	LW T2, 0x0 (T1)
	LW AT, 0x4 (T1)
	JR T2
	SW AT, @_attack_timer (T0)

@atk_bomb:
	LW T0, g_current_obj_ptr
	LW T0, @_flap (T0)
	SETU AT, 1
	J @shuffle_attack_order
	SW AT, o_state (T0)

@atk_waves:
	LW A0, g_current_obj_ptr
	LI A2, @beh_wave_spawner
	J spawn_object
	MOVE A1, R0
	
@atk_zap:
	LW T0, g_current_obj_ptr
	LW T1, @_zapper1 (T0)
	LW T2, @_zapper2 (T0)
	SETU AT, 1
	SW AT, o_state (T1)
	SW AT, o_animation_state (T1)
	SW AT, o_state (T2)
	SW AT, o_animation_state (T2)
	MOVE A0, T0
	LI A2, @beh_zap_sfx
	J spawn_object
	MOVE A1, R0
	
@atk_saw:
	LW A0, g_current_obj_ptr
	LI A2, @beh_sawblade
	J spawn_object
	SETU A1, 92
	
@atk_hammer:
	LW T0, g_current_obj_ptr
	LW T0, @_hammer (T0)
	SETU AT, 1
	SW AT, o_state (T0)
	LUI A0, 0x304E
	J play_sound
	ORI A0, A0, 0xC081
	
@mine_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LW AT, o_interaction_status (A0)
	BEQ AT, R0, @@return
	SETU A1, 0xCD
	LI A2, beh_explosion
	JAL spawn_object
	SH R0, o_active_flags (A0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@choose_hammer_position:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL get_random_short
	NOP
	
	ANDI AT, V0, 0x8000
	SW AT, 0x10 (SP)
	
	SETU AT, 3
	ANDI V0, V0, 0x7FFF
	DIVU V0, AT
	
	LI.S F5, 50
	MFHI T1
	LW T0, g_current_obj_ptr
	SLL AT, T1, 1
	MTC1 AT, F4
	LW T1, 0x10 (SP)
	CVT.S.W F4, F4
	
	MUL.S F4, F4, F5
	BEQ T1, R0, @@endif_negate
	ADD.S F4, F4, F5
		NEG.S F4, F4
	@@endif_negate:
	
	S.S F4, @_hammer_target (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@set_water_speed:
	LW T0, (g_mario + m_action)
	LI T1, bbp_9f5317da4fb645b89267ec1bc50d9aad_ACT_VOID_RESPAWN_KNOCKDOWN
	BEQ T0, T1, @@endif_not_spawning
	MOVE T1, R0
		LI T1, float( @WATER_SPEED )
	@@endif_not_spawning:
	LW T0, g_current_obj_ptr
	JR RA
	SW T1, o_speed_z (T0)
	
@move_bombs_and_shrooms:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI.U A0, beh_bobomb
	JAL get_nearest_object_with_behaviour
	LI.L A0, beh_bobomb
	
	BEQ V0, R0, @@endif_bomb_exists
		LI.S F5, @WATER_SPEED
		
		LW AT, o_held_state (V0)
		BNE AT, R0, @@endif_bomb_exists
		
		L.S F4, o_z (V0)
		ADD.S F4, F4, F5
		S.S F4, o_z (V0)
		
		LI.S F5, -2500
		L.S F4, o_y (V0)
		C.LE.S F4, F5
		NOP
		BC1F @@endif_bomb_exists
		NOP
		SH R0, o_active_flags (V0)
	@@endif_bomb_exists:
	
	LI.U A0, beh_super_shroom
	JAL get_nearest_object_with_behaviour
	LI.L A0, beh_super_shroom
	
	BEQ V0, R0, @@endif_shroom_exists
		LI.S F5, @WATER_SPEED
		L.S F4, o_z (V0)
		ADD.S F4, F4, F5
		S.S F4, o_z (V0)
		
		LI.S F5, -2500
		L.S F4, o_y (V0)
		C.LE.S F4, F5
		NOP
		BC1F @@endif_shroom_exists
		NOP
		SH R0, o_active_flags (V0)
	@@endif_shroom_exists:
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@set_water_texture:
	LW T0, g_current_obj_ptr
	LW AT, o_state (T0)
	BEQ AT, R0, @@return
		LW T1, o_timer (T0)
		SLTIU AT, T1, 45
		BNE AT, R0, @@endif_done_flashing
		ANDI AT, T1, 0x1
			B @reset_water_texture
			SW R0, o_state (T0)
		@@endif_done_flashing:
		BEQ AT, R0, @reset_water_texture
		LI.U A0, bb_level_22_area_2_Water_2_texture_data
		B @change_water_texture
		LI.L A0, bb_level_22_area_2_Water_2_texture_data
	@@return:
	JR RA
	NOP
	
@reset_water_texture:
	LI.U A0, bb_level_22_area_2_Water_texture_data
	B @change_water_texture
	LI.L A0, bb_level_22_area_2_Water_texture_data
	
@change_water_texture:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW A0, 0x10 (SP)
	
	LI.U A0, bb_level_22_area_2_Water_texture_pointer
	JAL segmented_to_virtual
	LI.L A0, bb_level_22_area_2_Water_texture_pointer
	
	LW A0, 0x10 (SP)
	SW A0, 0x0 (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@spawn_wave:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LW A0, g_current_obj_ptr
	LI A2, @beh_wave
	JAL spawn_object
	SETU A1, 97
	
	LW T0, g_current_obj_ptr
	LW T1, @_wave_count (T0)
	ADDIU T1, T1, 1
	SW T1, @_wave_count (T0)
	
	SETU AT, 4
	BNE T1, AT, @@endif_big_wave
		LI.S F5, 100
		LUI AT, 0x4000
		SW AT, o_scale_y (V0)
		SW AT, o_scale_z (V0)
		L.S F4, o_z (V0)
		SUB.S F4, F4, F5
		S.S F4, o_z (V0)
	@@endif_big_wave:
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@electric_water_loop:
	LI.S F5, 1140
	L.S F4, (g_mario + m_z)
	C.LT.S F4, F5
	LW T0, g_current_obj_ptr
	BC1F @@endif_out_of_range
	SETU AT, 1
		MOVE AT, R0
	@@endif_out_of_range:
	SW AT, o_intangibility_timer (T0)
	LW AT, o_interaction_status (T0)
	BEQ AT, R0, @@return
	NOP
		SH R0, o_active_flags (T0)
	@@return:
	JR RA
	NOP
	
@needle_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LW AT, o_timer (T0)
	ANDI AT, AT, 3
	BNE AT, R0, @@endif_new_target
	NOP
		JAL get_random_float
		NOP
		LI.S F5, 0.5
		LW T0, g_current_obj_ptr
		LHU AT, @_angle_variance (T0)
		MTC1 AT, F4
		SUB.S F0, F0, F5
		CVT.S.W F4, F4
		MUL.S F4, F0, F4
		CVT.W.S F4, F4
		MFC1 T1, F4
		LH AT, @_mean_angle (T0)
		ADDU T1, AT, T1
		LW AT, o_face_angle_roll (T0)
		SUBU AT, T1, AT
		SRA AT, AT, 2
		SW AT, o_angle_vel_roll (T0)
	@@endif_new_target:
	
	LW T1, o_face_angle_roll (T0)
	LW AT, o_angle_vel_roll (T0)
	ADDU T1, T1, AT
	SW T1, o_face_angle_roll (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@laser_init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI A0, bb_level_22_area_2_Laser__Left__opacity_byte
	JAL segmented_to_virtual
	NOP
	SETU AT, 0x40
	SB AT, 0x0 (V0)
	LW T0, g_current_obj_ptr
	SW V0, @_opacity_ptr_active (T0)
	
	LI A0, bb_level_22_area_2_Laser__Right__opacity_byte
	JAL segmented_to_virtual
	NOP
	LW T0, g_current_obj_ptr
	SW V0, @_opacity_ptr_other (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@laser_loop:
	LW T0, g_current_obj_ptr
	
	LW AT, o_parent (T0)
	LW AT, o_health (AT)
	BNE AT, R0, @@endif_fight_done
		LW AT, @_opacity_ptr_active (T0)
		SB R0, 0x0 (AT)
		B @@return
		SH R0, o_active_flags (T0)
	@@endif_fight_done:
	
	LW AT, o_state (T0)
	BEQ AT, R0, @@endif_swap
		LW T1, @_opacity_ptr_active (T0)
		LW T2, @_opacity_ptr_other (T0)
		SW T2, @_opacity_ptr_active (T0)
		SW T1, @_opacity_ptr_other (T0)
		SB R0, 0x0 (T1)
		SETU AT, 0x40
		SB AT, 0x0 (T2)
		SETU AT, 50
		SW AT, o_intangibility_timer (T0)
		SW R0, o_state (T0)
		L.S F4, o_x (T0)
		NEG.S F4, F4
		S.S F4, o_x (T0)
	@@endif_swap:
	
	LW T1, o_intangibility_timer (T0)
	SETU AT, 1
	BNE T1, AT, @@endif_fully_activate
		LW T1, @_opacity_ptr_active (T0)
		SETU AT, 0xC0
		SB AT, 0x0 (T1)
	@@endif_fully_activate:
	
	LW T1, (g_mario + m_z)
	SW T1, o_z (T0)
	
	@@return:
	JR RA
	SW R0, o_interaction_status (T0)
	
@require_parent_alive:
	LW T0, g_current_obj_ptr
	LW AT, o_parent (T0)
	LW AT, o_health (AT)
	BNE AT, R0, @@endif_dead
	NOP
		SH R0, o_active_flags (T0)
	@@endif_dead:
	JR RA
	NOP
	
@zapper_loop:
	LW T0, g_current_obj_ptr
	LW T1, o_state (T0)
	LW T2, o_timer (T0)
	
	BEQ T1, R0, @@return
	SETU AT, 1
	BNE T1, AT, @@endif_activating
		SLTIU AT, T2, 60
		BNE AT, R0, @@return
		SETU AT, 2
		B @@return
		SW AT, o_state (T0)
	@@endif_activating:
	SETU AT, 2
	BNE T1, AT, @@endif_lowering
		LI.S F5, 1.5
		L.S F4, o_y (T0)
		SUB.S F4, F4, F5
		S.S F4, o_y (T0)
		SLTIU AT, T2, 30
		BNE AT, R0, @@return
			SETU AT, 3
			SW AT, o_state (T0)
			J @@electrify_water
			MOVE A0, T0
	@@endif_lowering:
	SETU AT, 3
	BNE T1, AT, @@endif_lowered
		SLTIU AT, T2, 45
		BNE AT, R0, @@return
		SETU AT, 4
		B @@return
		SW AT, o_state (T0)
	@@endif_lowered:
	SETU AT, 4
	BNE T1, AT, @@endif_raising
		SLTIU AT, T2, 30
		BNE AT, R0, @@endif_at_top
		NOP
			SW R0, o_state (T0)
			SW R0, o_animation_state (T0)
		@@endif_at_top:
		LI.S F5, 1.5
		L.S F4, o_y (T0)
		ADD.S F4, F4, F5
		B @@return
		S.S F4, o_y (T0)
	@@endif_raising:
	
	@@return:
	JR RA
	NOP

@@electrify_water:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI A2, @electified_water_hitbox
	JAL spawn_object
	MOVE A1, R0
	
	LI.U A0, beh_machine_boss_floor
	JAL get_nearest_object_with_behaviour
	LI.L A0, beh_machine_boss_floor
	
	SETU AT, 1
	SW AT, o_state (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@move_to_mario:
	LW T0, g_current_obj_ptr
	LI A0, (g_mario + m_position)
	J copy_vector
	ADDIU A1, T0, o_position
	
@play_zap_sound:
	LUI A0, 0x6003
	J play_sound
	ORI A0, A0, 0x4001

@hammer_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LW T1, o_state (T0)
	BEQ T1, R0, @@return
	
	SETU AT, 1
	BNE T1, AT, @@endif_extending
		LW AT, o_timer (T0)
		SLTIU AT, AT, 30
		BNE AT, R0, @@endif_extended
			SETU AT, 2
			SW AT, o_state (T0)
			JAL @choose_hammer_position
			SW R0, @_slam_count (T0)
			B @@return
		@@endif_extended:
		LI.S F5, 9
		L.S F4, o_z (T0)
		ADD.S F4, F4, F5
		B @@return
		S.S F4, o_z (T0)
	@@endif_extending:
	
	SETU AT, 2
	BNE T1, AT, @@endif_attacking
		LW AT, o_timer (T0)
		SLTIU AT, AT, 15
		BNE AT, R0, @@return
		
		LUI A0, 0x1D19
		JAL play_sound
		ORI A0, A0, 0x2001
	
		LW T0, g_current_obj_ptr
		
		ADDIU A0, T0, o_x
		LW A1, @_hammer_target (T0)
		JAL 0x802899CC
		LUI A2, 0x4100
		
		BNE V0, R0, @@return
		
		LW A0, g_current_obj_ptr
		LI A2, @beh_shockwave
		JAL spawn_object
		MOVE A1, R0
		
		LW T0, g_current_obj_ptr
		LW AT, @_slam_count (T0)
		ADDIU AT, AT, 1
		SW AT, @_slam_count (T0)
		
		SLTIU AT, AT, 3
		BNE AT, R0, @@endif_done_attacks
			SETU AT, 3
			SW AT, o_state (T0)
			LUI A0, 0x304F
			JAL play_sound
			ORI A0, A0, 0xC081
			B @@return
			NOP
		@@endif_done_attacks:
		
		JAL @choose_hammer_position
		SW R0, o_timer (T0)
		
		B @@return
		NOP
	@@endif_attacking:
	
	SETU AT, 3
	BNE T1, AT, @@endif_retracting
		LW AT, o_timer (T0)
		SLTIU AT, AT, 30
		BNE AT, R0, @@endif_retracted
		NOP
			B @@return
			SW R0, o_state (T0)
		@@endif_retracted:
		LI.S F5, 9
		L.S F4, o_z (T0)
		SUB.S F4, F4, F5
		B @@return
		S.S F4, o_z (T0)
	@@endif_retracting:
		
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@play_sploosh_sound:
	LUI A0, 0x5029
	J play_sound
	ORI A0, A0, 0xA081
	
@play_sawblade_sound:
	LUI A0, 0x4018
	J play_sound
	ORI A0, A0, 0x1001

@flap_loop:
	LW T0, g_current_obj_ptr
	LW T1, o_state (T0)
	
	BEQ T1, R0, @@return
	LW T2, o_timer (T0)
	
	SETU AT, 1
	BNE T1, AT, @@endif_opening
		LW AT, o_face_angle_pitch (T0)
		ADDIU AT, AT, 0xFC00
		SW AT, o_face_angle_pitch (T0)
		SLTIU AT, T2, 15
		BNE AT, R0, @@return
		SETU AT, 2
		SW AT, o_state (T0)
		LW AT, @_spawn_count (T0)
		ADDIU AT, AT, 1
		SW AT, @_spawn_count (T0)
		ANDI AT, AT, 0x1
		BEQ AT, R0, @@endif_spawn_bobomb
		NOP
			J @spawn_bobomb
			NOP
		@@endif_spawn_bobomb:
		LI A2, @beh_mine
		SETU A1, 51
		J spawn_object
		MOVE A0, T0
	@@endif_opening:
	
	SETU AT, 2
	BNE T1, AT, @@endif_open
		SLTIU AT, T2, 20
		BNE AT, R0, @@return
		SETU AT, 3
		B @@return
		SW AT, o_state (T0)
	@@endif_open:
	
	SETU AT, 3
	BNE T1, AT, @@endif_closing
	LW AT, o_face_angle_pitch (T0)
		ADDIU AT, AT, 0x400
		SW AT, o_face_angle_pitch (T0)
		SLTIU AT, T2, 15
		BNE AT, R0, @@return
		NOP
		SW R0, o_state (T0)
	@@endif_closing:
	
	@@return:
	JR RA
	NOP

@spawn_bobomb:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LI A2, beh_bobomb
	JAL spawn_object
	SETU A1, 0xBC
	
	SETU AT, 1
	SB AT, o_arg3 (V0)
	
	LI.S F5, 150
	L.S F4, o_z (V0)
	ADD.S F4, F4, F5
	S.S F4, o_z (V0)
	
	SW R0, o_face_angle_pitch (V0)
	SW R0, o_y (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@set_wave_tangibility:
	LW T0, (g_mario + m_action)
	LI T1, bbp_9f5317da4fb645b89267ec1bc50d9aad_ACT_VOID_RESPAWN_KNOCKDOWN
	SETS T1, -1
	BEQ T0, T1, @@endif_not_spawning
	MOVE T2, R0
		MOVE T1, R0
		LUI T2, 0x43B0
	@@endif_not_spawning:
	LW T0, g_current_obj_ptr
	SW T1, o_intangibility_timer (T0)
	JR RA
	SW T2, o_collision_distance (T0)
