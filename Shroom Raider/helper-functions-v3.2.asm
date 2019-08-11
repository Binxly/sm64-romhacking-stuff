/* labels.asm + helper-functions.asm
Falcobuster's Labels and Helper Functions v3.2.0
These two files are public domain. You may use, modify, and distribute them
however you wish without restriction. Preserving this header comment is
appreciated, but not required.
https://gitlab.com/mpharoah/sm64-romhacking-stuff
*/

/* sin_u16
Take the sine of an angle stored as a short
args:
	A0 - [short] the angle
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
Take the cosine of an angle stored as a short
args:
	A0 - [short] the angle
returns:
	F0 - [float] the sine of the angle
*/
cos_u16:
ANDI A0, A0, 0xFFF0
SRL A0, A0, 0x2
LUI AT, 0x8038
ADDU A0, AT, A0
JR RA
L.S F0, 0x7000 (A0)

/* tan_u16
Take the tangent of an angle stored as a short
args:
	A0 - [short] the angle
returns:
	F0 - [float] the tangent of the angle
*/
tan_u16:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
ANDI A0, A0, 0xFFFF
ORI AT, R0, 0x8000
SLTU T0, A0, AT
JAL cos_u16
SW T0, 0x10 (SP)
MTC1 R0, F4
LUI AT, 0x3F80
C.EQ.S F4, F0
MTC1 AT, F5
BC1T @@return_nan
MUL.S F4, F0, F0
SUB.S F4, F5, F4
SQRT.S F4, F4
DIV.S F0, F4, F0
LW T0, 0x10 (SP)
BNE T0, R0, @@return
NOP
NEG.S F0, F0
@@return:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
@@return_nan:
LUI AT, 0x7F80
ORI AT, AT, 0x1
B @@return
MTC1 AT, F0

/* angle_to_unit_vector
Converts a 16-bit angle into a unit vector
args:
	A0 - [ushort] the angle
returns:
	F0 - [float] the x component of the unit vector
	F1 - [float] the z component of the unit vector
*/
angle_to_unit_vector:
ANDI A0, A0, 0xFFF0
SRL A0, A0, 0x2
LUI AT, 0x8038
ADDU A0, AT, A0
L.S F0, 0x6000 (A0)
JR RA
L.S F1, 0x7000 (A0)

/* dot_product_3d
Computes the dot product of two 3 dimensional vectors.
args:
	A0 - [pointer] pointer to vector A
	A1 - [pointer] pointer to vector B
returns:
	F0 - dot product
*/
dot_product_3d:
L.S F5, 0x0 (A0)
L.S F6, 0x0 (A1)
MUL.S F4, F5, F6
L.S F5, 0x4 (A0)
L.S F6, 0x4 (A1)
MUL.S F5, F5, F6
ADD.S F4, F4, F5
L.S F5, 0x8 (A0)
L.S F6, 0x8 (A1)
MUL.S F5, F5, F6
JR RA
ADD.S F0, F4, F5

/* cross_product
Computes the cross product of two vectors. Result is both stored in the return
registers F0 - F2 and writen to memory at A2
args:
	A0 - [pointer] pointer to vector A
	A1 - [pointer] pointer to vector B
	A2 - [pointer] pointer to output vector (or NULL to not store the result)
*/
cross_product:
L.S F4, 0x4 (A0)
L.S F5, 0x8 (A1)
MUL.S F4, F4, F5
L.S F5, 0x8 (A0)
L.S F6, 0x4 (A1)
MUL.S F5, F5, F6
SUB.S F0, F4, F5

L.S F4, 0x8 (A0)
L.S F5, 0x0 (A1)
MUL.S F4, F4, F5
L.S F5, 0x0 (A0)
L.S F6, 0x8 (A1)
MUL.S F5, F5, F6
SUB.S F1, F4, F5

L.S F4, 0x0 (A0)
L.S F5, 0x4 (A1)
MUL.S F4, F4, F5
L.S F5, 0x4 (A0)
L.S F6, 0x0 (A1)
MUL.S F5, F5, F6
BEQ A2, R0, @@return
SUB.S F2, F4, F5

S.S F0, 0x0 (A2)
S.S F1, 0x4 (A2)
S.S F2, 0x8 (A2)

@@return:
JR RA
NOP

/* get_floor_steepness
Gets the steepness angle of the floor triangle
args:
	A0 - [pointer] floor triangle
returns:
	V0 - [short] angle of steepness
*/
get_floor_steepness:
L.S F4, t_normal_x (A0)
L.S F5, t_normal_z (A0)
MUL.S F4, F4, F4
MUL.S F5, F5, F5
ADD.S F4, F4, F5
SQRT.S F14, F4
J atan2s
L.S F12, t_normal_y (A0)

/* angle_from_object_to_point
Returns the angle (as a short) from the given object's
position to the given (x,z) point
args:
	A0 - [pointer] pointer to the object
	F12 - [float] x co-ordinate of the point
	F13 - [float] z co-ordinate of the point
returns:
	V0 - [short] angle to the point
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
	A0 - [pointer] pointer to the object
	F12 - [float] x co-ordinate of the point
	F13 - [float] y co-ordinate of the point
	F14 - [float] z co-ordinate of the point
returns:
	F0 - [float] x co-ordinate of the unit vector
	F1 - [float] y co-ordinate of the unit vector
	F2 - [float] z co-ordinate of the unit vector
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
	A0 - [pointer] pointer to the object
	F12 - [float] x co-ordinate of the point
	F13 - [float] z co-ordinate of the point
returns:
	F0 - [float] x co-ordinate of the unit vector
	F1 - [float] z co-ordinate of the unit vector
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

/* colliding_with_type
Checks if the given object is currently colliding with an object that has the
given behaviour.
args:
	A0 - [pointer] object to check
	A1 - [segmented pointer] behaviour
return:
	V0 - [pointer] the first colliding object with the given behaviour, or NULL
*/
colliding_with_type:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW A0, 0x10 (SP)

JAL segmented_to_virtual
SLL A0, A1, 0x0
SLL A1, V0, 0x0

LW A0, 0x10 (SP)
LHU T0, o_num_collided_objects (A0)
BEQ T0, R0, @@return_null
@@loop:
	LW V0, o_collided_objects (A0)
	LW AT, 0x20C (V0)
	BEQ AT, A1, @@return_ptr
	ADDIU T0, T0, 0xFFFF
	BNE T0, R0, @@loop
	ADDIU A0, A0, 0x4
@@return_null:
SLL V0, R0, 0x0
@@return_ptr:
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

/* debug_print
Prints a word of memory, formatted in hex, to the top-left of the screen
args:
	A0 - [uint] value to print
	A1 - [uint] what line to print the value on
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
LI A2, @debug_text
JAL print
ORI A0, R0, 0x40

LHU A3, 0x18 (SP)
LI A2, @debug_text
LW A1, 0x10 (SP)
JAL print
ORI A0, R0, 0x10

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@debug_text:
.asciiz "%04x"
.align 4

/* exec_display_list
Adds an instruction onto the RSP pipeline to jump and link to a display list
args:
	A0 - [segmented pointer] segmented pointer to the display list
*/
exec_display_list:
LW T0, g_display_list_head
LUI AT, 0x0600
SW AT, 0x0 (T0)
SW A0, 0x4 (T0)
ADDIU T0, T0, 0x8
SW.U T0, g_display_list_head
JR RA
SW.L T0, g_display_list_head

/* encode_text
Converts the text from ASCII to the encoding using by the game to print small
text, and stores the result in the provided buffer
args:
	A0 - [pointer] a pointer to a null-terminated string of ASCII text
	A1 - [pointer] a pointer to a buffer where the result should be stored
				   (can be the same as A0 to encode the text in-place)
				   
This supports all alphanumeric characters (0-9, a-z, A-Z) as well as these
special characters: ! % & _ ~ ' : ( ) , ? .
Additionally, you can get these special characters using the given ASCII char:
* : star (filled)
+ : star (outline)
# : X (cross)
@ : dot
$ : coin
/ : big space
` : double quotes (left)
" : double quotes (right)
- : left-right arrows
^ : up arrow
< : left arrow
> : right arrow
= : down arrow
[ : bold A
] : bold B
| : bold C
{ : bold Z
} : bold R
\ : newline (using the ASCII line feed character also works)
*/
encode_text:
LI T0, @text_encoding_table
@encode_text_loop:
	LBU T1, 0x0 (A0)
	BEQ T1, R0, @encode_text_return
	ADDU T1, T0, T1
	LBU T1, 0x0 (T1)
	SB T1, 0x0 (A1)
	ADDIU A0, A0, 0x1
	B @encode_text_loop
	ADDIU A1, A1, 0x1
@encode_text_return:
ORI AT, R0, 0xFF
JR RA
SB AT, 0x0 (A1)

@text_encoding_table:
.byte 0xFF
.fill 32,0x9E
.byte 0xF2, 0xF6, 0xFB, 0xF9, 0xF3, 0xE5, 0x3E, 0xE1, 0xE3, 0xFA, 0xFD, 0x6F, 0xE4, 0x3F, 0xD0
.byte 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09
.byte 0xE6, 0x9E, 0x52, 0x51, 0x53, 0xF4, 0xFC
.byte 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20, 0x21, 0x22, 0x23
.byte 0x54, 0xFE, 0x55, 0x50, 0x9F, 0xF5
.byte 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D
.byte 0x57, 0x56, 0x58, 0xF7, 0x9E
.align 4

/* begin_print_encoded_text
Sets up the graphics context to display regular text. Call this before calling
print_encoded_text. Note that this modifies the graphics context, so it is not
safe to call this just anywhere like you can with print/debug_print. A good
place to use this function is just after the HUD renders or when the pause
screen is being rendered.
args:
	A0 - [uint] text colour (format RRGGBBAA)
*/
begin_print_encoded_text:
LW T0, g_display_list_head
LI AT, 0xBA001402
SW AT, 0x0 (T0)
SW R0, 0x4 (T0)
LUI AT, 0x0600
SW AT, 0x8 (T0)
LI AT, 0x02011CC8
SW AT, 0xC (T0)
LUI AT, 0xFB00
SW AT, 0x10 (T0)
SW A0, 0x14 (T0)
ADDIU T0, T0, 0x18
SW.U T0, g_display_list_head
JR RA
SW.L T0, g_display_list_head

/* (print_encoded_text label defined in labels.asm) */

/* end_print_encoded_text
Finished printing encoded text. Call this after all of your calls to
print_encoded_text
*/
end_print_encoded_text:
LUI A0, 0x0201
J exec_display_list
ORI A0, A0, 0x1D50

/* wordcopy
Copies a number of words from one location in RAM to another. More efficient
than using memcpy
args:
	a0 - [pointer] destination
	a1 - [pointer] source
	a2 - [unit] number of words to copy
*/
wordcopy:
BEQ A2, R0, @wordcopy_return
@wordcopy_loop:
	LW AT, 0x0 (A1)
	SW AT, 0x0 (A0)
	ADDIU A2, A2, 0xFFFF
	ADDIU A0, A0, 0x4
	BNE A2, R0, @wordcopy_loop
	ADDIU A1, A1, 0x4
@wordcopy_return:
JR RA
NOP

/* get_random_point
Returns a 2d offset in a random position within a circle of the given radius
args:
	f12 - [float] radius
returns:
	f0 - [float] co-ordinate in one axis
	f1 - [float] co-ordinate in another perpendicular axis
*/
get_random_point:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
JAL get_random_float
S.S F12, 0x10 (SP)
JAL sqrt
MOV.S F12, F0
L.S F4, 0x10 (SP)
MUL.S F4, F4, F0
JAL get_random_short
S.S F4, 0x10 (SP)
JAL angle_to_unit_vector
SLL A0, V0, 0x0
L.S F4, 0x10 (SP)
MUL.S F0, F0, F4
MUL.S F1, F1, F4
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

/* perspective_transform
Returns the screen co-ordinates of the given point in world co-ordinates as
determined by the camera's current position, orientation, and field of view.
Co-ordinates are returned as floating point numbers, and must be converted to
integers before being used in fast3D commands.
args:
	F12 - x component of the point to transform
	F13 - y component of the point to transform
	F14 - z component of the point to transform
returns:
	V0 - non-zero if the point is within 90 degrees of the camera
	F0 - x component of the transformed point (undefined if v0 is 0)
	F1 - y component of the transformed point (undefined if v0 is 0)
*/
perspective_transform:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)

@@HALF_SCREEN_WIDTH equ float( 0x280 )
@@HALF_SCREEN_HEIGHT equ float( 0x1E0 )

LI T0, g_camera_state
L.S F4, cam_x (T0)
L.S F5, cam_y (T0)
L.S F6, cam_z (T0)

SUB.S F4, F12, F4
SUB.S F5, F13, F5
SUB.S F6, F14, F6

MOV.S F14, F4
MOV.S F12, F6

S.S F5, 0x10 (SP)
MUL.S F4, F12, F12
MUL.S F5, F14, F14
ADD.S F4, F4, F5
SQRT.S F4, F4

JAL atan2s
S.S F4, 0x14 (SP)
SW V0, 0x18 (SP)

LI AT, 0x42B60B61
MTC1 AT, F5
L.S F4, g_camera_fov
MUL.S F4, F4, F5
CVT.W.S F4, F4

MFC1 A0, F4
JAL tan_u16
NOP
LI AT, @@HALF_SCREEN_HEIGHT
MTC1 AT, F4
LH V0, 0x1A (SP)
DIV.S F4, F4, F0
S.S F4, 0x18 (SP)

LI T0, g_camera_state
LH T1, cam_yaw (T0)
SUBU T1, T1, V0

SLL T1, T1, 0x10
SRA A0, T1, 0x10

ABS T1, A0
SLTI AT, T1, 0x4000
BEQ AT, R0, @@behind_camera
NOP

JAL tan_u16
NOP

L.S F4, 0x18 (SP)
LI AT, @@HALF_SCREEN_WIDTH
MTC1 AT, F5
MUL.S F4, F4, F0
ADD.S F4, F4, F5

L.S F12, 0x14 (SP)
S.S F4, 0x14 (SP)
JAL atan2s
L.S F14, 0x10 (SP)

LI T0, g_camera_state
LH T1, cam_pitch (T0)
SUBU T1, T1, V0

SLL T1, T1, 0x10
SRA A0, T1, 0x10

ABS T1, A0
SLTI AT, T1, 0x4000
BEQ AT, R0, @@behind_camera
NOP

JAL tan_u16
NOP

L.S F4, 0x18 (SP)
LI AT, @@HALF_SCREEN_HEIGHT
MTC1 AT, F5
MUL.S F4, F4, F0
ADD.S F1, F5, F4
L.S F0, 0x14 (SP)
ORI V0, R0, 0x1

LW RA, 0x1C (SP)
JR RA
ADDIU SP, SP, 0x20
@@behind_camera:
ORI V0, R0, 0x0
LW RA, 0x1C (SP)
JR RA
ADDIU SP, SP, 0x20

/* create_draw_rect_command
Generates a Fast3D command for drawing a rectangle
args:
	A0 - x co-ordinate of the left side of the rectangle
	A1 - y co-ordinate of the top side of the rectangle
	A2 - width of the rectangle
	A3 - height of the rectangle
returns:
	V0 - the upper half of the Fast3D command
	V1 - the lower half of the Fast3D command
*/
create_draw_rect_command:
ADDU A2, A0, A2
ADDU A3, A1, A3
ANDI A0, A0, 0xFFF
ANDI A1, A1, 0xFFF
ANDI A2, A2, 0xFFF
ANDI A3, A3, 0xFFF
LUI V0, 0xF600
SLL A2, A2, 0xC
OR A2, A2, A3
OR V0, V0, A2
SLL A0, A0, 0xC
JR RA
OR V1, A0, A1

/* reset_camera
Resets the camera to Mario's position. Call this after manually teleporting
Mario to avoid the camera having to catch up.
*/
reset_camera:
LW T0, 0x8032DDCC
J 0x80286F68
LW A0, 0x24 (T0)

/* copy_vector
Copy a 3-dimensional vector from one location to another
Components of the copied vector are also stores in the F0 - F2 registers
args:
	A0 - [pointer] pointer to source vector
	A1 - [pointer] pointer to memory to copy the vector to
returns:
	F0,F1,F2: [float] vector components
*/
copy_vector:
L.S F0, 0x0 (A0)
L.S F1, 0x4 (A0)
L.S F2, 0x8 (A0)
S.S F0, 0x0 (A1)
S.S F1, 0x4 (A1)
JR RA
S.S F2, 0x8 (A1)

/* get_vector_magnitude
Computes the magnitude of a vector
args:
	A0 - [pointer] pointer to vector
returns:
	F0 - [float] magnitude
*/
get_vector_magnitude:
L.S F4, 0x0 (A0)
L.S F5, 0x4 (A0)
L.S F6, 0x8 (A0)
MUL.S F4, F4, F4
MUL.S F5, F5, F5
MUL.S F6, F6, F6
ADD.S F4, F4, F5
ADD.S F4, F4, F6
JR RA
SQRT.S F0, F4

/* normalize_vector
Normalizes a vector and stores the result in A1. It is safe to use the same
pointer for A0 and A1 in which case the vector is normalized in place.
args:
	A0 - [pointer] pointer to source vector
	A1 - [pointer] pointer to memory to store the result vector in
returns:
	F0,F1,F2: [float] vector components
	F3: [float] magnitude of the source vector
*/
normalize_vector:
L.S F0, 0x0 (A0)
L.S F1, 0x4 (A0)
L.S F2, 0x8 (A0)
MUL.S F4, F0, F0
MUL.S F5, F1, F1
MUL.S F6, F2, F2
ADD.S F3, F4, F5
ADD.S F3, F3, F6
MTC1 R0, F4
SQRT.S F3, F3
C.EQ.S F3, F4
NOP
BC1T @@return
SLL V0, R0, 0x0
DIV.S F0, F0, F3
DIV.S F1, F1, F3
DIV.S F2, F2, F3
ORI V0, R0, 0x1
@@return:
S.S F0, 0x0 (A1)
S.S F1, 0x4 (A1)
JR RA
S.S F2, 0x8 (A1)

/* add_vectors_3d
Adds two 3-dimensional vectors and stores the result in memory
Does not alter the argument register values.
args:
	A0 - [pointer] pointer to vector A
	A1 - [pointer] pointer to vector B
	A2 - [pointer] pointer to where to store A+B
returns:
	F0,F1,F2: [float] result vector components
*/
add_vectors_3d:
L.S F4, 0x0 (A0)
L.S F5, 0x0 (A1)
ADD.S F0, F4, F5
S.S F0, 0x0 (A2)
L.S F4, 0x4 (A0)
L.S F5, 0x4 (A1)
ADD.S F1, F4, F5
S.S F1, 0x4 (A2)
L.S F4, 0x8 (A0)
L.S F5, 0x8 (A1)
ADD.S F2, F4, F5
JR RA
S.S F2, 0x8 (A2)

/* subtract_vectors_3d
Subtracts two 3-dimensional vectors and stores the result in memory
Does not alter the argument register values.
args:
	A0 - [pointer] pointer to vector A
	A1 - [pointer] pointer to vector B
	A2 - [pointer] pointer to where to store A-B
returns:
	F0,F1,F2: [float] result vector components
*/
subtract_vectors_3d:
L.S F4, 0x0 (A0)
L.S F5, 0x0 (A1)
SUB.S F0, F4, F5
S.S F0, 0x0 (A2)
L.S F4, 0x4 (A0)
L.S F5, 0x4 (A1)
SUB.S F1, F4, F5
S.S F1, 0x4 (A2)
L.S F4, 0x8 (A0)
L.S F5, 0x8 (A1)
SUB.S F2, F4, F5
JR RA
S.S F2, 0x8 (A2)

/* subtract_vectors_3d
Multiplies a 3-dimensional vector by a scalar and stores the result in memory
Does not alter the argument register values.
args:
	A0 - [pointer] pointer to vector
	A1 - [pointer] pointer to where to store the result
	F12 - [float] scalar value to multiply the result by
returns:
	F0,F1,F2: [float] result vector components
*/
scale_vector_3d:
L.S F4, 0x0 (A0)
MUL.S F0, F4, F12
S.S F0, 0x0 (A1)
L.S F4, 0x4 (A0)
MUL.S F1, F4, F12
S.S F1, 0x4 (A1)
L.S F4, 0x8 (A0)
MUL.S F2, F4, F12
JR RA
S.S F2, 0x8 (A1)

/* get_distance_between_points
Gets the distance between two 3D points
Does not alter the argument register values.
args:
	A0 - [pointer] pointer to point A
	A1 - [pointer] pointer to point B
returns:
	F0 - distance
*/
get_distance_between_points:
ADDIU SP, SP, 0xFFE0
SW RA, 0x1C (SP)
SW A0, 0x20 (SP)
JAL subtract_vectors_3d
ADDIU A2, SP, 0x10
JAL get_vector_magnitude
SLL A0, A2, 0x0
LW A0, 0x20 (SP)
LW RA, 0x1C (SP)
JR RA
ADDIU SP, SP, 0x20

/* turn_vector_3d
Computes a unit vector that is a vector turned from the direction of vector A0
towards the direction of vector A1, with a maximum angle change of A2. The
result is stored in A3. All vectors are 3 dimensional.

Does not alter the argument register values.
args:
	A0 - [pointer (float[3])] the source vector
	A1 - [pointer (float[3])] the target vector
	A2 - [short] the maximum angle change
	A3 - [pointer (float[3])] allocated space for the result vector
retuns:
	V0 - [short] angle change
*/
turn_vector_3d:
ADDIU SP, SP, 0xFFC0
SW RA, 0x3C (SP)
SW A0, 0x40 (SP)
SW A1, 0x44 (SP)
SW A2, 0x48 (SP)
SW A3, 0x4C (SP)

; Store S = normalized source vector at SP+0x10
JAL normalize_vector
ADDIU A1, SP, 0x10

; if the source vector is a zero vector, return a zero vector
BNE V0, R0, @@endif_source_vector_is_zero
	LW T0, 0x4C (SP)
	SW R0, 0x0 (T0)
	SW R0, 0x4 (T0)
	SW R0, 0x8 (T0)
	B @@return
	ORI V0, R0, 0x0
@@endif_source_vector_is_zero:

; Store T = normalized source vector at SP+0x1C
LW A0, 0x44 (SP)
JAL normalize_vector
ADDIU A1, SP, 0x1C

; if the target vector is a zero vector, return S
BNE V0, R0, @@endif_target_vector_is_zero
	@@return_normalized_source:
	LI RA, @@return
	ADDIU A0, SP, 0x10
	LW A1, 0x4C (SP)
	J copy_vector
	ORI V0, R0, 0x0
@@endif_target_vector_is_zero:

ADDIU A0, SP, 0x10
ADDIU A1, SP, 0x1C
JAL cross_product
ADDIU A2, SP, 0x28

ADDIU A0, SP, 0x28
JAL normalize_vector
SLL A1, A0, 0x0

; Store the value of ‖S⨯T‖, which is the sine of the difference of angles, in SP+0x34
MTC1 R0, F4
S.S F3, 0x34 (SP)

; if S and T are parallel, return S
LUI AT, 0x3F80
C.EQ.S F3, F4
MTC1 AT, F5
BC1T @@return_normalized_source

; Compute the angle between the two vectors, and store it in SP+0x38
ADDIU A0, SP, 0x10
JAL dot_product_3d
ADDIU A1, SP, 0x1C
MOV.S F12, F0
JAL atan2s
L.S F14, 0x34 (SP)
SW V0, 0x38 (SP)

; In case of rounding errors, check again that the angle is not 0 or 180
ANDI V0, V0, 0xFFFF
BEQ V0, R0, @@return_normalized_source
ORI AT, R0, 0x8000
SLTU AT, V0, AT
BEQ AT, R0, @@return_normalized_source
SW V0, 0x38 (SP)

; If angle difference is within max angle change, return T
LW T0, 0x48 (SP)
ADDIU T0, T0, 0x1
SLT AT, V0, T0
BEQ AT, R0, @@endif_within_max_angle_range
	LI RA, @@return
	ADDIU A0, SP, 0x1C
	J copy_vector
	LW A1, 0x4C (SP)
@@endif_within_max_angle_range:

ADDIU A0, SP, 0x28
ADDIU A1, SP, 0x10
JAL cross_product
SLL A2, A0, 0x0

JAL cos_u16
LW A0, 0x48 (SP)

ADDIU A0, SP, 0x10
SLL A1, A0, 0x0
JAL scale_vector_3d
MOV.S F12, F0

JAL sin_u16
LW A0, 0x48 (SP)

ADDIU A0, SP, 0x1C
SLL A1, A0, 0x0
JAL scale_vector_3d
MOV.S F12, F0

ADDIU A0, SP, 0x10
ADDIU A1, SP, 0x1C
JAL add_vectors_3d
LW A2, 0x4C (SP)

; Normalize again to eliminate drift from rounding errors
SLL A0, A2, 0x0
JAL normalize_vector
SLL A1, A2, 0x0

LW V0, 0x38 (SP)

@@return:
LW RA, 0x3C (SP)
LW A0, 0x40 (SP)
LW A1, 0x44 (SP)
LW A2, 0x48 (SP)
LW A3, 0x4C (SP)
JR RA
ADDIU SP, SP, 0x40


/* vector_to_yaw_and_pitch
Computes the yaw and pitch of a vector.
Preserves the value of the A0 register
args:
	A0 - [pointer] pointer to vector
returns:
	V0 - yaw
	V1 - pitch
*/
vector_to_yaw_and_pitch:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW A0, 0x18 (SP)

L.S F12, 0x8 (A0)
JAL atan2s
L.S F14, 0x0 (A0)
SW V0, 0x10 (SP)

L.S F4, 0x0 (A0)
L.S F5, 0x8 (A0)
MUL.S F4, F4, F4
MUL.S F5, F5, F5
ADD.S F4, F4, F5
SQRT.S F12, F4
L.S F14, 0x4 (A0)
JAL atan2s
NEG.S F14, F14

SLL V1, V0, 0x0
LW V0, 0x10 (SP)

LW A0, 0x18 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
