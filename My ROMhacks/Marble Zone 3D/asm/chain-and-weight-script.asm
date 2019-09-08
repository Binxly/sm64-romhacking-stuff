.orga 0x21D220 ; overwrites 0x13003420 (beta green shell)
.area 0x34
.word 0x00090000
.word 0x11010041
.word 0x2D000000
.word 0x0E4301F4
.word 0x0C000000, beh_weight_init
.word 0x08000000
.word 0x0C000000, beh_weight_loop
.word 0x09000000
.endarea
