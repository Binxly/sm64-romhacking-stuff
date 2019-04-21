/* Meteor Behaviour Script */
beh_meteor_script:
.word 0x00040000
.word 0x11010081
.word 0x21000000
.word 0x0E150082
.word 0x0C000000, @beh_meteor_init
.word 0x08000000
.word 0x0C000000, @beh_meteor_loop
.word 0x09000000

@beh_meteor_init:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr
LW T0, o_parent (S0)

LW AT, o_home_x (T0)
SW AT, o_home_x (S0)
LW AT, o_home_z (T0)
SW AT, o_home_z (S0)
LI AT, 0x45034000
MTC1 AT, F5
L.S F4, o_home_y (T0)
S.S F4, o_home_y (S0)
ADD.S F4, F4, F5
S.S F4, o_y (S0)
LW T0, o_timer (T0)
ORI AT, R0, 0xF
DIVU T0, AT
MFHI AT
NOP
BEQ AT, R0, @spawn_above_mario
NOP
JAL get_random_float
NOP
JAL sqrt
MOV.S F12, F0
JAL advance_rng
S.S F0, 0xFC (S0)
JAL angle_to_unit_vector
SLL A0, V0, 0x0
LUI AT, 0x44B3
MTC1 AT, F5
L.S F4, 0xFC (S0)
MUL.S F6, F4, F5
L.S F4, o_home_x (S0)
L.S F5, o_home_z (S0)
MUL.S F0, F0, F6
MUL.S F1, F1, F6
ADD.S F4, F4, F0
ADD.S F5, F5, F1
S.S F4, o_x (S0)
B @finish_init
S.S F5, o_z (S0)

@spawn_above_mario:
LI T0, g_mario
LW AT, m_x (T0)
SW AT, o_x (S0)
LW AT, m_z (T0)
SW AT, o_z (S0)

@finish_init:
LUI AT, 0xC28C
SW AT, o_speed_y (S0)

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@beh_meteor_loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LI A1, 0x803326B4
JAL set_object_hitbox
SLL A0, S0, 0x0

L.S F4, o_y (S0)
L.S F5, o_speed_y (S0)
ADD.S F4, F4, F5
S.S F4, o_y (S0)
L.S F5, o_home_y (S0)
C.LT.S F4, F5
NOP
BC1T @destroy_meteor
NOP

@meteor_return:
SW R0, o_interaction_status (S0)
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@destroy_meteor:
LUI AT, 0x5003
JAL play_sound_2
ORI A0, AT, 0x0081
JAL shake_screen
ORI A0, R0, 0x1
ORI A1, R0, 0xCD
LI A2, (@silent_explosion_script-0x80000000)
JAL spawn_object
SLL A0, S0, 0x0
LI A0, @meteor_particle_info
JAL spawn_particles
NOP
JAL mark_object_for_deletion
SLL A0, S0, 0x0
B @meteor_return
NOP

@meteor_particle_info:
.byte 0x00 ; behParam
.byte 0x03 ; count
.byte 0xB4 ; model
.byte 0x00 ; offsetY
.byte 0x0F ; forwardVelBase
.byte 0x06 ; forwardVelRange
.byte 0x29 ; velYBase
.byte 0x17 ; velYRange
.byte 0xFC ; gravity
.byte 0x00 ; dragStrength
.align 4
.word 0x3F800000 ; sizeBase (float)
.word 0x3FC00000 ; sizeRange (float)

@silent_explosion_script:
.word 0x000C0000
.word 0x11010041
.word 0x21000000
.word 0x2F000000, 0x00000008
.word 0x103E0002
.word 0x10050000
.word 0x2B000000, 0x00960096, 0x00960000
.word 0x101AFFFF
.word 0x0D150064
.word 0x103D00FF
.word 0x08000000
.word 0x0C000000, 0x802EAAD0
.word 0x0F1A0001
.word 0x09000000
