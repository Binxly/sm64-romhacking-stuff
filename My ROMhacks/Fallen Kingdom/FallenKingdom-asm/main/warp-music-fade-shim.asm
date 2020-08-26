warp_music_fade_shim:
	LHU T0, g_level_num
	SETU AT, 0x17
	BNE T0, AT, @@continue
	
	LHU T0, 0x8033B252
	SETU AT, 0x13
	BNE T0, AT, @@continue
	NOP
	
	JR RA
	NOP
	
	@@continue:
	J 0x8024922C
	NOP
