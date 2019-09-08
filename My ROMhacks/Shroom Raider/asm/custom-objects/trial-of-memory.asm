.definelabel beh_trial_of_memory_impl,(org()-0x80000000)
;BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@rotation_speed equ 0x100

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LI T0, g_mario
LW T1, g_current_obj_ptr
L.S F4, m_y (T0)
L.S F5, o_y (T1)
C.LT.S F4, F5
MTC1 R0, F5
LW T1, m_floor_ptr (T0)
BC1F @@return
L.S F4, m_z (T0)
BEQ T1, R0, @@return
C.LE.S F4, F5
LH T1, t_collision_type (T1)
BC1F @@return
SETU AT, 0x30
BNE T1, AT, @@return
LH T1, m_angle_yaw (T0)
ADDIU T1, T1, @rotation_speed
SH T1, m_angle_yaw (T0)
JAL get_or_set_camera_mode
SETU A0, 0x2
LUI T0, 0x8034
LH T1, 0xC778 (T0)
ADDIU T1, T1, @rotation_speed
SH T1, 0xC778 (T0)

@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
