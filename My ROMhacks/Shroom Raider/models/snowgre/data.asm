ogre_lighting:
.word 0xFFFFFFFF, 0xFFFFFFFF ; light values
.word 0xBFBFBFFF, 0xBFBFBFFF ; dark values (body)
.word 0x9F9F9FFF, 0x9F9F9FFF ; dark values (head)

.include "./body/data.asm"
.include "./head/data.asm"
.include "./claw/data.asm"

.align 4
icicle_missile_geo_layout:
.word 0x20000104
.word 0x04000000
	.word 0x18000000, make_half_transparent
	.word 0x10000000, 0x00320000, 0x002D2000, 0x00000000
	.word 0x04000000
		.word 0x1D000000, 0x00008000
		.word 0x04000000
			.word 0x15050000, icicle_fast3d
		.word 0x05000000
	.word 0x05000000
	.word 0x10000000, 0x00000000, 0x004B2000, 0x00000000
	.word 0x04000000
		.word 0x15050000, icicle_fast3d
	.word 0x05000000
	.word 0x10000000, 0xFFCE0000, 0x002D2000, 0x00000000
	.word 0x04000000
		.word 0x1D000000, 0x00008000
		.word 0x04000000
			.word 0x15050000, icicle_fast3d
		.word 0x05000000
	.word 0x05000000
.word 0x05000000
.word 0x01000000
