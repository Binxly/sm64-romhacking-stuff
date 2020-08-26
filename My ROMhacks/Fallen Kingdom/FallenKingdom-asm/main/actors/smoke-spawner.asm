beh_smoke_spawner_impl:
; BHV_START OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_LOOP_BEGIN
	BHV_EXEC @random_spawn
BHV_LOOP_END

beh_fire_impl:
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_SET_FLOAT o_render_distance, 10000
BHV_SET_INTERACTION INT_FLAME
BHV_SET_HITBOX 75, 125, 0
BHV_SET_FLOAT o_gfx_y_offset, 25
BHV_SET_INT o_intangibility_timer, 0
BHV_SPAWN_OBJECT 0, beh_smoke_spawner, 0
BHV_BILLBOARD
BHV_SCALE 500
BHV_LOOP_BEGIN
	BHV_ADD_INT o_animation_state, 1
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

.definelabel @beh_smoke, (org() - 0x80000000)
BHV_START OBJ_LIST_PARTICLES
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_BILLBOARD
BHV_SET_FLOAT o_render_distance, 10000
BHV_SET_INT o_animation_state, 4
BHV_SET_FLOAT o_gfx_y_offset, 50
BHV_SCALE 200
BHV_ADD_FLOAT o_y, -100
BHV_REPEAT_BEGIN 90
	BHV_ADD_FLOAT o_y, 12
BHV_REPEAT_END
BHV_DELETE
BHV_END

@random_spawn:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LW T0, g_current_obj_ptr
LW AT, o_state (T0)
BNE AT, R0, @@endif_set_timer
NOP
	JAL get_random_short
	NOP
	LW T0, g_current_obj_ptr
	ANDI V0, V0, 0x1F
	SETU AT, 16
	ADDU AT, V0, AT
	SW AT, 0xF4 (T0)
	SETU AT, 1
	B @@return
	SW AT, o_state (T0)
@@endif_set_timer:

LW T1, o_timer (T0)
LW AT, 0xF4 (T0)
SLTU AT, T1, AT
BNE AT, R0, @@return
MOVE A0, T0
	SW R0, o_state (T0)
	LI A2, @beh_smoke
	JAL spawn_object
	SETU A1, 0x94
	
@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
