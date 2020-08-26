.definelabel beh_chest_common, (org() - 0x80000000)
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_INTERACTION INT_SOLID
BHV_SET_HITBOX 125, 50, 0
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_EXEC @chest_init
BHV_LOOP_BEGIN
	BHV_EXEC @chest_loop
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

.definelabel @beh_chest_lid, (org() - 0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_STORE_HOME
BHV_LOOP_BEGIN
	BHV_EXEC @chest_lid_loop
BHV_LOOP_END

oChest_isLootedFunc equ 0xF4
oChest_lootBehaviour equ 0xF8
oChest_lootModel equ 0xFC
@_lid equ 0x100

@chest_init:
	ADDIU SP, SP, 0xFFE0
	SW RA, 0x1C (SP)

	MOVE A0, R0
	MOVE A1, R0
	SETU A2, 102
	SETU A3, -77
	LW T0, g_current_obj_ptr
	SW T0, 0x10 (SP)
	SETU AT, 0x66
	SW AT, 0x14 (SP)
	LI T0, @beh_chest_lid
	JAL 0x8029EF64
	SW T0, 0x18 (SP)
	
	LW T0, g_current_obj_ptr
	SW V0, @_lid (T0)
	
	LW T0, oChest_isLootedFunc (T0)
	JALR T0
	NOP
	
	BEQ V0, R0, @@endif_looted
		LW T0, g_current_obj_ptr
		SETU AT, 1
		SW AT, o_state (T0)
		LW T0, @_lid (T0)
		SETS AT, 0xC000
		SW AT, o_face_angle_pitch (T0)
	@@endif_looted:
	
	LW RA, 0x1C (SP)
	JR RA
	ADDIU SP, SP, 0x20
	
@chest_loop:
	LW T0, g_current_obj_ptr
	LW AT, o_state (T0)
	BNE AT, R0, @@return
	LI.S F5, 500
	L.S F4, o_distance_to_mario (T0)
	C.LT.S F4, F5
	LW T1, @_lid (T0)
	BC1F @@return
	SETU AT, 1
	SW AT, o_state (T0)
	SW AT, o_state (T1)
	LUI A0, 0x3120
	J play_sound
	ORI A0, A0, 0x8081
	@@return:
	JR RA
	NOP
	
@chest_lid_loop:
	LW A0, g_current_obj_ptr
	LW AT, o_state (A0)
	BEQ AT, R0, @@return
	
	LW AT, o_face_angle_pitch (A0)
	ADDIU AT, AT, 0xFE00
	SW AT, o_face_angle_pitch (A0)
	SLTI AT, AT, 0xC001
	BNE AT, R0, @@spawn_loot
	NOP
	@@return:
	JR RA
	NOP
	
	@@spawn_loot:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	SW R0, o_state (A0)
	
	LW T0, o_parent (A0)
	LW AT, o_arg0 (T0)
	SW AT, 0x10 (SP)
	
	LW A1, oChest_lootModel (T0)
	JAL spawn_object
	LW A2, oChest_lootBehaviour (T0)
	
	LW AT, 0x10 (SP)
	SW AT, o_arg0 (V0)
	SW R0, o_face_angle_pitch (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

.include "./key-chest.asm"
;.include "./item-chest.asm"
