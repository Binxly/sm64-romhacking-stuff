.definelabel beh_explosion, (org()-0x80000000)
.word 0x000C0000
.word 0x11010001
.word 0x21000000
.word 0x0C000000, @beh_explosion_init
.word 0x08000000
.word 0x0C000000, @beh_explosion_loop
.word 0x09000000

@beh_explosion_init:
LUI A0, 0x5630
J play_sound_2
ORI A0, A0, 0x8081

@beh_explosion_loop:
LW T0, g_current_obj_ptr
LW T1, o_timer (T0)
ORI AT, R0, 0x10
BEQ T1, AT, @despawn
SRA T1, T1, 0x2
JR RA
SW T1, o_animation_frame (T0)
@despawn:
J mark_object_for_deletion
SLL A0, T0, 0x0

spawn_explosion:
LI A2, beh_explosion
J spawn_object
ORI A1, R0, 0x48
