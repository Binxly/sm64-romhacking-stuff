render_hud_shim:
LHU T0, g_level_num
ORI AT, R0, 0x1A
BEQ T0, AT, @skip_hud
NOP
J 0x802E3D2C
NOP
@skip_hud:
JR RA
NOP

render_rings_shim:
LHU T0, g_level_num
ORI AT, R0, 0x9
BNE T0, AT, @skip_rings
NOP
J 0x802E37A8
NOP
@skip_rings:
JR RA
NOP

render_health_shim:
LHU T0, g_level_num
ORI AT, R0, 0x18
BNE T0, AT, @skip_health
NOP
J 0x802E3654
NOP
@skip_health:
JR RA
NOP
