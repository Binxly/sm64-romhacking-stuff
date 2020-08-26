.definelabel beh_respawn_orb, (org()-0x80000000)
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_BILLBOARD
BHV_SET_INT o_animation_state, -1
BHV_EXEC @init
BHV_REPEAT_BEGIN 5
	BHV_ADD_INT o_animation_state, 1
	BHV_EXEC @loop
BHV_REPEAT_END
BHV_DELETE
BHV_END

@init:
LW T0, g_global_timer
ANDI T0, T0, 0x7
BNE T0, R0, @return
LUI A0, 0x307F
J play_sound
ORI A0, A0, 0x8081
@return:
JR RA
NOP

@loop:
LW T0, g_current_obj_ptr
LW T1, o_timer (T0)
ORI AT, R0, 0x8 
SUBU T1, AT, T1 ; t1 = 8 - timer
MTC1 T1, F4
LUI AT, 0x3E80
MTC1 AT, F5
CVT.S.W F4, F4
MUL.S F4, F4, F5 ; f4 = (8 - timer) / 4
MFC1 A1, F4
J scale_object
SLL A0, T0, 0x0
