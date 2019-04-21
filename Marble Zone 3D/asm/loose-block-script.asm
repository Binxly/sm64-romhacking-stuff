.orga 0x21B408 ; overwrites 0x13001608 (Beta trampoline)
.area 0x2C
.word 0x00090000
.word 0x11010001
.word 0x2A000000, 0x08012D70
.word 0x2D000000
.word 0x0E4E00FA
.word 0x08000000
.word 0x0C000000, beh_loose_block_loop
.word 0x09000000
.endarea
