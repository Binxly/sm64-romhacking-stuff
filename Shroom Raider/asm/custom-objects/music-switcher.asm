; B. Param 1,2 [float16] radius
; B. Param 3 [byte] height (tens of units)
; B. Param 4 [byte] track #

.definelabel beh_music_switcher_impl, (org()-0x80000000)
;BHV_START OBJ_LIST_GENERIC
BHV_EXEC @init
BHV_LOOP_BEGIN
	BHV_EXEC @loop
BHV_LOOP_END

@_radius equ 0xF4
@_height equ 0xF8

@init:
LW T0, g_current_obj_ptr
LHU T1, o_arg0 (T0)
SLL T1, T1, 0x10
SW T1, @_radius (T0)
LBU AT, o_arg2 (T0)
MTC1 AT, F4
LUI AT, 0x4120
MTC1 AT, F5
CVT.S.W F4, F4
MUL.S F4, F4, F5
JR RA
S.S F4, @_height (T0)

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LI T0, g_mario
L.S F4, m_y (T0)
L.S F5, o_y (S0)
C.LT.S F4, F5
L.S F6, @_height (S0)
BC1T @return
ADD.S F5, F5, F6
C.LE.S F4, F5
NOP
BC1F @return
LW A0, g_mario_obj_ptr
JAL get_dist_2d
MOVE A1, S0
L.S F4, @_radius (S0)
C.LE.S F0, F4
SETU A0, 0x0
BC1F @return
LBU A1, o_arg3 (S0)
JAL set_music
SETU A2, 0x0
LBU T0, o_arg3 (S0)
SLTI AT, T0, 0x23
BNE AT, R0, @endif_get_track_info
	ADDIU T0, T0, 0xFFDD
	SLL T0, T0, 0x3
	LI T1, @music_table
	ADDU T0, T0, T1
	LW A0, 0x0 (T0)
	JAL set_music_info
	LW A1, 0x4 (T0)
@endif_get_track_info:
JAL mark_object_for_deletion
MOVE A0, S0

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@music_table:
.word @track_1a, @track_1b
.word @track_2a, @track_2b
.word @track_3a, @track_3b
.word @track_4a, @track_4b

@track_1a:
.ascii "First Steps (Celeste)\\"
.asciiz "Artist: Lena Raine"
@track_1b:
.ascii "MIDI Ver.: PickPig\\"
.asciiz "SM64 Seq: Falcobuster"

@track_2a:
.ascii "Boss Theme (Majora's Mask)\\"
.asciiz "Artist: Koji Kondo"
@track_2b:
.asciiz "SM64 Seq: EDARK 900"

@track_3a:
.ascii "Shadow Temple (OOT)\\"
.asciiz "Artist: Koji Kondo"
@track_3b:
.asciiz "SM64 Seq: DobieMeltfire"

@track_4a:
.ascii "Metallic Madness (Sonic CD)\\"
.asciiz "Artist: Sonic Team"
@track_4b:
.ascii "MIDI Ver: Pablo's Corner\\"
.asciiz "SM64 Seq: Pablo's Corner"

.align 4

init_music_info:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

LI A0, @track_1a
JAL encode_text
MOVE A1, A0

LI A0, @track_1b
JAL encode_text
MOVE A1, A0

LI A0, @track_2a
JAL encode_text
MOVE A1, A0

LI A0, @track_2b
JAL encode_text
MOVE A1, A0

LI A0, @track_3a
JAL encode_text
MOVE A1, A0

LI A0, @track_3b
JAL encode_text
MOVE A1, A0

LI A0, @track_4a
JAL encode_text
MOVE A1, A0

LI A0, @track_4b
JAL encode_text
MOVE A1, A0

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
