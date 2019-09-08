.definelabel beh_snowball_spawner_impl, (org()-0x80000000)
;BHV_START, OBJ_LIST_SPAWNER
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LW T0, g_current_obj_ptr
LW T1, o_timer (T0)
SETU AT, 45
BNE T1, AT, @return
NOP
	LW A0, g_current_obj_ptr
	SETU A1, 73
	LI A2, beh_snowball
	JAL spawn_object
	SW R0, o_timer (A0)
	SW V0, 0x10 (SP)
	LW T0, g_current_obj_ptr
	LW A1, o_face_angle_yaw (T0)
	SW A1, o_face_angle_yaw (V0)
	SW A1, o_move_angle_yaw (V0)
	LHU AT, o_arg0 (T0)
	SLL AT, AT, 0x10
	SW AT, o_speed_h (V0)
	LHU A0, o_arg2 (T0)
	JAL @get_random_offset
	SLL A0, A0, 0x10
	LW V0, 0x10 (SP)
	L.S F4, o_x (V0)
	L.S F5, o_z (V0)
	ADD.S F4, F4, F1
	ADD.S F5, F5, F0
	S.S F4, o_x (V0)
	S.S F5, o_z (V0)
@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@get_random_offset:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW A0, 0x18 (SP)
JAL get_random_float
SW A1, 0x1C (SP)
L.S F4, 0x18 (SP)
MUL.S F4, F4, F0
JAL get_random_short
S.S F4, 0x10 (SP)
ANDI V0, V0, 0x1
BEQ V0, R0, @@endif_flip
L.S F4, 0x10 (SP)
NEG.S F4, F4
S.S F4, 0x10 (SP)
@@endif_flip:
JAL angle_to_unit_vector
LH A0, 0x1E (SP)
L.S F4, 0x10 (SP)
MUL.S F0, F4, F0
MUL.S F1, F4, F1
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
