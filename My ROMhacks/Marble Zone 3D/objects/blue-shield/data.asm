.align 4

shield_geo_layout:
.word 0x200000E0
.word 0x04000000
	.word 0x0E000006, 0x8029DB48
	.word 0x04000000
		.word 0x15040000, @shield_frame_1
		.word 0x15010000, @empty_model
		.word 0x15040000, @shield_frame_3
		.word 0x15010000, @empty_model
		.word 0x15040000, @shield_frame_5
		.word 0x15010000, @empty_model
	.word 0x05000000
.word 0x05000000
.word 0x01000000

@vertices:
.word 0x0064FFDF, 0x00000000, 0x08000000, 0xffffffff ; bottom right
.word 0xff9c00A7, 0x00000000, 0x00000000, 0xffffffff ; top left
.word 0xff9cFFDF, 0x00000000, 0x00000000, 0xffffffff ; bottom left
.word 0x006400A7, 0x00000000, 0x08000000, 0xffffffff ; top right
.word 0xff9c0043, 0x00000000, 0x00000400, 0xffffffff ; middle left
.word 0x00640043, 0x00000000, 0x08000400, 0xffffffff ; middle right

@texture_1:
.incbin "./texture-1.bin"
@texture_2:
.incbin "./texture-2.bin"
@texture_3:
.incbin "./texture-3.bin"

@shield_frame_1:
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00000000
.word 0xFC121824, 0xFF33FFFF
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xE6000000, 0x00000000
.word 0xFD100000, @texture_1
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x077FF080
.word 0xE7000000, 0x00000000
.word 0xF5102000, 0x000D4360
.word 0xF2000000, 0x000FC07C
.word 0x04500060, @vertices
.word 0xBF000000, 0x00320A28
.word 0xBF000000, 0x00321E0A
.word 0xBF000000, 0x00002814
.word 0xBF000000, 0x00003228
.word 0xE7000000, 0x00000000
.word 0xFC127FFF, 0xFFFFF838
.word 0xBB000000, 0xFFFFFFFF
.word 0xB8000000, 0x00000000

@shield_frame_3:
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00000000
.word 0xFC121824, 0xFF33FFFF
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xE6000000, 0x00000000
.word 0xFD100000, @texture_2
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x077FF080
.word 0xE7000000, 0x00000000
.word 0xF5102000, 0x000D4360
.word 0xF2000000, 0x000FC07C
.word 0x04500060, @vertices
.word 0xBF000000, 0x00320A28
.word 0xBF000000, 0x00321E0A
.word 0xBF000000, 0x00002814
.word 0xBF000000, 0x00003228
.word 0xE7000000, 0x00000000
.word 0xFC127FFF, 0xFFFFF838
.word 0xBB000000, 0xFFFFFFFF
.word 0xB8000000, 0x00000000

@shield_frame_5:
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00000000
.word 0xFC121824, 0xFF33FFFF
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xE6000000, 0x00000000
.word 0xFD100000, @texture_3
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x077FF080
.word 0xE7000000, 0x00000000
.word 0xF5102000, 0x000D4360
.word 0xF2000000, 0x000FC07C
.word 0x04500060, @vertices
.word 0xBF000000, 0x00320A28
.word 0xBF000000, 0x00321E0A
.word 0xBF000000, 0x00002814
.word 0xBF000000, 0x00003228
.word 0xE7000000, 0x00000000
.word 0xFC127FFF, 0xFFFFF838
.word 0xBB000000, 0xFFFFFFFF
.word 0xB8000000, 0x00000000

@empty_model:
.word 0xE7000000, 0x00000000
.word 0xB8000000, 0x00000000