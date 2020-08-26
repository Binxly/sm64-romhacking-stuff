.definelabel shroom_geo, (org() - 0x80000000)
.word 0x16000001, 0x00B40032
.word 0x04000000
	.word 0x04000000
		.word 0x15010000, @fast3d_part1
	.word 0x05000000
	.word 0x04000000
		.word 0x0E000004, 0x8029DB48
		.word 0x04000000
			.word 0x15010000, @fast3d_red
			.word 0x15010000, @fast3d_green
			.word 0x15010000, @fast3d_yellow
			.word 0x15010000, @fast3d_pink
		.word 0x05000000
	.word 0x05000000
	.word 0x04000000
		.word 0x15010000, @fast3d_part2
	.word 0x05000000
.word 0x05000000
.word 0x01000000

.definelabel @fast3d_part1, (org() - 0x80000000)
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00000000
.word 0xFC127FFF, 0xFFFFF838
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xE6000000, 0x00000000
.word 0xBA000C02, 0x00002000
.word 0x03860010, @lighting
.word 0x03880010, @lighting
.word 0xB8000000, 0x00000000

.definelabel @fast3d_part2, (org() - 0x80000000)
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x073FF100
.word 0xE7000000, 0x00000000
.word 0xF5101000, 0x00054150
.word 0xF2000000, 0x0007C07C
.word 0x04E000F0, (shroom_vertices+0x0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x910) 
.word 0xBF000000, 0x0014000A
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04F00100, (shroom_vertices+0x780) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x00001E0A
.word 0xBF000000, 0x00281E00
.word 0xBF000000, 0x001E320A
.word 0xBF000000, 0x00283C1E
.word 0xBF000000, 0x001E4632
.word 0xBF000000, 0x003C461E
.word 0xBF000000, 0x00465032
.word 0xBF000000, 0x003C5A46
.word 0xBF000000, 0x00466450
.word 0xBF000000, 0x005A6446
.word 0xBF000000, 0x00646E50
.word 0xBF000000, 0x00325078
.word 0xBF000000, 0x00508278
.word 0xBF000000, 0x00506E82
.word 0xBF000000, 0x0078828C
.word 0xBF000000, 0x0082968C
.word 0x04E000F0, (shroom_vertices+0xF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x00001E0A
.word 0xBF000000, 0x00140A28
.word 0xBF000000, 0x000A3228
.word 0xBF000000, 0x001E3C0A
.word 0xBF000000, 0x000A4632
.word 0xBF000000, 0x003C500A
.word 0xBF000000, 0x000A5046
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04F00100, (shroom_vertices+0x680) 
.word 0xBF000000, 0x00141E00
.word 0xBF000000, 0x0028321E
.word 0xBF000000, 0x0014281E
.word 0xBF000000, 0x003C4628
.word 0xBF000000, 0x00284632
.word 0xBF000000, 0x00503C28
.word 0xBF000000, 0x00502814
.word 0xBF000000, 0x003C5A46
.word 0xBF000000, 0x00646E78
.word 0xBF000000, 0x00828C96
.word 0x04E000F0, (shroom_vertices+0x4B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x1E0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04F00100, (shroom_vertices+0x5A0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x0000141E
.word 0xBF000000, 0x0028001E
.word 0xBF000000, 0x001E1432
.word 0xBF000000, 0x001E323C
.word 0xBF000000, 0x00281E46
.word 0xBF000000, 0x00461E3C
.word 0xBF000000, 0x0032503C
.word 0xBF000000, 0x003C505A
.word 0xBF000000, 0x00463C64
.word 0xBF000000, 0x00643C5A
.word 0xBF000000, 0x00645A6E
.word 0xBF000000, 0x00646E78
.word 0xBF000000, 0x00786E82
.word 0xBF000000, 0x0078828C
.word 0xBF000000, 0x0082968C
.word 0x04E000F0, (shroom_vertices+0xA00) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04F00100, (shroom_vertices+0x830) 
.word 0xBF000000, 0x00003214
.word 0xBF000000, 0x00143228
.word 0xBF000000, 0x0028323C
.word 0xBF000000, 0x000A1E46
.word 0xBF000000, 0x00461E50
.word 0xBF000000, 0x0046505A
.word 0xBF000000, 0x005A5064
.word 0xBF000000, 0x006E465A
.word 0xBF000000, 0x0078466E
.word 0xBF000000, 0x00780A46
.word 0xBF000000, 0x00820A78
.word 0xBF000000, 0x008C7896
.word 0xBF000000, 0x0096786E
.word 0xBF000000, 0x008C8278
.word 0x04F00100, (shroom_vertices+0xAF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x001E323C
.word 0xBF000000, 0x00461E3C
.word 0xBF000000, 0x00463C50
.word 0xBF000000, 0x0046505A
.word 0xBF000000, 0x005A5064
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0064786E
.word 0xBF000000, 0x00828C96
.word 0x04E000F0, (shroom_vertices+0x2D0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0xBF0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x3C0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0xEC0) 
.word 0xBF000000, 0x000A1400
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x1260) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04F00100, (shroom_vertices+0xCE0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x005A7864
.word 0xBF000000, 0x0082785A
.word 0xBF000000, 0x00788C64
.word 0xBF000000, 0x0078968C
.word 0x04E000F0, (shroom_vertices+0x1170) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04F00100, (shroom_vertices+0x1450) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x00283C32
.word 0xBF000000, 0x00323C46
.word 0xBF000000, 0x003C5046
.word 0xBF000000, 0x00505A46
.word 0xBF000000, 0x00465A64
.word 0xBF000000, 0x00646E78
.word 0xBF000000, 0x005A6E64
.word 0xBF000000, 0x00828C96
.word 0x04B000C0, (shroom_vertices+0x1550) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0x04F00100, (shroom_vertices+0x1070) 
.word 0xBF000000, 0x0014000A
.word 0xBF000000, 0x001E2800
.word 0xBF000000, 0x001E0014
.word 0xBF000000, 0x00283200
.word 0xBF000000, 0x003C1E14
.word 0xBF000000, 0x0046505A
.word 0xBF000000, 0x00646E78
.word 0xBF000000, 0x00828C96
.word 0x04F00100, (shroom_vertices+0x1350) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x001E323C
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x003C3246
.word 0xBF000000, 0x0050465A
.word 0xBF000000, 0x0064505A
.word 0xBF000000, 0x006E645A
.word 0xBF000000, 0x0078646E
.word 0xBF000000, 0x00828C96
.word 0x04F00100, (shroom_vertices+0xDD0) 
.word 0xBF000000, 0x000A0014
.word 0xBF000000, 0x001E0A14
.word 0xBF000000, 0x00280A1E
.word 0xBF000000, 0x0028320A
.word 0xBF000000, 0x000A3C00
.word 0xBF000000, 0x00323C0A
.word 0xBF000000, 0x003C4600
.word 0xBF000000, 0x003C5046
.word 0xBF000000, 0x00325A3C
.word 0xBF000000, 0x00503C5A
.word 0xBF000000, 0x00645A32
.word 0xBF000000, 0x00646E5A
.word 0xBF000000, 0x006E785A
.word 0xBF000000, 0x0078505A
.word 0xBF000000, 0x0082786E
.word 0xBF000000, 0x008C6432
.word 0xBF000000, 0x008C3228
.word 0xBF000000, 0x00004696
.word 0x04F00100, (shroom_vertices+0xF90) 
.word 0xBF000000, 0x000A141E
.word 0xBF000000, 0x000A0014
.word 0xBF000000, 0x001E1428
.word 0xBF000000, 0x00003214
.word 0xBF000000, 0x00143C28
.word 0xBF000000, 0x0014323C
.word 0xBF000000, 0x00283C46
.word 0xBF000000, 0x0032503C
.word 0xBF000000, 0x003C5A46
.word 0xBF000000, 0x00505A3C
.word 0xBF000000, 0x005A6446
.word 0xBF000000, 0x0028466E
.word 0xBF000000, 0x0046786E
.word 0xBF000000, 0x00647846
.word 0xBF000000, 0x0078826E
.word 0xBF000000, 0x008C286E
.word 0xBF000000, 0x008C6E96
.word 0xBF000000, 0x006E8296
.word 0xBA000C02, 0x00002000
.word 0xFD100000, shroom_texture_eyes
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x0707F400
.word 0xE7000000, 0x00000000
.word 0xF5100400, 0x00090230
.word 0xF2000000, 0x0001C03C
.word 0x04F00100, (shroom_vertices+0x1700) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x00283C32
.word 0xBF000000, 0x0046505A
.word 0xBF000000, 0x00646E78
.word 0xBF000000, 0x00828C96
.word 0x04E000F0, (shroom_vertices+0x1610) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x1CB0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x19F0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04F00100, (shroom_vertices+0x1800) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x00140A1E
.word 0xBF000000, 0x0028323C
.word 0xBF000000, 0x0046505A
.word 0xBF000000, 0x00646E78
.word 0xBF000000, 0x00828C96
.word 0x04E000F0, (shroom_vertices+0x1AE0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x1E90) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x2070) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x2340) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x2160) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x1900) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x1F80) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x2520) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04D000E0, (shroom_vertices+0x1BD0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x00786482
.word 0x04E000F0, (shroom_vertices+0x2250) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x1DA0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x2600) 
.word 0xBF000000, 0x000A1400
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x2430) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x27E0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x29B0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04E000F0, (shroom_vertices+0x26F0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xBF000000, 0x0078828C
.word 0x04D000E0, (shroom_vertices+0x28D0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A5064
.word 0xBF000000, 0x006E7882
.word 0x04B000C0, (shroom_vertices+0x2AA0) 
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x001E2832
.word 0xBF000000, 0x003C4650
.word 0xBF000000, 0x005A646E
.word 0xFCFFFFFF, 0xFFFE793C
.word 0xBB000000, 0xFFFFFFFF
.word 0xB8000000, 0x00000000

.definelabel @fast3d_red, (org() - 0x80000000)
.word 0xFD100000, shroom_texture_red
.word 0xB8000000, 0x00000000

.definelabel @fast3d_green, (org() - 0x80000000)
.word 0xFD100000, shroom_texture_green
.word 0xB8000000, 0x00000000

.definelabel @fast3d_yellow, (org() - 0x80000000)
.word 0xFD100000, shroom_texture_yellow
.word 0xB8000000, 0x00000000

.definelabel @fast3d_pink, (org() - 0x80000000)
.word 0xFD100000, shroom_texture_pink
.word 0xB8000000, 0x00000000

.definelabel @lighting, (org() - 0x80000000)
.word 0xFFFFFFFF, 0xFFFFFFFF, 0xFF000000

