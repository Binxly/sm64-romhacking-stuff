beh_temple_water_sounds_impl:
; BHV_START OBJ_LIST_GENERIC
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@loop:
LW T0, g_current_obj_ptr
LI T1, g_mario

LW AT, m_z (T1)
SW AT, o_z (T0)

LI.S F5, 1800
L.S F4, m_x (T1)
C.LT.S F4, F5
NOP
BC1T @@silent
LUI A0, 0x4001
J play_sound
ORI A0, A0, 0x0001

@@silent:
JR RA
NOP
