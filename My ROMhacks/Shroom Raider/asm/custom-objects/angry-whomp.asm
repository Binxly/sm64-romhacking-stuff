.definelabel beh_angry_whomp, (org()-0x80000000)
BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_FLOAT o_render_distance, 7000
BHV_ADD_FLOAT o_y, 1000
BHV_SET_WORD o_state, @action_fall
BHV_SET_COLLISION angry_whomp_collision
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_EXEC process_collision
BHV_LOOP_END

@loop:
LW T0, g_current_obj_ptr
LW T0, o_state (T0)
JR T0
NOP

@action_fall:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LW T0, g_current_obj_ptr
	LUI AT, 0x428C
	MTC1 AT, F5
	L.S F4, o_y (T0)
	SUB.S F4, F4, F5
	S.S F4, o_y (T0)

	JAL 0x802A064C
	NOP
	LW T0, g_current_obj_ptr
	L.S F4, o_y (T0)
	L.S F5, o_floor_height (T0)
	LUI AT, 0x43AF
	MTC1 AT, F6
	LUI AT, 0x3F80
	MTC1 AT, F7
	MTC1 R0, F8
	SUB.S F4, F4, F5
	DIV.S F6, F4, F6
	C.LE.S F4, F8
	LW T1, o_parent (T0)
	BC1T @@hit_ground
	C.LT.S F6, F7
	NOP
	BC1F @@return
	NOP
	B @@return
	S.S F6, o_scale_y (T1)
	@@hit_ground:
	S.S F5, o_y (T0)
	JAL despawn_snowgre
	MOVE A0, T1
	JAL shake_screen
	SETU A0, 1
	LUI A0, 0x905A
	JAL play_sound
	ORI A0, A0, 0xC081
	LUI A0, 0x302F
	JAL play_sound
	ORI A0, A0, 0xC081
	LW T0, g_current_obj_ptr
	LI T1, @action_wait
	SW T1, o_state (T0)
	SW R0, o_timer (T0)
	SETU A0, 0x0
	SETU A1, 0x23
	JAL set_music
	MOVE A2, R0
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@action_wait:
	LW T0, g_current_obj_ptr
	LW T1, o_timer (T0)
	SLTI AT, T1, 30
	BNE AT, R0, @@return
	LI T1, @action_talk
	SW T1, o_state (T0)
	SETU T0, 0x1
	SW T0, g_cutscene_finished
	SW R0, g_timestop_flags
	J reset_camera
	NOP
	@@return:
	JR RA
	NOP

@action_talk:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	SETU A0, 0x2
	SETU A1, 0x1
	SETU A2, 0xA2
	JAL obj_show_dialog
	SETU A3, 0x48
	BEQ V0, R0, @@return
	LW T0, g_current_obj_ptr
	LI T1, @action_rest
	SW T1, o_state (T0)
	LI T1, g_mario
	SETU AT, 76
	SB AT, m_heal_counter (T1)
	LI A2, beh_springy_cloud
	SETU A1, 0x46
	JAL spawn_object
	MOVE A0, T0
	LUI AT, 0xC56A
	SW AT, o_x (V0)
	LUI AT, 0x4593
	SW AT, o_y (V0)
	LUI AT, 0x44B5
	SW AT, o_z (V0)

	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@action_rest:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	JAL 0x802A3754
	NOP
	BEQ V0, R0, @@return
	LUI A0, 0x905A
	JAL play_sound
	ORI A0, A0, 0xC001
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
