.definelabel beh_snow_patch_impl, (org()-0x80000000)
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_FLOAT o_render_distance, 6500
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr
LI T0, g_mario
L.S F4, o_y (S0)
L.S F5, m_y (T0)
LUI AT, 0x40A0
SUB.S F4, F4, F5
MTC1 AT, F5
ABS.S F4, F4
C.LT.S F4, F5
LW A1, g_mario_obj_ptr
BC1F @return
MOVE A0, S0
JAL get_dist_2d
NOP
LUI AT, 0x4300
MTC1 AT, F4
NOP
C.LE.S F0, F4
NOP
BC1F @return
LI.U A0, @snow_particles
JAL spawn_particles
LI.L A0, @snow_particles
JAL mark_object_for_deletion
MOVE A0, S0

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18


@snow_particles:
.byte 0 ; behaviour argument
.byte 12 ; number of particles
.byte 0xA0 ; modelId
.byte 15 ; vertical offset
.byte 16 ; base horizontal velocity
.byte 12 ; random horizontal velocity range
.byte 14 ; base vertical velocity
.byte 10 ; random vertical velocity range
.byte -3 ; gravity
.byte 0 ; drag
.align 4
.word float( 4.5 ) ; base size
.word float( 7.5 ) ; random size range
