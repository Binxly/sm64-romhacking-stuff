/* Festive Whomp */
.orga 0x21EE6C ; overwrites 0x1300506C (Flying Bookend)
.area 0x48
.word 0x00090000 ; define behaviour in list 0x09
.word 0x110120C1 ; set object flags
.word 0x27260000, 0x06020A04 ; load animation data
.word 0x2A000000, 0x06020A0C ; set collision pointer
.word 0x28000000 ; animates
.word 0x2D000000 ; set home position
.word 0x320000C8 ; scale x2
.word 0x0C000000, beh_festive_whomp_init
.word 0x08000000
.word 0x0C000000, beh_festive_whomp_loop
.word 0x09000000
.endarea

; alter whomp collision data to extend collision box to the ground and remove the bottom face
.orga 0xA2A346
.halfword 0
.orga 0xA2A34C
.halfword 0
.orga 0xA2A35E
.halfword 0
.orga 0xA2A36A
.halfword 0

.orga 0xA2A376
.halfword 0xA
.orga 0xA2A39C
.halfword 0x0, 0x7, 0x3
.halfword 0x0, 0x4, 0x7
.orga 0xA2A3B4
.halfword 0x41
.halfword 0x42
.halfword 0, 0, 0, 0, 0, 0

; remove whomp shadow (uses shadow object instead)
.orga 0x001D8129
.byte 0x00

; darken  meteor shadow
.orga 0x200F15
.byte 0xFF

; import shadow geo layout into level with modelId 70
.orga 0x2D80180
.word 0x22080046, (whomp_shadow_geo_layout-0x80000000)

; change G_SETCOMBINE command
.orga 0x00FABD69
.word 0xFC147E28, 0x44FE7B3D

; Bowser flame tweaks
.orga 0x00073DAE
.halfword 0x0000

.orga 0x00073E22
.halfword 0xBFC0

.orga 0x00074244
JAL advance_rng
