@camera_x equ 0x10
@camera_y equ 0x14
@camera_z equ 0x18

.headersize 0x80245000
.orga 0x4B53C
.area 0x248

; Replaces credits cutscene data. A0 is a pointer to the level camera
LUI AT, 0xC5B1
SW AT, @camera_x (A0)
LUI AT, 0x458D
SW AT, @camera_y (A0)
LUI AT, 0x449C
SW AT, @camera_z (A0)

JR RA
NOP

.endarea
