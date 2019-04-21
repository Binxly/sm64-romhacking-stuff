.align 4

caterkiller_geo_layout:
.word 0x2000012C
.word 0x04000000
	.word 0x0E000005, 0x8029DB48
	.word 0x04000000
		.word 0x15010000, @fast3d_face_1
		.word 0x15010000, @fast3d_face_2
		.word 0x15010000, @fast3d_body
	.word 0x05000000
.word 0x05000000
.word 0x01000000

@fast3d_face_1:
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00000000
.word 0xFC121824, 0xFF33FFFF
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xE6000000, 0x00000000
.word 0x03860010, @light_values
.word 0x03880010, @dark_values
.word 0xFD100000, @texture_face_1
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x070FF200
.word 0xE7000000, 0x00000000
.word 0xF5100800, 0x00010040
.word 0xF2000000, 0x0003C03C
.word 0x04E000F0, @vertices_face_1
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0xF0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1E0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2D0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x3C0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x4B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x5A0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x690) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x780) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x870) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x960) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0xA50) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0xB40) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0xC30) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0xD20) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0xE10) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0xF00) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0xFF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x10E0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x11D0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x12C0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x13B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x14A0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1590) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1680) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1770) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1860) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1950) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1A40) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1B30) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1C20) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1D10) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1E00) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1EF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x1FE0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x20D0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x21C0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x22B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x23A0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2490) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2580) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2670) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2760) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2850) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2940) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xFD100000, @texture_colours_1
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x070FF200
.word 0xE7000000, 0x00000000
.word 0xF5100800, 0x00010040
.word 0xF2000000, 0x0003C03C
.word 0x04E000F0, (@vertices_face_1+0x2940) 
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2A30) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2B20) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2C10) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2D00) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2DF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2EE0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x2FD0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x30C0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x31B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x32A0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x3390) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_1+0x3480) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0xE7000000, 0x00000000
.word 0xFC127FFF, 0xFFFFF838
.word 0xBB000000, 0xFFFFFFFF
.word 0xB8000000, 0x00000000

@fast3d_face_2:
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00000000
.word 0xFC121824, 0xFF33FFFF
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xE6000000, 0x00000000
.word 0x03860010, @light_values
.word 0x03880010, @dark_values
.word 0xFD100000, @texture_colours_1
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x070FF200
.word 0xE7000000, 0x00000000
.word 0xF5100800, 0x00010040
.word 0xF2000000, 0x0003C03C
.word 0x04E000F0, @vertices_face_2
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0xF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1E0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2D0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x3C0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x4B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x5A0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x690) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x780) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x870) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x960) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0xA50) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0xB40) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0xC30) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0xFD100000, @texture_face_2
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x070FF200
.word 0xE7000000, 0x00000000
.word 0xF5100800, 0x00010040
.word 0xF2000000, 0x0003C03C
.word 0x04E000F0, (@vertices_face_2+0xD20) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0xE10) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0xF00) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0xFF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x10E0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x11D0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x12C0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x13B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x14A0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1590) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1680) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1770) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1860) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1950) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1A40) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1B30) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1C20) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1D10) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1E00) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1EF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x1FE0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x20D0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x21C0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x22B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x23A0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2490) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2580) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2670) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2760) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2850) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2940) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2A30) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2B20) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2C10) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2D00) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2DF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2EE0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x2FD0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x30C0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x31B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x32A0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x3390) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x3480) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x3570) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_face_2+0x3660) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0xE7000000, 0x00000000
.word 0xFC127FFF, 0xFFFFF838
.word 0xBB000000, 0xFFFFFFFF
.word 0xB8000000, 0x00000000

@fast3d_body:
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00000000
.word 0xFC121824, 0xFF33FFFF
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xE6000000, 0x00000000
.word 0x03860010, @light_values
.word 0x03880010, @dark_values
.word 0xFD100000, @texture_colours_2
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x070FF200
.word 0xE7000000, 0x00000000
.word 0xF5100800, 0x00010040
.word 0xF2000000, 0x0003C03C
.word 0x04E000F0, @vertices_body
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0xF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1E0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x2D0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x3C0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x4B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x5A0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x690) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x780) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x870) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x960) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0xA50) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0xFD100000, @texture_body
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x071FF200
.word 0xE7000000, 0x00000000
.word 0xF5100800, 0x00014040
.word 0xF2000000, 0x0003C07C
.word 0x04E000F0, (@vertices_body+0xB40) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0xC30) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0xD20) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0xE10) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0xF00) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0xFF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x10E0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x11D0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x12C0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x13B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x14A0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1590) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1680) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1770) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1860) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1950) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1A40) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1B30) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1C20) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1D10) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1E00) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1EF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x1FE0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x20D0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x21C0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x22B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x23A0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x2490) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x2580) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x2670) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x2760) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x2850) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x2940) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices_body+0x2A30) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0xE7000000, 0x00000000
.word 0xFC127FFF, 0xFFFFF838
.word 0xBB000000, 0xFFFFFFFF
.word 0xB8000000, 0x00000000

@light_values:
.word 0xFFFFFFFF, 0xFFFFFFFF
@dark_values:
.word 0x7F7F7FFF, 0xEFEFEFFF

@vertices_face_1:
.incbin "./vertices-face-1.bin"
@vertices_face_2:
.incbin "./vertices-face-2.bin"
@vertices_body:
.incbin "./vertices-body.bin"

@texture_face_1:
.incbin "./texture-face-1.bin"
@texture_face_2:
.incbin "./texture-face-2.bin"
@texture_body:
.incbin "./texture-body.bin"
@texture_colours_1:
.incbin "./texture-colours-1.bin"
@texture_colours_2:
.incbin "./texture-colours-2.bin"
