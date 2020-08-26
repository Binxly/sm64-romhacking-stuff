update_camera:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW A0, 0x10 (SP)

LW T0, (g_mario + m_floor_ptr)
BEQ T0, R0, @@return
NOP

LHU T0, t_collision_type (T0)
SETU AT, 0x6E
BNE T0, AT, @@return
NOP

LW T0, g_mario_obj_ptr
BEQ T0, R0, @@return
NOP

SW T0, g_current_obj_ptr
LI A0, 0x00367548
JAL get_nearest_object_with_behaviour
NOP

BEQ V0, R0, @@return
NOP

JAL @camera_approach
ADDIU A0, V0, o_position

@@return:
LW A0, 0x10 (SP)
LW RA, 0x14 (SP)
J 0x80286420
ADDIU SP, SP, 0x18


@camera_approach:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW A0, 0x18 (SP)
SW S0, 0x10 (SP)

LW S0, 0x8033CBD0
MOVE T0, A0

ADDIU A0, S0, 0x10
LW A1, 0x0 (T0)
JAL 0x802893F4
LUI A2, 0x3D4D

LW T0, 0x18 (SP)
ADDIU A0, S0, 0x14
LW A1, 0x4 (T0)
JAL 0x802893F4
LUI A2, 0x3D4D

LW T0, 0x18 (SP)
ADDIU A0, S0, 0x18
LW A1, 0x8 (T0)
JAL 0x802893F4
LUI A2, 0x3D4D

ADDIU A0, S0, 0x04
JAL 0x8028AAD8
ADDIU A1, S0, 0x10

SH V0, 0x02 (S0)
SH V0, 0x3A (S0)

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18


apply_camera_shim:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

JAL cutscene_handler 
SW A0, 0x10 (SP)

LW A0, 0x10 (SP)
LW RA, 0x14 (SP)
ADDIU SP, SP, 0x18

BEQ V0, R0, @@endif_cutscene
NOP
	JR RA
	NOP
@@endif_cutscene:

SH R0, 0x3A (A0)
LHU T0, g_level_num
SETU AT, 0x1A
BEQ T0, AT, @@game_ogre_cam
SETU AT, 0x14
BEQ T0, AT, @@file_select_cam
SETU AT, 0x1B
BEQ T0, AT, @@file_select_cam
SETU AT, 0x1F
BEQ T0, AT, @@end_screen_cam
NOP
J 0x80287CB8
NOP

@@game_ogre_cam:
LUI AT, 0x4248
SW AT, 0x1C (A0)
SW AT, 0x20 (A0)
SW AT, 0x2C (A0)
LUI AT, 0xC188
SW AT, 0x24 (A0)
SW AT, 0x30 (A0)
LUI AT, 0xC2C8
JR RA
SW AT, 0x28 (A0)

@@file_select_cam:
LI T0, g_camera_state
LI AT, float( 287.5 )
SW AT, 0x1C (A0)
SW AT, cam_x (T0)
SW R0, cam_y (T0)
SW R0, cam_z (T0)
SH R0, cam_pitch (T0)
SETU AT, 0xC000
SH AT, cam_yaw (T0)
SW R0, 0x20 (A0)
SW R0, 0x24 (A0)
SW R0, 0x28 (A0)
SW R0, 0x2C (A0)
JR RA
SW R0, 0x30 (A0)

@@end_screen_cam: ;FIXME
LI T0, g_camera_state
LI T1, float( -550 )
SW T1, cam_x (T0)
SW T1, 0x1C (A0)
LI T1, float( 50 )
SW T1, cam_y (T0)
SW T1, 0x20 (A0)
LI T1, float( -300 )
SW T1, cam_z (T0)
SW T1, 0x24 (A0)
SETS AT, 0xE000
SH AT, cam_pitch (T0)
SETS AT, 0xE000
SH AT, cam_yaw (T0)
LI T1, float( 2000 )
SW T1, 0x28 (A0)
LI T1, float( 750 )
SW T1, 0x2C (A0)
LI T1, float( -1500 )
SW T1, 0x30 (A0)
JR RA
SW R0, 0x30 (A0)

chase_cam_shim:
LHU T0, g_level_num
SETU AT, 0x5
BNE T0, AT, @@continue
NOP
	J @rapids_cam
	NOP
@@continue:
J 0x80282D78
NOP

chase_distance_shim:
LHU T0, g_level_num
SETU AT, 0x5
BNE T0, AT, @@continue
NOP
	JR RA
	NOP
@@continue:
J 0x8037A788
NOP

@rapids_cam:
SW R0, 0x0 (A1)
SW R0, 0x4 (A1)
LI AT, float( 8196 )
SW AT, 0x8 (A1)

SW R0, 0x0 (A2)
LI AT, float( 250 )
SW AT, 0x4 (A2)
LI AT, float( -1000 )
SW AT, 0x8 (A2)

JR RA
MOVE V0, R0

camera_zoom_shim:
LHU T0, 0x8033C684
ANDI T0, T0, 0x1
BNE T0, R0, @@continue
LHU T0, g_level_num
SETU AT, 0x22
BEQ T0, AT, @@arena_cam
SETU AT, 0x8
BNE T0, AT, @@continue
LW T0, (g_mario + m_area)
LBU T0, 0x0 (T0)
SETU AT, 3
BNE T0, AT, @@continue
LW T0, moldorm_defeated
BNE T0, R0, @@continue
	@@arena_cam:
	LI T0, float( 3000 )
	SW T0, 0x8032DF4C
@@continue:
J 0x80284CB8
NOP 

camera_height_shim:
LHU T0, 0x8033C684
ANDI T0, T0, 0x1
BNE T0, R0, @@continue
LHU T0, g_level_num
SETU AT, 0x22
BEQ T0, AT, @@arena_cam
SETU AT, 0x8
BNE T0, AT, @@continue
LW T0, (g_mario + m_area)
LBU T0, 0x0 (T0)
SETU AT, 3
BNE T0, AT, @@continue
LW T0, moldorm_defeated
BNE T0, R0, @@continue
	@@arena_cam:
	MTC1 A1, F4
	LI.S F5, 750
	NOP
	ADD.S F4, F4, F5
	MFC1 A1, F4
@@continue:
J 0x8028C8F0
NOP
