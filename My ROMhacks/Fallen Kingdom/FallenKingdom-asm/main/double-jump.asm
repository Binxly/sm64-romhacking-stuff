@check_kick_or_dive_in_air equ 0x8026A400
@common_air_action_step equ 0x8026B444
@spawn_particle equ 0x8029C9CC

@ACT_JUMP_LAND equ 0x04000470
@ACT_GROUND_POUND equ 0x008008A9

double_jump_ready:
.word 0

check_restore_double_jump:
	LBU AT, (global_vars + gv_items)
	ANDI AT, AT, ITEM_FEATHER
	BEQ AT, R0, @@return
	
	LW T0, (g_mario + m_action)
	ANDI T0, T0, 0x1FF
	
	SLTI AT, T0, 0x7B
	BNE AT, R0, @@restore
	SLTI AT, T0, 0x180
	BNE AT, R0, @@return
	
	@@restore:
	SETU T0, 1
	SW T0, double_jump_ready
	
	@@return:
	JR RA
	NOP
	
check_double_jump:
	LW AT, double_jump_ready
	BEQ AT, R0, @@return

	LI T2, g_mario
	LW T0, mario_action_on_frame_start
	LW AT, m_action (T2)
	BNE T0, AT, @@return

	LHU T0, 0x2 (T2)
	ANDI AT, T0, 0x2
	BEQ AT, R0, @@return
	
	LW T0, m_action (T2)
	LI T1, 0x01000800
	AND AT, T0, T1
	BNE AT, T1, @@return
	
	LI AT, 0x80831000
	AND AT, T0, AT
	BNE AT, R0, @@return
	
	ANDI T0, T0, 0xFF
	SETU AT, 0xAE
	BEQ T0, AT, @@return
	
	; If Mario is in the water jump state, turn of the swimming camera
	LW T0, (g_mario + m_action)
	LI T1, 0x01000889
	BNE T0, T1, @@endif_disable_swim_cam
		LW T0, (g_mario + m_area)
		ADDIU SP, SP, 0xFFE8
		SW RA, 0x14 (SP)

		LW A0, 0x24 (T0)
		LBU A1, 0x1 (A0)
		JAL 0x80286188
		SETU A2, 1
		
		LW RA, 0x14 (SP)
		ADDIU SP, SP, 0x18
	@@endif_disable_swim_cam:

	LI A0, g_mario
	LI A1, ACT_DOUBLE_JUMP
	J drop_and_set_mario_action
	MOVE A2, R0

	@@return:
	JR RA
	MOVE V0, R0
	
act_double_jump_impl:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	
	SW R0, double_jump_ready
	
	LI A0, g_mario
	LHU T0, 0x2 (A0)
	ANDI AT, T0, 0x8000
	BEQ AT, R0, @@endif_ground_pound
		LI A1, @ACT_GROUND_POUND
		JAL set_mario_action
		MOVE A2, R0
		B @@return
		NOP
	@@endif_ground_pound:
	
	LI T0, g_mario
	LHU T1, m_subaction (T0)
	BNE T1, R0, @@endif_first_frame
		SETU AT, 1
		SH AT, m_subaction (T0)
		LI.S F5, 40
		L.S F4, m_speed_y (T0)
		ADD.S F4, F4, F5
		MAX.S F4, F4, F5
		S.S F4, m_speed_y (T0)
		LI A0, 0x242F8081
		LW A1, g_mario_obj_ptr
		JAL play_sound
		ADDIU A1, A1, 0x54
		LW A0, g_mario_obj_ptr
		LI A2, @beh_double_jump_ring
		JAL spawn_object
		SETU A1, 0x77
	@@endif_first_frame:
	
	LI.U A0, g_mario
	JAL @check_kick_or_dive_in_air
	LI.L A0, g_mario
	BNE V0, R0, @@return
	SETU V0, 1
	
	LI A0, g_mario
	MTC1 R0, F5
	L.S F4, m_speed_h (A0)
	C.LT.S F4, F5
	LI A1, @ACT_JUMP_LAND
	BC1F @@endif_backflip
	SETU A2, 0x49
		SETU A2, 0x4
	@@endif_backflip:
	JAL @common_air_action_step
	SETU A3, 0x3
	
	MOVE V0, R0
	
	@@return:
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
	
.definelabel @beh_double_jump_ring, (org() - 0x80000000)
BHV_START OBJ_LIST_PARTICLES
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SCALE 0
BHV_SET_INT o_opacity, 255
BHV_REPEAT_BEGIN 10
	BHV_EXEC @@double_jump_ring_loop
	BHV_ADD_INT o_opacity, -25
BHV_REPEAT_END
BHV_DELETE
BHV_END

@@double_jump_ring_loop:
LW T0, g_current_obj_ptr
LI.S F5, 0.1
L.S F4, o_scale_x (T0)
ADD.S F4, F4, F5
S.S F4, o_scale_x (T0)
S.S F4, o_scale_z (T0)
LUI AT, 0x3F80
JR RA
SW AT, o_scale_y (T0)

@double_jump_ring_init:
LI A0, (g_mario + m_position)
LW A1, g_current_obj_ptr
J copy_vector
LW A1, o_position

.definelabel double_jump_ring_geo, (org() - 0x80000000)
.word 0x20000039
.word 0x04000000
	.word 0x18000014, 0x8029D924
	.word 0x15060000, @@double_jump_ring_fast3d
.word 0x05000000
.word 0x01000000
	
.definelabel @@double_jump_ring_fast3d, (org() - 0x80000000)
.word 0xE7000000, 0x00000000
.word 0xFC121A24, 0xFF37FFFF
.word 0xB6000000, 0x00002000
.word 0xF5680000, 0x07000000
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xF5680800, 0x00054150
.word 0xF2000000, 0x0007C07C
.word 0x03860010, @@lighting
.word 0x03880010, @@lighting
.word 0xFD680000, @@ring_texture
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x073FF200
.word 0x04300040, @@vertices
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x00001E0A
.word 0xBB000000, 0xFFFFFFFF
.word 0xE7000000, 0x00000000
.word 0xFCFFFFFF, 0xFFFE793C
.word 0xB7000000, 0x00002000
.word 0xFB000000, 0xFFFFFFFF
.word 0xB8000000, 0x00000000

.definelabel @@ring_texture, (org() - 0x80000000)
.incbin "../img/double-jump-ring.bin"

.definelabel @@lighting, (org() - 0x80000000)
.word 0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000

.definelabel @@vertices, (org() - 0x80000000)
.word 0x00320000, 0x00320000, 0x08000800, 0x007F00FF
.word 0xFFCF0000, 0xFFCF0000, 0x00000000, 0x007F00FF
.word 0xFFCF0000, 0x00320000, 0x00000800, 0x007F00FF
.word 0x00320000, 0xFFCF0000, 0x08000000, 0x007F00FF
