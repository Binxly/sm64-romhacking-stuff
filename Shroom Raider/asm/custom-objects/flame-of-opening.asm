.definelabel beh_flame_of_opening_impl,(org()-0x80000000)
; BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_STORE_HOME
BHV_BILLBOARD
BHV_SCALE 150
BHV_SET_WORD o_state, @action_unaquired
BHV_LOOP_BEGIN
	BHV_EXEC @loop
	BHV_ADD_INT o_animation_state, 1
BHV_LOOP_END

@_target_posn equ 0xF4
@_target_x equ 0xF4
@_target_y equ 0xF8
@_target_z equ 0xFC
@_target_door equ 0x100
@_orbit_angle equ 0x104

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LW T0, o_state (S0)
JR T0
NOP

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@action_unaquired:
	LW A0, g_mario_obj_ptr
	JAL get_dist_3d
	MOVE A1, S0
	LUI AT, 0x4396
	MTC1 AT, F4
	LI.U T0, @action_following
	C.LE.S F0, F4
	LI.L T0, @action_following
	BC1F @return
	LUI A0, 0x7031
	SW T0, o_state (S0)
	JAL play_sound
	ORI A0, A0, 0x8081
	B @return
	NOP
	
@action_following:
	JAL is_mario_voiding_out
	NOP
	BEQ V0, R0, @@endif_return_home
	LI T0, @action_unaquired
		JAL obj_reset_to_home
		SW T0, o_state (S0)
	@@endif_return_home:
	LI.U A0, beh_door
	JAL get_nearest_object_with_behaviour
	LI.L A0, beh_door
	BEQ V0, R0, @despawn
	LW A0, g_mario_obj_ptr
	MOVE S0, V0
	JAL get_dist_3d
	MOVE A1, V0
	MOVE V0, S0
	LW S0, g_current_obj_ptr
	LUI AT, 0x4416
	MTC1 AT, F4
	LH T0, @_orbit_angle (S0)
	C.LE.S F0, F4
	ADDIU T0, T0, 0x800
	BC1F @@endif_close_to_door
	SH T0, @_orbit_angle (S0)
	LW T0, o_state (V0)
	BNE T0, R0, @@endif_close_to_door
		LI T0, @action_unlocking
		SW T0, o_state (S0)
		SW V0, @_target_door (S0)
		ADDIU A0, V0, o_x
		JAL copy_vector
		ADDIU A1, S0, @_target_posn
		B @action_unlocking
	@@endif_close_to_door:
	LI T0, g_mario
	LUI AT, 0x42C8
	MTC1 AT, F5
	L.S F4, m_y (T0)
	ADD.S F4, F4, F5
	S.S F4, @_target_y (S0)
	JAL angle_to_unit_vector
	LH A0, @_orbit_angle (S0)
	LUI AT, 0x4316
	MTC1 AT, F4
	LI T0, g_mario
	MUL.S F0, F0, F4
	MUL.S F1, F1, F4
	L.S F4, m_x (T0)
	L.S F5, m_z (T0)
	ADD.S F4, F4, F0
	ADD.S F5, F5, F1
	S.S F4, @_target_x (S0)
	S.S F5, @_target_z (S0)
	LI.U RA, @return
	J @approach_target
	LI.L RA, @return
	
@action_unlocking:
	JAL @approach_target
	NOP
	BEQ V0, R0, @return
	LW T0, @_target_door (S0)
	SETU AT, 0x1
	SW AT, o_state (T0)
	LUI A0, 0x7037
	ORI A0, A0, 0x8081
	LW A1, g_mario_obj_ptr
	JAL set_sound
	ADDIU A1, A1, 0x54
	LW T0, @_target_door (S0)
	LB T0, o_arg0 (T0)
	BNE T0, R0, @despawn
	LI T0, @action_following
	B @return
	SW T0, o_state (S0)

@despawn:
JAL mark_object_for_deletion
MOVE A0, S0
B @return
NOP

@SPEED_F16 equ 0x4248

@approach_target:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)

ADDIU A0, S0, @_target_posn
ADDIU A1, S0, o_x
JAL subtract_vectors_3d
ADDIU A2, SP, 0x10

MOVE A0, A2
JAL normalize_vector
MOVE A1, A2

LUI AT, @SPEED_F16
MTC1 AT, F12
JAL scale_vector_3d
C.LE.S F3, F12
BC1F @@endif_close_to_target
	ADDIU A0, S0, @_target_posn
	JAL copy_vector
	ADDIU A1, S0, o_x
	B @@return
	SETU V0, 0x1
@@endif_close_to_target:
ADDIU A0, S0, o_x
JAL add_vectors_3d
MOVE A2, A0
MOVE V0, R0

@@return:
LW RA, 0x1C (SP)
JR RA
ADDIU SP, SP, 0x20
