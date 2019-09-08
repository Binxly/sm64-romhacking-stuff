/* Whomp Shadow Behaviour Script */
beh_whomp_shadow_script:
.word 0x00080000
.word 0x11010081
.word 0x08000000
.word 0x0C000000, @beh_whomp_shadow_loop
.word 0x09000000

/* Behaviour Loop */
@beh_whomp_shadow_loop:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)
SW S0, 0x18 (SP)
SW S1, 0x14 (SP)

LUI AT, 0x8036
LW S0, 0x1160 (AT)
LW S1, o_parent (S0)

LW AT, o_face_angle_yaw (S1)
SW AT, o_face_angle_yaw (S0)

LW AT, 0x144 (S0)
BNE AT, R0, @small_shadow
NOP

; set scaling and position based on whomp's pitch
JAL cos_u16
LW A0, o_face_angle_pitch (S1)
S.S F0, 0x14 (SP)

JAL angle_to_unit_vector
LW A0, o_face_angle_yaw (S1)

LUI AT, 0x4342
MTC1 AT, F4
L.S F5, 0x14 (SP)
MUL.S F4, F4, F5
MUL.S F0, F0, F4
MUL.S F1, F1, F4

L.S F4, o_x (S1)
SUB.S F4, F4, F0
S.S F4, o_x (S0)

L.S F4, o_z (S1)
SUB.S F4, F4, F1
S.S F4, o_z (S0)

JAL sin_u16
LW A0, o_face_angle_pitch (S1)
LI AT, 0x3F3EA713
MTC1 AT, F4
LI AT, 0x3E82B1DA
MTC1 AT, F5
MUL.S F4, F4, F0
ADD.S F4, F4, F5
S.S F4, o_scale_z (S0)

; set opacity based on height
LI AT, 0x46034000
MTC1 AT, F6
L.S F4, o_y (S1)
L.S F5, o_home_y (S1)
ADD.S F5, F5, F6
C.LE.S F4, F5
NOP
BC1T @set_shadow_opacity
NOP
	B @shadow_end
	SW R0, o_opacity (S0)
@set_shadow_opacity:
LI AT, 0x3CBA83A8
MTC1 AT, F6
SUB.S F4, F5, F4
MUL.S F4, F6
CVT.W.S F4, F4
MFC1 AT, F4
NOP
SW AT, o_opacity (S0)

; rotate to match animation
LI AT, 0x805909EC ;todo -- is this consistent?
LW T0, 0x3C (S1)
BNE T0, AT, @shadow_end
NOP
	LI T0, @shadow_animation_table
	LH AT, 0x40 (S1)
	ADDU T0, T0, AT
	ADDU T0, T0, AT
	LHU AT, 0x0 (T0)
	SLL AT, AT, 0x10
	SRL AT, AT, 0x10
	LW T0, o_face_angle_yaw (S1)
	ADDU T0, T0, AT
	SW T0, o_face_angle_yaw (S0)

@shadow_end:
LW S1, 0x14 (SP)
LW S0, 0x18 (SP)
LW RA, 0x1C (SP)
JR RA
ADDIU SP, SP, 0x20

/* Whomp Minion's Shadow */
@small_shadow:
LUI AT, 0x3F00
SW AT, o_scale_x (S0)
SW AT, o_scale_z (S0)
SW R0, o_face_angle_pitch (S0)

L.S F12, o_x (S1)
L.S F14, o_y (S1)
LW A2, o_z (S1)
JAL find_floor
ADDIU A3, SP, 0x18
LW T0, 0x18 (SP)

; position shadow
LUI AT, 0x3F80
MTC1 AT, F5
L.S F4, o_floor_height (S1)
ADD.S F4, F4, F5
S.S F4, o_y (S0)
/*
JAL angle_to_unit_vector
LW A0, o_face_angle_yaw (S1)
LUI AT, 0x4248
MTC1 AT, F6
L.S F4, o_x (S1)
L.S F5, o_z (S1)
MUL.S F0, F0, F6
MUL.S F1, F1, F6
ADD.S F4, F4, F0
ADD.S F5, F5, F1
S.S F4, o_x (S0)
S.S F5, o_z (S0)
*/
LW AT, o_x (S1)
SW AT, o_x (S0)
LW AT, o_z (S1)
SW AT, o_z (S0)

; make invisible if over a death floor
BEQ T0, R0, @over_death_floor
ORI AT, R0, 0xA
LHU T0, 0x0 (T0)
BEQ T0, AT, @over_death_floor
NOP

; set opacity
L.S F4, o_y (S1)
L.S F5, o_y (S0)
LI AT, 0x3D3B337E
MTC1 AT, F6
LUI AT, 0x4340
MTC1 AT, F7
SUB.S F4, F4, F5
MUL.S F4, F4, F6
SUB.S F4, F7, F4
CVT.W.S F4, F4
B @shadow_end
S.S F4, o_opacity (S0)

@over_death_floor:
B @shadow_end
SW R0, o_opacity (S0)

/* Rotations for Shadow */
@max_rot equ 4000
.halfword int(@max_rot*-9/10)
@shadow_animation_table:
.halfword int(@max_rot*-9/10)
.halfword int(@max_rot*-8/10)
.halfword int(@max_rot*-7/10)
.halfword int(@max_rot*-6/10)
.halfword int(@max_rot*-5/10)
.halfword int(@max_rot*-4/10)
.halfword int(@max_rot*-3/10)
.halfword int(@max_rot*-2/10)
.halfword int(@max_rot*-1/10)
.halfword 0
.halfword int(@max_rot*1/10)
.halfword int(@max_rot*2/10)
.halfword int(@max_rot*3/10)
.halfword int(@max_rot*4/10)
.halfword int(@max_rot*5/10)
.halfword int(@max_rot*6/10)
.halfword int(@max_rot*7/10)
.halfword int(@max_rot*8/10)
.halfword int(@max_rot*9/10)
.halfword @max_rot
.halfword @max_rot
.halfword @max_rot
.halfword @max_rot
.halfword @max_rot
.halfword @max_rot
.halfword int(@max_rot*4/5)
.halfword int(@max_rot*3/5)
.halfword int(@max_rot*2/5)
.halfword int(@max_rot*1/5)
.halfword 0
.halfword int(@max_rot*-1/11)
.halfword int(@max_rot*-2/11)
.halfword int(@max_rot*-3/11)
.halfword int(@max_rot*-4/11)
.halfword int(@max_rot*-5/11)
.halfword int(@max_rot*-6/11)
.halfword int(@max_rot*-7/11)
.halfword int(@max_rot*-8/11)
.halfword int(@max_rot*-9/11)
.halfword int(@max_rot*-10/11)
.halfword (-@max_rot)
.halfword (-@max_rot)
.halfword (-@max_rot)
.halfword (-@max_rot)
.halfword (-@max_rot)
.halfword (-@max_rot)
.halfword (-@max_rot)
.halfword (-@max_rot)
.halfword (-@max_rot)
.halfword (-@max_rot)
.align 4
