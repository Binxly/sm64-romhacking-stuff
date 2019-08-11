ogre_door_geo_layout:
.word 0x20000380
.word 0x04000000
	.word 0x15010000, @fast3d_door_ogre
.word 0x05000000
.word 0x01000000

mad_door_geo_layout:
.word 0x20000380
.word 0x04000000
	.word 0x15010000, @fast3d_door_mad
.word 0x05000000
.word 0x01000000

timed_door_geo_layout:
.word 0x20000380
.word 0x04000000
	.word 0x15010000, @fast3d_door_time
.word 0x05000000
.word 0x01000000

@fast3d_door_ogre:
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00000000
.word 0xFC121824, 0xFF33FFFF
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xE6000000, 0x00000000
.word 0xFD100000, @texture_ogre
.word 0x06010000, @fast3d_main

@fast3d_door_mad:
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00000000
.word 0xFC121824, 0xFF33FFFF
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xE6000000, 0x00000000
.word 0xFD100000, @texture_mad
.word 0x06010000, @fast3d_main

@fast3d_door_time:
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00000000
.word 0xFC121824, 0xFF33FFFF
.word 0xBB000001, 0xFFFFFFFF
.word 0xE8000000, 0x00000000
.word 0xE6000000, 0x00000000
.word 0xFD100000, @texture_hourglass
.word 0x06010000, @fast3d_main

@fast3d_main:
.word 0x03860010, @light_values
.word 0x03880010, @dark_values
.word 0xF5100000, 0x07000000
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x073FF100
.word 0xE7000000, 0x00000000
.word 0xF5101000, 0x00014050
.word 0xF2000000, 0x0007C07C
.word 0x04E000F0, @vertices
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
.word 0xE7000000, 0x00000000
.word 0xFC127FFF, 0xFFFFF838
.word 0xBB000000, 0xFFFFFFFF
.word 0xB8000000, 0x00000000

@light_values:
.word 0xFFFFFFFF, 0xFFFFFFFF
@dark_values:
.word 0x404040FF, 0x404040FF

@vertices:
.incbin "vertices.bin"
.align 4

@texture_ogre:
.incbin "texture-ogre.bin"
.align 4

@texture_mad:
.incbin "texture-mad.bin"
.align 4

@texture_hourglass:
.incbin "texture-hourglass.bin"
.align 4

door_collision:
.incbin "collision.bin"
.align 4
