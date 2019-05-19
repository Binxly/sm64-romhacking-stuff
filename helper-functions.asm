/* labels.asm + helper-functions.asm
Falcobuster's Labels and Helper Functions v2.0.0
These two files are public domain. You may use, modify, and distribute them
however you wish without restriction. Preserving this header comment is
appreciated, but not required.
*/

/* sin_u16
Take the sine of an angle stored as an unsigned short
args:
	A0 - [ushort] the angle
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
	A0 - [ushort] the angle
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
LI A2, @debug
JAL print
ORI A0, R0, 0x40

LHU A3, 0x18 (SP)
LI A2, @debug
LW A1, 0x10 (SP)
JAL print
ORI A0, R0, 0x10

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

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
LUI AT, 0x0600
SW AT, 0x0 (T0)
LI AT, 0x02011CC8
SW AT, 0x4 (T0)
LUI AT, 0xFB00
SW AT, 0x8 (T0)
SW A0, 0xC (T0)
ADDIU T0, T0, 0x10
SW.U T0, g_display_list_head
JR RA
SW.L T0, g_display_list_head

/* (print_encoded_text label defined in labels.asm) */

/* end_print_encoded_text
Finished printing encoded text. Call this after all of your calls to
print_encoded_text
*/
end_print_encoded_text:
LW T0, g_display_list_head
LUI AT, 0x0600
SW AT, 0x0 (T0)
LI AT, 0x02011D50
SW AT, 0x4 (T0)
ADDIU T0, T0, 0x8
SW.U T0, g_display_list_head
JR RA
SW.L T0, g_display_list_head

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

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

@debug:
.asciiz "%04x"
.align 4

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
