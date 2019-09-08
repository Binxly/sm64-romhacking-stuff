draw_camera_shim:
LH T0, g_level_num
SETU AT, 0x5
BEQ T0, AT, @@return
NOP
J 0x802E3B3C
NOP
@@return:
JR RA
NOP
