@ROM_START equ 0x7CC6C0
@RAM_START equ 0x80367500

@RAM_OFFSET equ (@RAM_START - @ROM_START)

; (17,536 words)
@MAX_SIZE equ 0x11200

.orga 0x396C
.area 0x54
JAL 0x80322F40 ; commit all writes from the CPU cache to physical RAM
NOP
LI A0, @RAM_START
LI A1, @ROM_START
LI.U A2, @ROM_END
JAL 0x80278504 ; DMA read
LI.L A2, @ROM_END
LI A0, @RAM_START
LI.U A1, @MAX_SIZE
JAL 0x80324610 ; Invalidate instruction cache
LI.L A1, @MAX_SIZE
LI A0, @RAM_START
LI.U A1, @MAX_SIZE
JAL 0x803243B0 ; Invalidate data cache
LI.L A1, @MAX_SIZE
J @restore_overwritten_memory_setup_code
NOP
@end_of_overwritten_memory_setup_code:
.endarea
.skip 4

.orga @ROM_START
.headersize @RAM_OFFSET
.area @MAX_SIZE

@restore_overwritten_memory_setup_code:
OR A0, R0, R0
JAL 0x80277EE0
LUI A1, 0x8000
LUI A0, 0x8034
LUI A1, 0x8034
ADDIU A1, A1, 0xB044
ADDIU A0, A0, 0xB028
JAL 0x803225A0
ADDIU A2, R0, 0x1
LUI A0, 0x8034
LUI A1, 0x8034
ADDIU A1, A1, 0xB040
ADDIU A0, A0, 0xB010
JAL 0x803225A0
ADDIU A2, R0, 0x1
LUI T6, 0x8000
LUI AT, 0x1FFF
ORI AT, AT, 0xFFFF
ADDIU T6, T6, 0x0400
AND T7, T6, AT
J @end_of_overwritten_memory_setup_code
LUI AT, 0x8034

@on_every_mario_active_frame:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

; import your code that runs on every frame that Mario is active here


LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@gui_extensions:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

; import your code that renders additional HUD elements here


LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

; import your code here that gets loaded into free space
; don't use .org/.orga/.headersize in these files


.endarea
@RAM_END:
.skip 4
.definelabel @ROM_END, (@RAM_END - @RAM_OFFSET)

.orga 0x8625C
J @on_every_mario_active_frame

.orga 0x9EE48
J @gui_extensions

; import your code here that overwrites the ROM in specific places
; you can freely use .org/.orga/.headersize here (and all files should start with .orga)

