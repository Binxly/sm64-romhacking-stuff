.orga 0x21B578 ; overwrites 0x13001778 (Beta Boo key (outside of Boo))
.area 0x24
.word 0x00090000
.word 0x11010001
.word 0x2D000000
.word 0x2A000000, press_collision
.word 0x08000000
.word 0x0C000000, beh_press_loop
.word 0x09000000
.endarea
