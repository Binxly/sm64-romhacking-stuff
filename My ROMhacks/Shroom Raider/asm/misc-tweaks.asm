; set max health to 20
.orga 0xF224 :: SLTI AT, T0, 0x1481
.orga 0xF234 :: ADDIU T2, R0, 0x1480
.orga 0x10028 :: ADDIU T4, R0, 0x1480
.orga 0x14800 :: ADDIU T0, R0, 0x4F
.orga 0x14880 :: ADDIU T6, R0, 0x4F
.orga 0x14CB0 :: ADDIU T4, R0, 0x4F
.orga 0x14D40 :: ADDIU T0, R0, 0x4F
.orga 0x14DCC :: ADDIU T0, R0, 0x4F
.orga 0x14E8C :: ADDIU T5, R0, 0x4F
.orga 0x14F84 :: ADDIU T9, R0, 0x4F

; Disable low poly Mario
.orga 0x12A7C6
.halfword 0x2E18

; Disable intro cutscene
.orga 0x6BC4
.fill 20, 0

; Bats do 2 damage
.orga 0xED89D
.byte 2

; Bats don't drop coins
.orga 0xED89F
.byte 0

; Lakitu don't drop coins
.orga 0xED973
.byte 0

; No walljumping or wallrunning out of quicksand/tall grass
.orga 0xD4A4
LI T0, g_mario
LW T1, g_mario_obj_ptr
LH AT, 0x2E (T0)
SW AT, 0x110 (T1)
LI T9, 0x03000885
NOP :: NOP :: NOP

; Change Mr. Blizzard interaction type
.orga 0xEDB00
.word 0x00000008

; Mr. Blizzard should not drop coins
.orga 0xEDB07
.byte 0

; Can Revert to Last Checkpoint anywhere (anti-softlock)
.orga 0x97B74
NOP

; Increase render area of geo layouts using shadows to 630 (up from 300)
.orga 0x3860E
.halfword 630

; Recolour fire to be frost
.orga 0xACD888
.word 0x96CBE764

; Skip File Select (taken from Ultimate Tweak Pack)
.orga 0x26A0C8
.word 0x34040000
.word 0x01100015
.word 0x002ABCA0
.word 0x002AC6B0
.word 0x15000000

; Set ROM Name
.orga 0x20
.ascii "Shroom Raider"
.fill 7,0x20

; Disable Demos
.orga 0x21F52C
J 0x8016F108
