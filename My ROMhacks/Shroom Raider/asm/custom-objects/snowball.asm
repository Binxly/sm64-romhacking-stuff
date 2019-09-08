.definelabel beh_snowball, (org()-0x80000000)
BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE | OBJ_AUTO_MOVE_XZ
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_HITBOX 100, 200, 100
BHV_SET_INTERACTION 0x8
BHV_SET_INT 0x180, 3
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr
LUI AT, 0x4080
MTC1 AT, F5
L.S F4, o_speed_y (S0)
LUI AT, 0xC28C
MTC1 AT, F6
SUB.S F4, F4, F5
C.LT.S F4, F6
S.S F4, o_speed_y (S0)
BC1F @endif_terminal_velocity
NOP
	S.S F6, o_speed_y (S0)
@endif_terminal_velocity:
L.S F4, o_y (S0)
L.S F5, o_speed_y (S0)
ADD.S F4, F4, F5
S.S F4, o_y (S0)
LW T0, o_face_angle_pitch (S0)
ADDIU T0, T0, 0xC39
SLL T0, T0, 0x10
SRA T0, T0, 0x10
JAL obj_update_floor_and_walls
SW T0, o_face_angle_pitch (S0)
L.S F5, o_floor_height (S0)
LUI AT, 0x42C8
MTC1 AT, F6
LUI AT, 0x428C
MTC1 AT, F7
L.S F4, o_y (S0)
ADD.S F5, F5, F6
ADD.S F6, F5, F7
C.LE.S F4, F6
LW T0, o_floor_ptr (S0)
BEQ T0, R0, @destroy
SETU T1, 0xA
BC1F @return
LHU T0, t_collision_type (T0)
	S.S F5, o_y (S0)
	BNE T0, T1, @return
	SW R0, o_speed_y (S0)
		@destroy:
		JAL mark_object_for_deletion
		MOVE A0, S0
@return:
SW R0, o_interaction_status (S0)
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
