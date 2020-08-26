horizontally_billboard:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LI T0, g_camera_position
L.S F4, 0x0 (T0)
L.S F5, 0x8 (T0)
LW T0, g_current_obj_ptr
L.S F14, o_x (T0)
L.S F12, o_z (T0)
SUB.S F12, F5, F12
JAL atan2s
SUB.S F14, F4, F14
LW T0, g_current_obj_ptr
SW V0, o_face_angle_yaw (T0)
LW AT, o_parent (T0)
L.S F4, o_y (AT)
L.S F5, o_arg0 (T0)
ADD.S F4, F4, F5
S.S F4, o_y (T0)

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
