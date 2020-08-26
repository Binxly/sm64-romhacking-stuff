beh_bamboo_spawner_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_SET_INT 0xF4, 0
BHV_LOOP_BEGIN
	BHV_EXEC @spawner_loop
BHV_LOOP_END

.definelabel @beh_bamboo, (org() - 0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_INTERACTION INT_SOLID
BHV_SET_HITBOX 25, 4096, 0
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_FLOAT o_render_distance, 5000
; TODO: despawn if too close to another bamboo shoot
BHV_LOOP_BEGIN
	BHV_EXEC @despawn_check
	BHV_EXEC horizontally_billboard
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

@total_bamboo:
.halfword 0
@freed_bamboo:
.halfword 0

manage_bamboo:
	LHU T0, g_level_num
	LI T1, @total_bamboo
	SETU AT, 0x17
	BNE T0, AT, @@endif_in_forest
		LHU T2, 0x0 (T1)
		LHU AT, 0x2 (T1)
		SUBU T2, T2, AT
		SH T2, 0x0 (T1)
		B @@return
		SH R0, 0x2 (T1)
	@@endif_in_forest:
	SW R0, 0x0 (T1)
	
	@@return:
	JR RA
	NOP
	
@_num_children equ 0xF4
@_in_range equ 0xF5

@MAX_CHILDREN equ 20

@spawner_loop:
	LI.S F6, 7500
	LW T0, g_current_obj_ptr
	LI T1, g_mario
	
	L.S F4, o_x (T0)
	L.S F5, m_x (T1)
	SUB.S F4, F5, F4
	ABS.S F4, F4
	C.LT.S F4, F6
	L.S F4, o_z (T0)
	BC1F @far
	L.S F5, m_z (T1)
	SUB.S F4, F5, F4
	ABS.S F4, F4
	C.LT.S F4, F6
	NOP
	BC1F @far
	
	; near
	SETU AT, 1
	J @spawn_bamboo
	SB AT, @_in_range (T0)
	
	@far:
	JR RA
	SB R0, @_in_range (T0)
	
@spawn_bamboo:
	ADDIU SP, SP, 0xFFE0
	SW RA, 0x1C (SP)
	SW S0, 0x18 (SP)
	SW S1, 0x14 (SP)
	
	MOVE S0, T0
	LHU S1, @total_bamboo
	
	@@loop:
	LBU AT, @_num_children (S0)
	SLTIU AT, AT, @MAX_CHILDREN
	BEQ AT, R0, @@return
	SLTIU AT, S1, 180
	BEQ AT, R0, @@return
		MOVE A0, S0
		LI A2, @beh_bamboo
		JAL spawn_object
		SETU A1, 26
		
		ADDIU S1, S1, 1
	
		JAL @random_translate
		MOVE A0, V0
		
		LBU AT, @_num_children (S0)
		ADDIU AT, AT, 1
		B @@loop
		SB AT, @_num_children (S0)
	
	@@return:
	SH S1, @total_bamboo
	LW S1, 0x14 (SP)
	LW S0, 0x18 (SP)
	LW RA, 0x1C (SP)
	JR RA
	ADDIU SP, SP, 0x20
	
@random_translate:
	ADDIU SP, SP, 0xFFE0
	SW RA, 0x1C (SP)
	SW A0, 0x18 (SP)
	
	LI T0, float( 0.5 )
	SW T0, 0x14 (SP)
	
	LI T0, float( 4950 )
	SW T0, 0x10 (SP)
	
	JAL get_random_float
	NOP
	L.S F5, 0x14 (SP)
	SUB.S F0, F0, F5
	L.S F4, 0x10 (SP)
	MUL.S F5, F4, F0
	LW T0, 0x18 (SP)
	L.S F4, o_x (T0)
	ADD.S F4, F4, F5
	S.S F4, o_x (T0)
	
	JAL get_random_float
	NOP
	L.S F5, 0x14 (SP)
	SUB.S F0, F0, F5
	L.S F4, 0x10 (SP)
	MUL.S F5, F4, F0
	LW T0, 0x18 (SP)
	L.S F4, o_z (T0)
	ADD.S F4, F4, F5
	S.S F4, o_z (T0)
	
	LW RA, 0x1C (SP)
	JR RA
	ADDIU SP, SP, 0x20
	
	
@despawn_check:
	LW T0, g_current_obj_ptr
	LHU T2, 0x8033B252
	SETU AT, 0x13
	BNE T2, AT, @@endif_reset
	LHU T2, 0x8033B254
	SETU AT, 1
	BEQ T2, AT, @@despawn
	@@endif_reset:
	LW T1, o_parent (T0)
	LBU AT, @_in_range (T1)
	BNE AT, R0, @@return
	@@despawn:
	LBU AT, @_num_children (T1)
	ADDIU AT, AT, -1
	SB AT, @_num_children (T1)
	SH R0, o_active_flags (T0)
	LHU T1, @freed_bamboo
	ADDIU T1, T1, 1
	SH T1, @freed_bamboo
	@@return:
	JR RA
	NOP
	
