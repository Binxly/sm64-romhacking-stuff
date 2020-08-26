; Part of a patch to make ceilings not extend upwards infinitely in the Secret of the Bamboo Forest level

ceiling_collision_shim:
	LHU T1, g_level_num
	SETU AT, 0x4
	BNE T1, AT, @@continue
	L.S F4, 0x4 (SP) ; ceil_y
	C.LT.S F4, F10 ; f10 = check_y
	NOP
	BC1T @@ignore_ceiling
	NOP
	@@continue:
	J 0x8038122C
	NOP
	@@ignore_ceiling:
	J 0x80381244
	NOP
	
mario_find_ceiling_shim:
	LHU T0, g_level_num
	SETU AT, 0x4
	BNE T0, AT, @@continue
	LW T0, 0x20 (SP)
	LI.S F5, 78
	L.S F4, 0x4 (T0)
	SUB.S F4, F4, F5
	MAX.S F14, F14, F4
	@@continue:
	J 0x80381264
	NOP
