.orga 0x21B544 ; overwrites 0x13001744 (Beta Boo key (inside of Boo))
.area 0x34
.word 0x00090000
.word 0x11010001
.word 0x2A000000, 0x08012D70
.word 0x0E4301F4
.word 0x0C000000, beh_item_box_init
.word 0x08000000
.word 0x0C000000, beh_item_box_loop
.word 0x09000000
.endarea
