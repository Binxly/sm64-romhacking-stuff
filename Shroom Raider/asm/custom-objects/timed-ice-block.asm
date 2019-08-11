@_collision_distance equ 0xF4

.definelabel beh_timed_ice_block_impl, (org()-0x80000000)
;BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_INT o_opacity, 0xBF
BHV_SET_COLLISION ice_block_collision
BHV_SET_FLOAT @_collision_distance, 528
BHV_SET_FLOAT o_render_distance, 10000
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

.definelabel beh_timed_big_ice_block_impl, (org()-0x80000000)
;BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_INT o_opacity, 0xBF
BHV_SET_COLLISION big_ice_block_collision
BHV_SET_FLOAT @_collision_distance, 1510
BHV_SET_FLOAT o_render_distance, 10000
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LI A0, 0x13001478
JAL get_nearest_object_with_behaviour
NOP

BEQ V0, R0, @loop_inactive
NOP

LW T0, o_state (V0)
SETU AT, 0x2
BEQ T0, AT, @loop_active
NOP

@loop_inactive:
LW T0, g_current_obj_ptr
SW R0, o_collision_distance (T0)
LHU T1, o_gfx_flags (T0)
ORI T1, T1, 0x10
B @return
SH T1, o_gfx_flags (T0)

@loop_active:
LW T0, g_current_obj_ptr
LW AT, @_collision_distance (T0)
SW AT, o_collision_distance (T0)
LHU T1, o_gfx_flags (T0)
ANDI T1, T1, 0xFFEF
JAL process_collision
SH T1, o_gfx_flags (T0)

@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
