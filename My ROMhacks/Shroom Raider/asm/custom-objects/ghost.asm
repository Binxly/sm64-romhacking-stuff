.definelabel beh_ghost_impl, (org()-0x80000000)
; BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_ANGLE_TO_MARIO | OBJ_STORE_DISTANCE_TO_MARIO
BHV_SET_INTERACTION 0x00800000
BHV_SET_INT o_interaction_arg, 0x1000
BHV_DROP_TO_FLOOR
BHV_SET_HITBOX 150, 200, 0
BHV_EXEC @init
BHV_LOOP_BEGIN
	BHV_SET_INT o_intangibility_timer, 0
	BHV_EXEC @loop
	BHV_SET_INT o_interaction_status, 0
BHV_LOOP_END

@init:
LW T0, g_current_obj_ptr
LW AT, o_face_angle_yaw (T0)
JR RA
SW AT, 0xF8 (T0)

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LUI AT, 0x42DC
MTC1 AT, F12
JAL 0x802A390C
L.S F14, o_hitbox_height (S0)

LW A0, 0xF8 (S0)
LW A1, o_angle_to_mario (S0)
JAL turn_angle
SETU A2, 0x2000
SW V0, o_face_angle_yaw (S0)

LUI AT, 0x4348
MTC1 AT, F5
L.S F4, o_distance_to_mario (S0)
C.LE.S F4, F5
LUI AT, 0x4448
MTC1 AT, F6
LI T0, 0x433F4000
MTC1 T0, F7
BC1T @@max_opacity
C.LT.S F4, F6
SUB.S F4, F4, F5
SUB.S F5, F6, F5
DIV.S F4, F4, F5
LUI AT, 0x3F80
MTC1 AT, F5
BC1F @@invisible
SUB.S F4, F5, F4
B @@set_opacity
MUL.S F4, F4, F7
@@invisible:
B @@return
SW R0, o_opacity (S0)
@@max_opacity:
SETU AT, 0xBF
B @@return
SW AT, o_opacity (S0)
@@set_opacity:
CVT.W.S F4, F4
MFC1 T0, F4
NOP
SW T0, o_opacity (S0)

@@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
