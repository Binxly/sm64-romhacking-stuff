; Hack to allow partially transparency on particles where you can't set
; o_opacity if using the spawn_particles function to spawn them
 
make_half_transparent:
BEQ A0, R0, @@skip
LW T0, 0x8032DF04
BEQ T0, R0, @@load_other
NOP
	B @@set_opacity
	LW T0, 0x1C (T0)
@@load_other:
LW T0, 0x8032DF00
@@set_opacity:
SETU T1, 0x7F
J 0x8029D924
SW T1, o_opacity (T0)
@@skip:
J 0x8029D924
NOP

make_slightly_transparent:
BEQ A0, R0, @@skip
LW T0, 0x8032DF04
BEQ T0, R0, @@load_other
NOP
	B @@set_opacity
	LW T0, 0x1C (T0)
@@load_other:
LW T0, 0x8032DF00
@@set_opacity:
SETU T1, 0xBF
J 0x8029D924
SW T1, o_opacity (T0)
@@skip:
J 0x8029D924
NOP
