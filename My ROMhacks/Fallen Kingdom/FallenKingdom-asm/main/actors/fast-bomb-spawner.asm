beh_fast_bomb_spawner_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_EXEC @init
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@_child equ 0xF4
@_offscreen_timer equ 0xF8

@init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW A0, g_current_obj_ptr
	LI A2, beh_bobomb
	JAL spawn_object
	SETU A1, 0xBC
	
	LW T0, g_current_obj_ptr
	SW V0, @_child (T0)
	
	SETU AT, 1
	SB AT, o_arg3 (V0)
	
	SW R0, @_offscreen_timer (T0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
@loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LW T0, g_current_obj_ptr
	LW T1, @_child (T0)
	
	LW AT, @_offscreen_timer (T0)
	SW AT, 0x10 (SP)
	SW R0, @_offscreen_timer (T0)
	
	LHU AT, o_active_flags (T1)
	ANDI AT, AT, 0x1
	BEQ AT, R0, @@check_bomb_count
	
	LW AT, o_parent (T1)
	BEQ AT, T0, @@return
	
	@@check_bomb_count:
	LI T2, global_vars
	LBU AT, gv_items (T2)
	ANDI AT, AT, ITEM_BOMBS
	BEQ AT, R0, @@check_for_explosions
	
	LBU AT, gv_bombs (T2)
	SLTIU AT, AT, 9
	BEQ AT, R0, @@return
	NOP
	
	@@check_for_explosions:
	LI.U A0, beh_explosion
	JAL get_nearest_object_with_behaviour
	LI.L A0, beh_explosion
	
	BEQ V0, R0, @@check_offscreen
	LW A0, g_current_obj_ptr
	JAL get_dist_2d
	MOVE A1, V0
	
	LI.S F4, 215
	NOP
	C.LE.S F0, F4
	NOP
	BC1T @@return
	NOP
	
	@@check_offscreen:
	LW T0, g_current_obj_ptr
	JAL perspective_transform_2
	ADDIU A0, T0, o_position
	
	SLT AT, V0, R0
	BEQ AT, R0, @@return
	
	LW T0, g_current_obj_ptr
	LW T1, 0x10 (SP)
	ADDIU T1, T1, 1
	SLTIU AT, T1, 30
	BNE AT, R0, @@return
	SW T1, @_offscreen_timer (T0)
	
	SW R0, @_offscreen_timer (T0)
	
	MOVE A0, T0
	LI A2, beh_bobomb
	JAL spawn_object
	SETU A1, 0xBC
	
	SETU AT, 1
	SB AT, o_arg3 (V0)
	
	LW T0, g_current_obj_ptr
	SW V0, @_child (T0)
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
