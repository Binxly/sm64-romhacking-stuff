/* Use a custom object bank to make objects available to both part 1 and 2 of
the mountain climb. Data is stored in the ROM at the end of the level data for
mountain1, and is loaded as bank 0xD */

@CUSTOM_OBJECTS_DATA_SIZE equ 0x12F08
@SEGMENT_START_ROM equ 0x01D10000
@SEGMENT_END_ROM equ 0x01E60000
@IMPORT_START_ROM equ (@SEGMENT_END_ROM-@CUSTOM_OBJECTS_DATA_SIZE)

/* Custom Object Bank */
.headersize (0x0E000000-@SEGMENT_START_ROM)
.orga @IMPORT_START_ROM
.area @CUSTOM_OBJECTS_DATA_SIZE

.align 4
.include "./blood/data.asm"
.include "./door/data.asm"
.include "./spike/data.asm"
.include "./green-fire/data.asm"
.include "./brazier/data.asm"
.include "./sawblade/data.asm"
.include "./skull/data.asm"
.include "./chalice/data.asm"
.include "./ice-trap/data.asm"

.endarea

/* Level Script Edits */
@MODEL_ID_IMPORT_START equ 0x1D00140
@MODEL_ID_IMPORT_END equ 0x1D00268

; Import models
.orga @MODEL_ID_IMPORT_START
.area (@MODEL_ID_IMPORT_END-@MODEL_ID_IMPORT_START)
.word 0x22080046, blood_particle_geo_layout	; 70
.word 0x22080047, ogre_door_geo_layout		; 71
.word 0x22080048, mad_door_geo_layout		; 72
.word 0x22080049, timed_door_geo_layout		; 73
.word 0x2208004A, spike_geo_layout			; 74
.word 0x2208004B, green_flame_geo_layout	; 75
.word 0x2208004C, skull_geo_layout			; 76
.word 0x2208004D, chalice_geo_layout		; 77
.word 0x2208004E, brazier_geo_layout		; 78
.word 0x2208004F, sawblade_geo_layout		; 79
.word 0x22080050, ice_cube_geo_layout		; 80
.word 0x22080051, ice_trap_geo_layout		; 81
.endarea

/* Debug -- set initial Mario spawn */
.orga 0x1D0118E
.halfword -6800
.halfword 0
.halfword -5000
