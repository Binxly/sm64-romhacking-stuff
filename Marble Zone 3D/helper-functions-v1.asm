/* sin_u16
Take the sine of an angle stored as an unsigned short
args:
	A0 - [u16] the angle
returns:
	F0 - [float] the sine of the angle
*/
sin_u16:
ANDI A0, A0, 0xFFF0
SRL A0, A0, 0x2
LUI AT, 0x8038
ADDU A0, AT, A0
JR RA
L.S F0, 0x6000 (A0)

/* cos_u16
Take the cosine of an angle stored as an unsigned short
args:
	a0 - [u16] the angle
returns:
	f0 - [float] the sine of the angle
*/
cos_u16:
ANDI A0, A0, 0xFFF0
SRL A0, A0, 0x2
LUI AT, 0x8038
ADDU A0, AT, A0
JR RA
L.S F0, 0x7000 (A0)

/* angle_to_unit_vector
Converts a 16-bit angle into a unit vector
args:
	a0 - [u16] the angle
returns:
	f0 - the x component of the unit vector
	f1 - the z component of the unit vector
*/
angle_to_unit_vector:
ANDI A0, A0, 0xFFF0
SRL A0, A0, 0x2
LUI AT, 0x8038
ADDU A0, AT, A0
L.S F0, 0x6000 (A0)
JR RA
L.S F1, 0x7000 (A0)

/* angle_from_object_to_point
Returns the angle (as a short) from the given object's
position to the given (x,z) point
args:
	A0 - [*object] pointer to the object
	F12 - [float] x co-ordinate of the point
	F13 - [float] z co-ordinate of the point
returns:
	V0 - [s16] angle to the point
*/
angle_to_point:
L.S F4, o_x (A0)
L.S F5, o_z (A0)
SUB.S F14, F12, F4
J atan2s
SUB.S F12, F13, F5

/* unit_vector_from_object_to_point
Returns a unit vector in the direction of the given
point from the given object's position
args:
	A0 - [*object] pointer to the object
	F12 - [float] x co-ordinate of the point
	F13 - [float] y co-ordinate of the point
	F14 - [float] z co-ordinate of the point
returns:
	F0 - x co-ordinate of the unit vector
	F1 - y co-ordinate of the unit vector
	F2 - z co-ordinate of the unit vector
*/
unit_vector_from_object_to_point:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)
L.S F4, o_x (A0)
L.S F5, o_y (A0)
L.S F6, o_z (A0)
SUB.S F12, F12, F4
SUB.S F13, F13, F5
SUB.S F14, F14, F6
S.S F12, 0x18 (SP)
S.S F13, 0x14 (SP)
S.S F14, 0x10 (SP)
MUL.S F12, F12, F12
MUL.S F13, F13, F13
MUL.S F14, F14, F14
ADD.S F12, F12, F13
JAL sqrt
ADD.S F12, F12, F14
MFC1 AT, F0
LW RA, 0x1C (SP)
BEQ AT, R0, @@return_zero_vector
L.S F12, 0x18 (SP)
L.S F13, 0x14 (SP)
L.S F14, 0x10 (SP)
DIV.S F2, F14, F0
DIV.S F1, F13, F0
DIV.S F0, F12, F0
JR RA
ADDIU SP, SP, 0x20
@@return_zero_vector:
MTC1 R0, F0
MTC1 R0, F1
MTC1 R0, F2
JR RA
ADDIU SP, SP, 0x20

/* unit_vector_from_object_to_point_2d
Returns a unit vector in the direction of the given
point from the given object's position (xz-plane only)
args:
	A0 - [*object] pointer to the object
	F12 - [float] x co-ordinate of the point
	F13 - [float] z co-ordinate of the point
returns:
	F0 - x co-ordinate of the unit vector
	F1 - z co-ordinate of the unit vector
*/
unit_vector_from_object_to_point_2d:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)
L.S F4, o_x (A0)
L.S F5, o_z (A0)
SUB.S F12, F12, F4
SUB.S F13, F13, F5
S.S F12, 0x18 (SP)
S.S F13, 0x14 (SP)
MUL.S F12, F12, F12
MUL.S F13, F13, F13
JAL sqrt
ADD.S F12, F12, F13
MFC1 AT, F0
LW RA, 0x1C (SP)
BEQ AT, R0, @@return_zero_vector
L.S F12, 0x18 (SP)
L.S F13, 0x14 (SP)
DIV.S F1, F13, F0
DIV.S F0, F12, F0
JR RA
ADDIU SP, SP, 0x20
@@return_zero_vector:
MTC1 R0, F0
MTC1 R0, F1
JR RA
ADDIU SP, SP, 0x20

/* set_object_model FIXME: broken?
Sets the model of the given object using the modelId
args:
	A0 - [pointer] object
	A1 - [short] modelId
*/
set_object_model:
LI T0, 0x8032DDC4
SLL AT, A1, 0x2
ADDU T0, T0, AT
LW AT, 0x0 (T0)
JR RA
SW AT, 0x14 (A0)


/* debug_print
Prints a word of memory, formatted in hex, to the top-left of the screen
args:
	A0 - [word] value to print
	A1 - what line to print the value on
*/
debug_print:
ADDIU SP, SP, 0xFFE8
SW A0, 0x18 (SP)
SW RA, 0x14 (SP)

SLL A1, A1, 0x4
ORI AT, R0, 0xA0
SUBU A1, AT, A1
SW A1, 0x10 (SP)

ANDI A3, A0, 0xFFFF
LI A2, @debug
JAL 0x802D62D8
ORI A0, R0, 0x40

LHU A3, 0x18 (SP)
LI A2, @debug
LW A1, 0x10 (SP)
JAL 0x802D62D8
ORI A0, R0, 0x10

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
@debug:
.asciiz "%04x"
.align 4
