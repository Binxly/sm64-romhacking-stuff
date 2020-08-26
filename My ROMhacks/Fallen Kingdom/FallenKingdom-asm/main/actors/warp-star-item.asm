beh_warp_star_item_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_INTERACTION INT_COIN
BHV_SET_INT o_collision_damage, 0
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_HITBOX 100, 100, 0
BHV_SET_FLOAT o_render_distance, 0x7FFF
BHV_EXEC @check_inventory
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC @sparkle
	BHV_ADD_INT o_face_angle_yaw, 0x100
BHV_LOOP_END

@check_inventory:
	LBU T0, (global_vars + gv_items)
	ANDI T0, T0, ITEM_STAR
	BEQ T0, R0, @@return
		LW T0, g_current_obj_ptr
		SH R0, o_active_flags (T0)
	@@return:
	JR RA
	NOP

@loop:
	LW A0, g_current_obj_ptr
	LW AT, o_interaction_status (A0)
	BEQ AT, R0, @@return
	NOP
		J @spawn_item
		SH R0, o_active_flags (A0)
	@@return:
	JR RA
	NOP

@spawn_item:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	LI A2, beh_item
	JAL spawn_object
	SETU A1, 26
	
	LI T0, (ITEM_STAR << 24) | (26 << 16) | (26 << 8) | 46
	SW T0, o_arg0 (V0)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@sparkle:
	LW A0, g_current_obj_ptr
	LW AT, o_timer (A0)
	ANDI AT, AT, 0x4
	BEQ AT, R0, @@return
	LI A2, 0x13002AF0
	J spawn_object
	SETU A1, 0x8F
	@@return:
	JR RA
	NOP
