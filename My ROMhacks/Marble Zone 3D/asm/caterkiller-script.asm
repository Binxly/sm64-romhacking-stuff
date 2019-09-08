.orga 0x21C7E4 ; overwrites behaviour 0x130029E4 (Static checkered platform (unused?))
.area 0x2C
@beh_caterkiller_body:
.word 0x00040000
.word 0x11012041
.word 0x1E000000
.word 0x2D000000
.word 0x0C000000, beh_caterkiller_head_init
.word 0x08000000
.word 0x0C000000, beh_caterkiller_head_loop
.word 0x09000000
.endarea
