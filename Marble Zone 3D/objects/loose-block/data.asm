.align 4

loose_brick_geo_layout:
.word 0x20000FA0
.word 0x04000000
	.word 0x15010000, @loose_brick_fast3d
.word 0x05000000
.word 0x01000000
 
@vertices:
.word 0x00640000, 0x00640000, 0x00000000, 0xffffffff
.word 0x006400C8, 0x00640000, 0x00000400, 0xffffffff
.word 0x006400C8, 0xFF9C0000, 0x04000400, 0xffffffff
.word 0x00640000, 0xFF9C0000, 0x04000000, 0xffffffff
.word 0xFF9C0000, 0x00640000, 0x04000000, 0xffffffff
.word 0xFF9C00C8, 0x00640000, 0x04000400, 0xffffffff
.word 0xFF9C00C8, 0xFF9C0000, 0x00000400, 0xffffffff
.word 0xFF9C0000, 0xFF9C0000, 0x00000000, 0xffffffff
.word 0x006400C8, 0x00640000, 0x04000000, 0xffffffff
.word 0x00640000, 0xFF9C0000, 0x00000400, 0xffffffff
.word 0xFF9C00C8, 0x00640000, 0x00000000, 0xffffffff
.word 0xFF9C0000, 0xFF9C0000, 0x04000400, 0xffffffff

@light_values:
.word 0xFFFFFFFF, 0xFFFFFFFF
@dark_values:
.word 0x7F7F7FFF, 0x7F7F7FFF

@texture:
.incbin "./texture.bin"

@loose_brick_fast3d:
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00000000
.word 0xFC121824, 0xFF33FFFF
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xE6000000, 0x00000000
.word 0x03860010, @light_values
.word 0x03880010, @dark_values
.word 0xFD100000, @texture
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x070FF200
.word 0xE7000000, 0x00000000
.word 0xF5100800, 0x00010040
.word 0xF2000000, 0x0003C03C
.word 0x04B000C0, @vertices
.word 0xBF000000, 0x000A3228
.word 0xBF000000, 0x00000A28
.word 0xBF000000, 0x00140A00
.word 0xBF000000, 0x001E1400
.word 0xBF000000, 0x003C141E
.word 0xBF000000, 0x00463C1E
.word 0xBF000000, 0x00323C46
.word 0xBF000000, 0x00283246
.word 0xBF000000, 0x00143C64
.word 0xBF000000, 0x00501464
.word 0xBF000000, 0x006E5A00
.word 0xBF000000, 0x00286E00
.word 0xE7000000, 0x00000000
.word 0xFC127FFF, 0xFFFFF838
.word 0xBB000000, 0xFFFFFFFF
.word 0xB8000000, 0x00000000
