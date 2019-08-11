.definelabel beh_springy_cloud_impl, (org()-0x80000000)
;BHV_START OBJ_LIST_SURFACE
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX
BHV_SET_COLLISION cloud_collision
BHV_SET_FLOAT o_collision_distance, 500
BHV_SET_INT o_opacity, 0xD9
BHV_STORE_HOME
BHV_SET_INT o_intangibility_timer, 0
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@SPRING_DAMPING equ 0x3F747080
@SPRING_CONSTANT equ 0x3E19999A

@_mario_fall_speed equ 0xF4

@loop:
LW T0, g_current_obj_ptr
; If Mario just landed on the cloud, add his velocity
LI T1, g_mario
LW AT, m_floor_ptr (T1)
BEQ AT, R0, @endif_mario_landed
	NOP
	LW AT, t_object (AT)
	BNE AT, T0, @endif_mario_landed
		LW T1, m_action (T1)
		ANDI T1, T1, 0x800
		BNE T1, R0, @endif_mario_landed
			MTC1 R0, F5
			L.S F4, @_mario_fall_speed (T0)
			C.LT.S F4, F5
			L.S F5, o_speed_y (T0)
			BC1F @endif_mario_landed
				ADD.S F4, F4, F5
				S.S F4, o_speed_y (T0)
@endif_mario_landed:

; Cap velocity to 70
LUI AT, 0xC28C
MTC1 AT, F5
L.S F4, o_speed_y (T0)
C.LT.S F4, F5
NOP
BC1F @endif_cap_speed
NOP
    S.S F5, o_speed_y (T0)
@endif_cap_speed:

; Move
L.S F4, o_y (T0)
L.S F5, o_speed_y (T0)
ADD.S F4, F4, F5
S.S F4, o_y (T0)

; Spring physics
LI AT, @SPRING_CONSTANT
MTC1 AT, F7
L.S F6, o_home_y (T0)
SUB.S F6, F6, F4
MUL.S F6, F6, F7
LI AT, @SPRING_DAMPING
MTC1 AT, F7
ADD.S F5, F5, F6
MUL.S F5, F5, F7
S.S F5, o_speed_y (T0)

; Store Mario's last vertical speed
LI T1, g_mario
LW T1, m_action (T1)
ANDI T1, T1, 0x800
BEQ T1, R0, @endif_mario_in_air
SW R0, @_mario_fall_speed (T0)
    LI T1, g_mario
    LW AT, m_speed_y (T1)
    SW AT, @_mario_fall_speed (T0)
@endif_mario_in_air:

J process_collision
NOP

cloud_no_fall_damage_shim:
LI T0, g_mario
LW T0, m_floor_ptr (T0)
BEQ T0, R0, @@continue
NOP
LW T0, t_object (T0)
BEQ T0, R0, @@continue
NOP
LW T0, 0x20C (T0)
BEQ T0, R0, @@continue
LI T1, beh_springy_cloud_impl
LW T0, 0x8 (T0)
BNE T0, T1, @@continue
NOP
JR RA
MOVE V0, R0
@@continue:
ADDIU SP, SP, 0xFFD0
J 0x8026A22C
SW RA, 0x1C (SP)
