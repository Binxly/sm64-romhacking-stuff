beh_barrel_1_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_SET_COLLISION bb_level_22_object_Barrel_collision
BHV_JUMP @beh_barrel_common

beh_barrel_2_impl:
; BHV_START OBJ_LIST_SURFACE
BHV_SET_COLLISION bb_level_8_object_Barrel_collision
BHV_JUMP @beh_barrel_common

.definelabel @beh_barrel_common, (org() - 0x80000000)
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_INTERACTION INT_BREAKABLE
BHV_SET_HITBOX 100, 150, 0
BHV_SET_INT o_health, 1
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_INT o_num_loot_coins, 0
BHV_SET_FLOAT o_collision_distance, 200
BHV_EXEC @barrel_init
BHV_LOOP_BEGIN
	BHV_EXEC @barrel_loop
	BHV_EXEC process_collision
BHV_LOOP_END

@barrel_init:
	LW T0, g_current_obj_ptr
	LBU AT, o_arg1 (T0)
	BNE AT, R0, @@endif_default
	LUI T1, 0x447A
		SETU AT, 66
	@@endif_default:
	MTC1 AT, F4
	MTC1 T1, F5
	CVT.S.W F4, F4
	MUL.S F4, F4, F5
	S.S F4, o_render_distance (T0)
	LBU T1, o_arg0 (T0)
	SETU AT, 4
	BNE T1, AT, @@endif_blocking_barrel
		LW T1, (global_vars + gv_env_flags)
		ANDI AT, T1, FLAG_WATER_DOOR_UNBLOCKED
		BNE AT, R0, @unblock_door
		NOP
	@@endif_blocking_barrel:
	JR RA
	NOP

@barrel_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	JAL obj_was_attacked
	NOP
	
	BEQ V0, R0, @@return
	
	LUI A0, 0x3041
	JAL create_sound_spawner
	ORI A0, A0, 0xC081

	LI.S F12, 46
	JAL 0x802A4440
	MOVE A1, R0
	
	LW A0, g_current_obj_ptr
	LBU T0, o_arg0 (A0)
	BEQ T0, R0, @@return
	
	LI T1, (@loot_table-0x10)
	SLL T0, T0, 4
	ADDU T0, T1, T0
	
	LW AT, 0x8 (T0)
	SW AT, 0x10 (SP)
	
	LW A1, 0x4 (T0)
	JAL spawn_object
	LW A2, 0x0 (T0)
	
	LW AT, 0x10 (SP)
	SW AT, o_arg0 (V0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@unblock_door:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI T0, global_vars
	LW AT, gv_env_flags (T0)
	ORI AT, AT, FLAG_WATER_DOOR_UNBLOCKED
	SW AT, gv_env_flags (T0)
	
	JAL save_game
	NOP
	
	LUI A0, 0x1300
	JAL get_nearest_object_with_behaviour
	ORI A0, A0, 0x0B0C
	
	SB R0, o_arg0 (V0)
	
	LW T0, g_current_obj_ptr
	SH R0, o_active_flags (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@loot_table:
.word beh_super_shroom, 0xD4, 0x00000000, 0
.word beh_ultra_shroom, 0xD4, 0x00000000, 0
.word beh_bobomb, 0xBC, 0x00000001, 0
.word @beh_unblock_door, 0, 0, 0

.definelabel @beh_unblock_door, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_EXEC @unblock_door
BHV_END
