snowgre_head_geo_layout:
.word 0x20000248
.word 0x04000000
	.word 0x15010000, @fast3d
.word 0x05000000
.word 0x01000000

@fast3d:
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00000000
.word 0xFC121824, 0xFF33FFFF
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xE6000000, 0x00000000
.word 0x03860010, ogre_lighting
.word 0x03880010, (ogre_lighting+0x10)
.word 0xFD100000, snowball_texture
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x073FF100
.word 0xE7000000, 0x00000000
.word 0xF5101000, 0x00014050
.word 0xF2000000, 0x0007C07C
.word 0x04E000F0, (@vertices+0x0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0xF0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1E0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2D0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3C0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4B0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x5A0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x690)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x780)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x870)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x960)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0xA50)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0xB40)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0xC30)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0xD20)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0xE10)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0xF00)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0xFF0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x10E0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x11D0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x12C0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x13B0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x14A0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1590)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1680)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1770)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1860)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1950)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1A40)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1B30)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1C20)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1D10)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1E00)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1EF0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x1FE0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x20D0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x21C0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x22B0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x23A0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2490)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2580)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2670)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2760)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2850)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2940)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2A30)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2B20)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2C10)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2D00)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2DF0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2EE0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x2FD0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x30C0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x31B0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x32A0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3390)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3480)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3570)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3660)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3750)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3840)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3930)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3A20)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3B10)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3C00)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3CF0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3DE0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3ED0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x3FC0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x40B0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x41A0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4290)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4380)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xFD100000, @texture
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x070FF200
.word 0xE7000000, 0x00000000
.word 0xF5100800, 0x00010040
.word 0xF2000000, 0x0003C03C
.word 0x04E000F0, (@vertices+0x4380)
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4470)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4560)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4650)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4740)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4830)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4920)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4A10)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4B00)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4BF0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4CE0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4DD0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4EC0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (@vertices+0x4FB0)
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0xE7000000, 0x00000000
.word 0xFC127FFF, 0xFFFFF838
.word 0xBB000000, 0xFFFFFFFF
.word 0xB8000000, 0x00000000

@vertices:
.incbin "vertices.bin"
.align 4

@texture:
.incbin "eye-texture.bin"
.align 4
