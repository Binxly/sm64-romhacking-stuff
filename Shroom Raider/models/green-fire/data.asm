green_flame_geo_layout:
.word 0x0B000000
.word 0x04000000
	.word 0x0E000008, 0x8029DB48
	.word 0x04000000
		.word 0x15050000, @frame_1
		.word 0x15050000, @frame_2
		.word 0x15050000, @frame_3
		.word 0x15050000, @frame_4
		.word 0x15050000, @frame_5
		.word 0x15050000, @frame_6
		.word 0x15050000, @frame_7
		.word 0x15050000, @frame_8
	.word 0x05000000
.word 0x05000000
.word 0x01000000

@frame_1:
.word 0xE7000000, 0x00000000
.word 0xFD700000, 0x03017320
.word 0x06010000, @fast3d_main

@frame_2:
.word 0xE7000000, 0x00000000
.word 0xFD700000, 0x03017B20
.word 0x06010000, @fast3d_main

@frame_3:
.word 0xE7000000, 0x00000000
.word 0xFD700000, 0x03018320
.word 0x06010000, @fast3d_main

@frame_4:
.word 0xE7000000, 0x00000000
.word 0xFD700000, 0x03018B20
.word 0x06010000, @fast3d_main

@frame_5:
.word 0xE7000000, 0x00000000
.word 0xFD700000, 0x03019320
.word 0x06010000, @fast3d_main

@frame_6:
.word 0xE7000000, 0x00000000
.word 0xFD700000, 0x03019B20
.word 0x06010000, @fast3d_main

@frame_7:
.word 0xE7000000, 0x00000000
.word 0xFD700000, 0x0301A320
.word 0x06010000, @fast3d_main

@frame_8:
.word 0xE7000000, 0x00000000
.word 0xFD700000, 0x0301AB20
.word 0x06010000, @fast3d_main

@fast3d_main:
.word 0xB6000000, 0x00020200
.word 0xFB000000, 0x80FF80C8 ; colour
.word 0xFC129A25, 0xFF37FFFF
.word 0xF5700000, 0x07094250
.word 0xE6000000, 0x00000000
.word 0xF3000000, 0x073FF100
.word 0xF5701000, 0x00094250
.word 0xF2000000, 0x0007C07C
.word 0xBB000001, 0xFFFFFFFF
.word 0x04300040, 0x030172E0
.word 0xBF000000, 0x00000A14
.word 0xBF000000, 0x0000141E
.word 0xBB000000, 0xFFFFFFFF
.word 0xE7000000, 0x00000000
.word 0xB7000000, 0x00020200
.word 0xFB000000, 0xFFFFFFFF
.word 0xFCFFFFFF, 0xFFFE793C
.word 0xB8000000, 0x00000000