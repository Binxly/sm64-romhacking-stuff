/* labels.asm + helper-functions.asm
Falcobuster's Labels and Helper Functions v2.4.0
These two files are public domain. You may use, modify, and distribute them
however you wish without restriction. Preserving this header comment is
appreciated, but not required.
https://gitlab.com/mpharoah/sm64-romhacking-stuff
*/

; NOTE: some types defining rotation are listed as "int (sign extended short)"
; This means that the value is stored as a signed 32-bit integer, but in normal
; gameplay it's really just a signed 16-bit short that has been sign extended to
; 32 bits. Before storing a rotation, I usually do this: (assuming rotation is in AT)
; SLL AT, AT, 0x10
; SRA AT, AT, 0x10
; This ensures that the value is a 16-bit value sign extended to 32 bits.

; Global structs
g_mario equ 0x8033B170				; struct
g_current_obj_ptr equ 0x80361160	; pointer
g_mario_obj_ptr equ 0x80361158		; pointer
g_camera equ 0x8033C520				; struct
g_is_invulnerable equ 0x8033B272	; short (boolean) -- is Mario currently invulnerable
g_displayed_coins equ 0x8033B262	; short -- number of coins shown on the HUD (not the same as actual coins)
g_level_num equ 0x8032DDF8			; short -- level number shown in Quad64
g_course_num equ 0x8033BAC6			; short -- course number shown in game (save file uses this minus 1)
g_camera_position equ 0x8033C6A4	; float[3] -- x, y, and z co-ordinates of the camera (read-only)
g_camera_fov equ 0x8033C5A4			; float -- camera field of view
g_save_file_num equ 0x8032DDF4		; short -- current save file number (starts at 1, game usually subtracts one from this before using it)
g_display_list_head equ 0x8033B06C	; pointer

; Mario struct
m_action equ 0xC		; unsigned int
m_hitstun equ 0x26		; short -- invulnerability frames
m_peak_height equ 0xBC	; float -- Mario's highest y co-ordinate since he last touched the ground. Used for fall damage
m_health equ 0xAE		; short -- upper byte is integer health, lower byte is 1/256th health units
m_area equ 0x90			; pointer
m_camera equ 0x94		; pointer
m_controller equ 0x9C	; pointer -- see controller struct below
m_coins equ 0xA8		; short
m_stars equ 0xAA		; short
m_lives equ 0xAC		; short
m_x equ 0x3C			; float
m_y equ 0x40			; float
m_z equ 0x44			; float
m_speed_x equ 0x48		; float
m_speed_y equ 0x4C		; float
m_speed_z equ 0x50		; float
m_speed_h equ 0x54		; float
m_angle_pitch equ 0x2C	; short
m_angle_yaw equ 0x2E	; short
m_angle_roll equ 0x30	; short
m_ceiling_ptr equ 0x64	; pointer
m_wall_ptr equ 0x60		; pointer
m_floor_ptr equ 0x68	; pointer
m_floor_height equ 0x70	; float
m_hurt_counter equ 0xB2	; unisgned byte -- if > 0, damage mario by 1/4 health next frame and decrement
m_heal_counter equ 0xB3 ; unsigned byte -- same as above, but heals

; Controller struct
c_analog_short_x equ 0x0	; short -- analog stick horizontal position [-80,80]
c_analog_short_y equ 0x2	; short -- analog stick vertical position [-80,80]
c_analog_float_x equ 0x4	; float -- analog stick horizontal position [-64,64]
c_analog_float_y equ 0x8	; float -- analog stick vertical position [-64,64]
c_analog_float_mag equ 0xC	; float -- analog stick distance from centre [0,64]
c_buttons_held equ 0x10		; unsigned short -- flags for buttons currently pressed (see constants below)
c_buttons_pressed equ 0x12	; unsigned short -- flags for buttons pressed this frame (see constants below)

; Controller Button Flag Constants
C_BUTTON_C_RIGHT equ		0x0001
C_BUTTON_C_LEFT equ			0x0002
C_BUTTON_C_DOWN equ			0x0004
C_BUTTON_C_UP equ			0x0008
C_TRIGGER_R equ				0x0010
C_TRIGGER_L equ				0x0020
C_BUTTON_D_PAD_RIGHT equ	0x0100
C_BUTTON_D_PAD_LEFT equ		0x0200
C_BUTTON_D_PAD_DOWN equ		0x0400
C_BUTTON_D_PAD_UP equ		0x0800
C_BUTTON_START equ			0x1000
C_TRIGGER_Z equ				0x2000
C_BUTTON_B equ				0x4000
C_BUTTON_A equ				0x8000

; Object struct
o_move_angle_pitch equ 0xC4		; int (sign extended short) 
o_move_angle_yaw equ 0xC8		; int (sign extended short)
o_move_angle_roll equ 0xCC		; int (sign extended short)
o_face_angle_pitch equ 0xD0		; int (sign extended short)
o_face_angle_yaw equ 0xD4		; int (sign extended short)
o_face_angle_roll equ 0xD8		; int (sign extended short)
o_interaction equ 0x130			; unsigned int
o_interaction_status equ 0x134	; unsigned int
o_state equ 0x14C				; unsigned int -- A.K.A. action
o_timer equ 0x154				; int -- automatically increments every frame
o_angle_to_mario equ 0x160		; int (sign extended short)
o_distance_to_mario equ 0x15C	; float
o_health equ 0x184				; int
o_prev_obj equ 0x04				; pointer
o_x equ 0xA0					; float
o_y equ 0xA4					; float
o_z equ 0xA8					; float
o_home_x equ 0x164				; float
o_home_y equ 0x168				; float
o_home_z equ 0x16C				; float
o_gravity equ 0xE4				; float -- normal gravity is negative (-4 for Mario)
o_bounce equ 0x158				; float
o_buoyancy equ 0x174			; float
o_speed_h equ 0xB8				; float -- horizontal speed. Use the decompose_speed function to set o_speed_x and o_speed_y
o_speed_x equ 0xAC				; float
o_speed_y equ 0xB0				; float
o_speed_z equ 0xB4				; float
o_move_flags equ 0xEC			; unsigned int
o_num_collided_objects equ 0x76	; short
o_collided_objects equ 0x78		; pointer[4] -- 4 pointers stored contiguously
o_gfx_flags equ 0x2				; unsigned short
o_scale_x equ 0x2C				; float
o_scale_y equ 0x30				; float
o_scale_z equ 0x34				; float
o_param2 equ 0x144				; int -- for some reason, the game copies B.Param 2 here ¯\_(ツ)_/¯
o_arg0 equ 0x188				; byte -- B. Param 1
o_arg1 equ 0x189				; byte -- B. Param 2
o_arg2 equ 0x18A				; byte -- B. Param 3
o_arg3 equ 0x18B				; byte -- B. Param 4
o_parent equ 0x68				; pointer
o_render_distance equ 0x19C		; float
o_collision_distance equ 0x194	; float
o_intangibility_timer equ 0x9C	; int -- make negative to be infinite
o_opacity equ 0x17C				; int (but only the lower byte actually matters)
o_floor_ptr equ 0x1C0			; pointer -- pointer to floor triangle beneat the object (doesn't work for Mario object)
o_floor_height equ 0xE8			; float -- height of the floor beneath the object (doesn't work for Mario object)
o_num_loot_coins equ 0x198		; integer
o_animation_frame equ 0x40		; short
o_collision_pointer equ 0x218	; pointer

; collision triangle struct
t_collision_type equ 0x0		; unsigned short
t_object equ 0x2C				; pointer -- pointer to the object this collision triangle belongs to, or NULL (0) if it's level geometry
t_min_y equ 0x6					; float
t_max_y equ 0x8					; float
t_normal_x equ 0x1C				; float
t_normal_y equ 0x20				; float
t_normal_z equ 0x24				; float

/* Functions */

/* set_object_hitbox 
a0: [pointer] object to set hitbox for
a1: [pointer] pointer to hitbox
Hitbox struct format:
	[uint] interaction
	[byte] vertical offset down
	[sbyte] damage (for damaging interactions) or coin value (for coin interaction)
	[sbyte] health
	[sbyte] loot coins
	[short] hitbox radius
	[short] hitbox height
	[short] hurtbox radius
	[short] hurtbox height
*/
set_object_hitbox equ 0x802A34A4

/* set_animation
Sets the object's current animation
a0: [int] animation index
*/
set_animation equ 0x8029F4B4

/* set_animation
Sets the object's current animation (does not reset the animation if the animation
is the same as the current one), and returns whether the current animation frame
is equal to a1
a0: [int] animation index
a1: [int] check if the current animation frame is equal to this value
[out] v0: [bool] non-zero if the current animatino frame is equal to A1
*/
set_animation_and_check_frame equ 0x802FA39C

/* check_done_animation
Checks if the current animation has finished
[out] v0: [bool] non-zero if the current animation has completed
*/
check_done_animation equ 0x8029FF04

/* set_sound
Plays a sound, using a vector from the object to the camera to determine volume
a0: [uint] sound
a1: [pointer] pointer to a vector from the sound origin to the camera (add 0x54 to an object pointer to get this pointer)
*/
set_sound equ 0x8031EB00

/* play_sound
Plays a sound originating at the current object (gfx flag 0x1 must be set)
a0: [unit] sound
*/
play_sound equ 0x802CA1E0

/* create_sound_spawner
Spawns a sound spawner at the current object's position
a0: [unit] sound
*/
create_sound_spawner equ 0x802CA144

/* get_dist_3d
Gets the distance between two objects
a0: [pointer] object 1
a1: [pointer] object 2
[out] f0: [float] distance
*/
get_dist_3d equ 0x8029E2F8

/* get_dist_2d
Gets the lateral distance (on the xz plane) between two objects
a0: [pointer] object 1
a1: [pointer] object 2
[out] f0: [float] distance
*/
get_dist_2d equ 0x8029E27C

/* sqrt
Computes the square root of a number
NOTE: You can simply use the MIPS instruction SQRT.S instead
f12: number to square root
[out] f0: result
*/
sqrt equ 0x80323A50

/* decompose_speed
Sets the values of o_speed_x and o_speed_z using the values of o_speed_h and
o_move_angle_yaw
*/
decompose_speed equ 0x802A1308

/* decompose_speed
Sets the values of o_speed_x and o_speed_z using the values of o_speed_h and
o_move_angle_yaw, and then moves the object using these speeds
*/
decompose_speed_and_move equ 0x802A120C

/* obj_update_floor_and_walls
Upadates the object's references to floors and walls. Required to correctly
resolve move flags and get collided with floors and walls
*/
obj_update_floor_and_walls equ 0x802A2320


/* process_collision
Processes collision for objects with triangle collision. Would typically be
called after the behaviour loop by the behaviour script, though you can just
call it at the end of your behaviour loop instead
*/
process_collision equ 0x803839CC

/* are_objects_colliding
a0: [pointer] object 1
a1: [pointer] object 2
[out] v0: [bool] non-zero if the objects are colliding
*/
are_objects_colliding equ 0x802A1424

/* set_mario_speed
Sets Mario's forward velocity
a0: [pointer] pointer to mario struct (use g_mario)
a1: [float] speed
*/
set_mario_speed equ 0x80251708

/* set_mario_action
Sets Mario's action. This is different than just directly setting m_action, since
it also executes code based on the action transition
a0: [pointer] pointer to mario struct (use g_mario)
a1: [uint] action
a2: [uint] action argument
*/
set_mario_action equ 0x80252CF4

/* mark_object_for_deletion
Marks the object slot as free, effectively deleting the object
a0: [pointer] object to delete
*/
mark_object_for_deletion equ 0x802A0568

/* spawn_star
Spawns a star that initally appears at the current object's coordinates, then
flies to the given coordinates in the star spawn cutscene. B. Param 1 is copied
from the current object. Does NOT return a pointer to the spawned star
f12: [float] x position
f14: [float] y position
a2: [float] z position
*/
spawn_star equ 0x802F2B88

/* get_nearest_object_with_behaviour
Gets the nearest object with the given behaviour script, or NULL (0) if no such
object exists. "Nearest" is with respect to the current object
a0: [segmented pointer] behaviour -- same value you would use in Quad64
[out] v0: [pointer] nearest object or NULL (0)
*/
get_nearest_object_with_behaviour equ 0x8029F95C

/* atan2s
Computes the arctangent, returning the resulting angle as a short. Note that
this function takes the difference in Z co-ordinates first, THEN the difference
in X co-ordinates second, which is the opposite of what an atan2 function would
normally do. Because reasons.
f12: [float] difference in z co-ordinates
f14: [float] difference in x co-ordinates
[out] v0: [short] angle
*/
atan2s equ 0x8037A9A8

/* shake_screen
The game always passes in a value of 1 as the argument, but it passes this into
another function that branches to different code depending on if the value is 1,
2, 3, or 4. Not sure what these other values do yet.
a0: [int] effect type???? (use 1)
*/
shake_screen equ 0x802A50FC

/* spawn_particles
Spawns particles at the current object's position.
a0: [pointer] pointer to SpawnParticlesInfo struct
SpawnParticlesInfo struct format:
	[sbyte] behaviour argument
	[sbyte] number of particles
	[byte] modelId
	[sbyte] vertical offset
	[sbyte] base horizontal velocity
	[sbyte] random horizontal velocity range
	[sbyte] base vertical velocity
	[sbyte] random vertical velocity range
	[sbyte] gravity
	[sbyte] drag
	[float] base size
	[float] random size range
*/
spawn_particles equ 0x802A32AC

/* print
Prints text to the screen using the colourful text. Not all characters are
supported (there is no J, Q, V, X, or Z). It is safe to call this function
anywhere without messing up the graphics context. This function supports a
minimal subset of standard C printf formats, supporting only %d and %x formats.
For example, to print a 0-padded 4-digit hexidecimal value, use %04x
a0: [int] x screen position
a1: [int] y screen position
a2: [pointer] pointer to a null-terminated string describing what to print
a3: [int] argument value (number to print where %d or %x appears)
*/
print equ 0x802D62D8

/* turn_move_angle_towards_target_angle
Moves the current object's o_move_angle_yaw towards a target value
a0: [short] target angle
a1: [short] maximum angle to change o_move_angle_yaw by
[out] v0: [bool] non-zero if the object is already facing the target direction
*/
turn_move_angle_towards_target_angle equ 0x8029E5EC

/* turn_angle
Moves an angle towards a target angle
a0: [short] starting angle
a1: [short] target angle
a2: [short] maximum angle change
[out] v0: [short] resulting angle
*/
turn_angle equ 0x8029E530

/* abs_angle_diff
Gets the absolute difference between two angles
a0: [short] angle 1
a1: [short] angle 2
[out] v0: [short] difference
*/
abs_angle_diff equ 0x802A11A8

/* get_angle_to_home
Gets the angle to the current object's home position
[out] v0: [short] angle to home
*/
get_angle_to_home equ 0x802A2748

/* is_animation_playing
[out] v0: [bool] non-zero if the current object is playing an animation
*/
is_animation_playing equ 0x8029FF04

/* get_random_short
[out] v0: [ushort] a random 16-bit value
*/
get_random_short equ 0x80383BB0

/* get_random_float
[out] f0: [float] a random float in the range [0,1)
*/
get_random_float equ 0x80383CB4

/* scale_object
a0: [pointer] object to scale
a1: [float] scaling value
*/
scale_object equ 0x8029F404

/* find_floor
Finds the floor beneath the given point, storing a pointer to the floor triangle
at the RAM address given in A3, and returning the floor height in F0
f12: x position
f14: y position
a2: z position
[ref] a3: [pointer] memory address to store the pointer to the floor at (usually you would point to somewhere on the stack)
[out] f0: [float] floor height
*/
find_floor equ 0x80381900

/* obj_angle_to_home
Returns the angle from the current object's current position to its home position
[out] v0: [short] angle
*/
obj_angle_to_home equ 0x802A2748

/* obj_xz_dist_from_home
Returns the lateral distance (on the xz plane) from the current object to its home
[out] f0: [float] distance
*/
obj_xz_dist_from_home equ 0x802A1634

/* take_damage_and_knockback
Causes Mario to take damage and knockback
a0: [pointer] pointer to mario struct (use g_mario)
a1: [pointer] pointer to the object that is the source of the damage
[out] v0: [bool] non-zero if Mario did take damage (could be 0 if Mario is invincible)
*/
take_damage_and_knockback equ 0x8024D998

/* obj_show_dialog
Shows a dialog message and puts Mario into the reading message action. You should
call this every frame until it returns a non-zero value
a0: [int] something to do with Mario's state?? (use 2)
a1: [int] dialog flags??? (use 1)
a2: [int] dialog type maybe???? (use 0xA2)
a3: [int] messageId (same ID you would use in text manager)
[out] v0: [bool] dialog response (0 if dialog has not been closed yet)
*/
obj_show_dialog equ 0x802A4BE4

/* segmented_to_virtual
a0 [segmented pointer]: segmented pointer
[out] v0 [pointer]: pointer
*/
segmented_to_virtual equ 0x80277F50

/* spawn_object 
a0: [pointer] parent object
a1: [short] model ID
a2: [segmented pointer] behaviour script
[out] v0: [pointer] spawned object
*/
spawn_object equ 0x8029EDCC

/* create_object
a0: [pointer] behaviour script -- NOT a segmented pointer!
[out] v0: [pointer] spawned object
*/
create_object equ 0x802C9F04

/* copy_object_pos
a0: [pointer] object to copy position to
a1: [pointer] object to copt position from
*/
copy_object_pos equ 0x8029F120

/* obj_move_standard
a0: [short] floor slope angle -- uses degrees instead of the usual angle format because reasons (make negative to prevent it from walking off edges. Might require additional flags for this to work correctly?)
*/
obj_move_standard equ 0x802A2348

/* simple_move
Moves the current object using its x, y, and z speeds
*/
move_simple equ 0x8029F070

/* set_music
a0: [byte] music channel? (can be 0, 1, or 2. You can have up to 3 songs playing at the same time by putting them on different channels)
a1: [byte] music ID (same value that SM64 Editor shows for music)
a2: [short] ?????? (set to 0)
*/
set_music equ 0x80320544

/* memcpy
Copy memory from one location to another. This just uses a loop of LBU and SH
instructions. If the size of the data you are copying is a multiple of 4, it is
more efficient to instead use wordcopy (from helper-functions.asm)
a0: [pointer] destination
a1: [pointer] source
a2: [int] bytes
*/
memcpy equ 0x803273F0

/* obj_was_attacked
[out] v0: [bool] non-zero if the object was attacked (eg. punched, jumped at from below,
ground pounded, or anything else that would destroy a breakable box)
*/
obj_was_attacked equ 0x802A51AC

/* get_or_set_camera_mode
a0: [byte] 0 = do not change camera, 1 = switch to Mario cam, 2 = switch to Lakitu cam
[out] v0: [byte] the current camera (1 = Mario, 2 = Lakitu)
*/
get_or_set_camera_mode equ 0x80288718

/* spawn_orange_number
a0: [byte] number to display
a1: [float] x offset
a2: [float] y offset (game uses 0 for red coins and secrets and -40 for treasure chests and water rings)
a3: [float] z offset
*/
spawn_orange_number equ 0x802E5C6C

/* angle_to_object
a0: [pointer] source object
a1: [pointer] target object
[out] v0: [short] angle
*/
angle_to_object equ 0x8029E694

/* save_file_get_star_flags
a0: [short] save file minus 1
a1: [short] course number minus 1
[out]: v0 [byte] star/cannon flags
*/
save_file_get_star_flags equ 0x8027A1C8

/* print_encoded_text
Call encode_text (see helper-functions.asm) first to convert ASCII text into
encoded text. You must also call begin_print_encoded_text before calling this
function, and then call end_print_encoded_text after all of your calls to
print_encoded_text.
a0: [short] x position
a1: [short] y position
a2: [pointer] encoded text
*/
print_encoded_text equ 0x802D77DC

/* dma_read
Load a chunk of data from the ROM into RAM
a0: [pointer] memory addres to being writing to
a1: [ROM address] ROM address to start reading from
a2: [ROM address] ROM address to stop reading at
*/
dma_read equ 0x80278504

/* malloc
Tries to allocate memory on the main pool (not the same as malloc in C)
a0: [uint] bytes of memory to allocate
a1: [uint] side (0 = left side, 1 = right side)
[out] v0: [pointer] pointer to allocated memory, or NULL if not enough space
*/
malloc equ 0x80278120

/* free
Frees memory that was allocated on the main pool.
IMPORTANT: This must be the most recently allocated block from its side of the
memory pool!
a0: [pointer] pointer that was allocated using malloc
[out] v0: [uint] free space remaining in the pool
*/
free equ 0x80278238

/* matrix_transform
Applies an affine transformation defined by a 4x4 matrix to a 3D vector of shorts.
The vector is modified in-place
a0: [pointer] pointer to the 4x4 matrix of floats
[ref] a1: [pointer] pointer to the 3D vector of shorts to transform
*/
matrix_transform equ 0x8037A348


;; TODO: 0x8029f514 sets animation and animation speed? (int, float)
