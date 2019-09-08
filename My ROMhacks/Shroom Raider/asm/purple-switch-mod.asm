; Changes the purple switch to load the timer duration from the B. Params
; BParam 1,2 [short] time until ticking speeds ups
; BParam 3,4 [short] time until it expires

.orga 0x6C3AC
NOP

.orga 0x6C3C4
LHU T4, o_arg0 (T0)
J 0x802B13F8
LHU T5, o_arg2 (T0)

.orga 0x6C404
SLT AT, T0, T4

.orga 0x6C44C
SLT AT, T3, T5

; Recolour switch
.orga 0xA8D944
.incbin "../models/switch/texture.bin"

.orga 0xA8D8E2
.halfword 0x046D
.skip 30
.halfword 0x046D
.skip 30
.halfword 0x046D
.skip 30
.halfword 0x046D
