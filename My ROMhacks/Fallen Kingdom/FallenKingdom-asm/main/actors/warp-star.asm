beh_warp_star_landing_impl:
; BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_ALWAYS_ACTIVE
BHV_EXEC @warp_star_landing_init
BHV_LOOP_BEGIN
	BHV_EXEC @warp_star_landing_loop
BHV_LOOP_END

@_floor_height equ 0xF4

@warp_star_landing_init:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	LW T0, g_current_obj_ptr
	L.S F12, o_x (T0)
	L.S F14, o_y (T0)
	LW A2, o_z (T0)
	JAL find_floor
	ADDIU A3, SP, 0x10

	LW T0, g_current_obj_ptr
	S.S F0, @_floor_height (T0)
	
	LI A0, g_mario
	LI A1, ACT_NOP
	JAL set_mario_action
	MOVE A2, R0
	
	LI A0, g_mario
	JAL set_mario_animation
	SETU A1, 0x33

	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@warp_star_landing_loop:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)
	SW S0, 0x10 (SP)

	LW S0, g_current_obj_ptr
	
	L.S F4, o_y (S0)
	LI.S F5, 40
	L.S F6, @_floor_height (S0)
	SUB.S F4, F4, F5
	C.LE.S F4, F6
	S.S F4, o_y (S0)
	LI.S F5, 120
	LW T0, g_mario_obj_ptr
	ADD.S F4, F4, F5
	S.S F4, o_gfx_y (T0)
	BC1F @@endif_hit_ground
		LI A0, @star_crash_particles
		JAL spawn_particles
		S.S F6, o_y (S0)
		JAL shake_screen
		SETU A0, 1
		LI A0, 0x50687F81
		JAL set_sound
		ADDIU A1, S0, 0x54
		SW R0, o_active_flags (S0)
		
		LI A0, g_mario
		LI A1, 0x00020464
		JAL set_mario_action
		MOVE A2, R0
	@@endif_hit_ground:

	LW S0, 0x10 (SP)
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18

@star_crash_particles:
.byte 0 ; behaviour argument
.byte 5 ; number of particles
.byte 40 ; modelId
.byte 0 ; vertical offset
.byte 10 ; base horizontal velocity
.byte 5 ; random horizontal velocity range
.byte 20 ; base vertical velocity
.byte 18 ; random vertical velocity range
.byte -4 ; gravity
.byte 0 ; drag
.align 4
.word float( 2.0 ) ; base size
.word float( 0.5 ) ; random size range

