; Move coin counter
.orga 0x9E7BA
.halfword 0xF2; icon.x
.skip 6
.halfword 0xBD; icon.y
.skip 10
.halfword 0x102; X.x
.skip 6
.halfword 0xBD; X.y
.skip 18
.halfword 0x110; value.x
.skip 6
.halfword 0xBD; value.y

; Always show HP
.orga 0x9E68C
ORI T0, R0, 0xC8
SH T0, 0x25F4 (T8)
.fill 32, 0

; Move HP to left side
.orga 0xED5F2
.halfword 0x20 ; hp.x
