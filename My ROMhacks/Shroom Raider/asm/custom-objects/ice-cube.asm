.definelabel beh_ice_cube, (org()-0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_INT o_opacity, 0x80
BHV_LOOP_BEGIN
	BHV_EXEC @ice_cube_loop
BHV_LOOP_END

@ice_cube_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LI T0, g_mario
LW T1, g_current_obj_ptr
LH AT, m_angle_yaw (T0)
SW AT, o_face_angle_yaw (T1)
ADDIU A0, T0, m_x
JAL copy_vector
ADDIU A1, T1, o_x

LI T0, g_mario
LW T0, m_action (T0)
LI T1, ACT_FROZEN
BEQ T0, T1, @@return

LUI A0, 0x0258
JAL play_sound
ORI A0, A0, 0xC081

LI.U A0, @ice_shards
JAL spawn_particles
LI.L A0, @ice_shards

LW.U A0, g_current_obj_ptr
JAL mark_object_for_deletion
LW.L A0, g_current_obj_ptr

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@ice_shards:
.byte 0 ; behaviour argument
.byte 4 ; # of particles
.byte 0x50 ; model
.byte 50 ; vertical offset
.byte 16 ; base hvel
.byte 6 ; random hvel
.byte 27 ; base vvel
.byte 15 ; random vvel
.byte -4 ; gravity
.byte 0 ; drag
.align 4
.word float( 12 ) ; base size
.word float( 4 ) ; random size
