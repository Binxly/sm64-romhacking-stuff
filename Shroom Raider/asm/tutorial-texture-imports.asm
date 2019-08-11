.headersize (0x0E000000-0x03050000)

.orga (0x31A0000-0x2000)
.area 0x2000

light_texture_1:
.import "./resources/lights_1.bin"

light_texture_2:
.import "./resources/lights_2.bin"

light_texture_3:
.import "./resources/lights_3.bin"

light_texture_4:
.import "./resources/lights_4.bin"

.endarea

.definelabel light_texture,0x0E001A10
