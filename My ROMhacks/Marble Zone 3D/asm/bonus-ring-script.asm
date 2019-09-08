beh_bonus_ring:
.orga 0x21EEB4 ; overwrites 0x130050B4 (spawns bookends)
.area 0x20
.word 0x00060000
.word 0x11012049
.word 0x102A2000
.word 0x10050000
.word 0x08000000
.word 0x0C000000, beh_bonus_ring_loop
.word 0x09000000
.endarea
