.definelabel beh_icicle_impl, (org()-0x80000000)
;BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_INT 0x180, 2
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_HITBOX 50, 150, 0
BHV_SET_INTERACTION 0x8
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr
LW T0, o_state (S0)
BNE T0, R0, @falling
	LW A1, g_mario_obj_ptr
	JAL get_dist_2d
	MOVE A0, S0
	LUI AT, 0x4348
	MTC1 AT, F4
	LUI A0, 0x5
	C.LE.S F0, F4
	ORI A0, A0, 0xC081
	BC1F @return
	SETU AT, 0x1
	JAL play_sound
	SW AT, o_state (S0)
@falling:
LUI AT, 0x4080
MTC1 AT, F5
L.S F4, o_speed_y (S0)
SUB.S F4, F4, F5
JAL obj_update_floor_and_walls
S.S F4, o_speed_y (S0)
L.S F4, o_speed_y (S0)
L.S F5, o_y (S0)
ADD.S F5, F5, F4
L.S F6, o_floor_height (S0)
C.LE.S F5, F6
S.S F5, o_y (S0)
BC1F @return
LUI A0, 0x258
JAL play_sound
ORI A0, A0, 0xC081
LI.U A0, @ice_shards
JAL spawn_particles
LI.L A0, @ice_shards
JAL mark_object_for_deletion
MOVE A0, S0
@return:
SW R0, o_interaction_status (S0)
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@ice_shards:
.byte 0 ; behaviour argument
.byte 3 ; # of particles
.byte 72 ; model
.byte 50 ; vertical offset
.byte 8 ; base hvel
.byte 3 ; random hvel
.byte 27 ; base vvel
.byte 15 ; random vvel
.byte -4 ; gravity
.byte 0 ; drag
.align 4
.word float( 4 ) ; base size
.word float( 4 ) ; random size
