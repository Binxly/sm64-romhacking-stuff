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
g_save_file_num equ 0x8032DDF4		; short -- current save file number (starts at 1, game usually subtracts one from this before using it)
g_display_list_head equ 0x8033B06C	; pointer

; Mario struct
m_action equ 0xC		; unsigned int
m_hitstun equ 0x26		; short -- invulnerability frames
m_peak_height equ 0xBC	; float -- Mario's highest y co-ordinate since he last touched the ground. Used for fall damage
m_health equ 0xAE		; short -- upper byte is integer health, lower byte is 1/256th health units
m_area equ 0x90			; pointer
m_camera equ 0x94		; pointer
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
m_ceiling_ptr equ 0x64	; pointer
m_wall_ptr equ 0x60		; pointer
m_floor_ptr equ 0x68	; pointer
m_hurt_counter equ 0xB2	; unisgned byte -- if > 0, damage mario by 1/4 health next frame and decrement
m_heal_counter equ 0xB3 ; unsigned byte -- same as above, but heals

; Object struct
o_move_angle_pitch equ 0xC4		; int (sign extended short) 
o_move_angle_yaw equ 0xC8		; int (sign extended short)
o_move_angle_roll equ 0xCC		; int (sign extended short) -- useless?
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
o_intangibility_timer equ 0x09C	; int -- make negative to be infinite
o_opacity equ 0x17C				; int (but only the lower byte actually matters)
o_floor_height equ 0xE8			; float -- height of the floor beneath the object
o_num_loot_coins equ 0x198		; integer
o_animation_frame equ 0xF0		; integer
o_collision_pointer equ 0x218	; pointer

; collision triangle struct
t_collision_type equ 0x0		; unsigned short
t_object equ 0x2C				; pointer -- pointer to the object this collision triangle belongs to, or NULL (0) if it's level geometry
t_min_y equ 0x6					; float
t_max_y equ 0x8					; float
t_normal_x equ 0x1C				; float
t_normal_y equ 0x20				; float
t_normal_z equ 0x24				; float

/* Functions */ ; TODO: document these and add more
set_object_hitbox equ 0x802A34A4
set_animation equ 0x8029F4B4
set_animation_and_check_frame equ 0x802FA39C
check_done_animation equ 0x8029FF04
set_sound equ 0x8031EB00
play_sound_2 equ 0x802CA1E0
create_sound_spawner equ 0x802CA144
get_dist_2d equ 0x8029E27C
sqrt equ 0x80323A50
decompose_speed equ 0x802A1308
decompose_speed_and_move equ 0x802A120C
obj_update_floor_and_walls equ 0x802A2320
process_collision equ 0x803839CC
set_mario_speed equ 0x80251708
set_mario_action equ 0x80252CF4
mark_object_for_deletion equ 0x802A0568
create_star equ 0x802F2B88
get_nearest_object_with_behaviour equ 0x8029F95C
atan2s equ 0x8037A9A8
shake_screen equ 0x802A50FC
spawn_particles equ 0x802A32AC
print_int equ 0x802D62D8
turn_move_angle_towards_target_angle equ 0x8029E5EC
is_animation_playing equ 0x8029FF04
show_dialog equ 0x802A4960
obj_show_dialog equ 0x802A4BE4
scale_object equ 0x8029F404
advance_rng equ 0x80383BB0
find_floor equ 0x80381900
get_random_float equ 0x80383CB4
obj_angle_to_home equ 0x802A2748
obj_xz_dist_from_home equ 0x802A1634
take_damage_and_knockback equ 0x8024D998
level_trigger_warp equ 0x8024A9CC
spawn_star equ 0x802F2B88

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
a0: [short] floor slope angle -- uses degrees instead of the usual angle format because reasons (make negative to prevent it from walking off edges)
*/
obj_move_standard equ 0x802A2348

/* set_music
a0: [byte] music channel? (can be 0, 1, or 2. You can have up to 3 songs playing at the same time by putting them on different channels)
a1: [byte] music ID (same value that SM64 Editor shows for music)
a2: [short] ?????? (set to 0)
*/
set_music equ 0x80320544

/* memcpy
a0: [pointer] destination
a1: [pointer] source
a2: [int] bytes
*/
memcpy equ 0x803273F0

/* obj_was_attacked
[out] v0: non-zero if the object was attacked (eg. punched, jumped at from below,
ground pounded, or anything else that would destroy a breakable box)
*/
obj_was_attacked equ 0x802A51AC

/* get_or_set_camera_mode
a0: [byte] 0 = do not change camera, 1 = switch to Mario cam, 2 = switch to Lakitu cam
[out] v0: the current camera (1 = Mario, 2 = Lakitu)
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
