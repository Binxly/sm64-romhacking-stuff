/* Use a custom object bank to make objects available to both part 1 and 2 of
the mountain climb. Data is stored in the ROM at the end of the level data for
mountain1, and is loaded as bank 0xD */

@CUSTOM_OBJECTS_DATA_SIZE equ 0x7B24
@SEGMENT_END_ROM equ 0x01A40000
@SEGMENT_START_ROM equ (@SEGMENT_END_ROM-@CUSTOM_OBJECTS_DATA_SIZE)

/* Custom Object Bank */
.headersize (0x0D000000-@SEGMENT_START_ROM)
.orga @SEGMENT_START_ROM
.area @CUSTOM_OBJECTS_DATA_SIZE

.align 4
.include "./cloud/data.asm"
.include "./ice-block/data.asm"
.include "./icicle/data.asm"
.include "./snowball/data.asm"
.include "./snow-patch/data.asm"

.endarea

/* Mountain 1 Level Script Edits */
@MODEL_ID_IMPORT_START_1 equ 0x18E0140
@MODEL_ID_IMPORT_END_1 equ 0x018E0268

; Alter bank 0x0D to point to the custom bank
.orga 0x18E0090
.word @SEGMENT_START_ROM
.word @SEGMENT_END_ROM

; Alter the size of bank 0xE
.orga 0x18E004C
.word @SEGMENT_START_ROM

; Remove the models that used to be imported by the old 0xD bank
.orga 0x02AC67C
.word 0x10080000, 0
.word 0x10080000, 0
.word 0x10080000, 0
.word 0x10080000, 0
.word 0x10080000, 0
.word 0x10080000, 0

; Import models
.orga @MODEL_ID_IMPORT_START_1
.area (@MODEL_ID_IMPORT_END_1-@MODEL_ID_IMPORT_START_1)
.word 0x22080046, cloud_geo_layout	; 70
.word 0x22080047, ice_block_geo_layout ; 71
.word 0x22080048, icicle_geo_layout ; 72
.word 0x22080049, snowball_geo_layout ; 73
.endarea

/* Mountain 2 Level Script Edits */
@MODEL_ID_IMPORT_START_2 equ 0x2D80140
@MODEL_ID_IMPORT_END_2 equ 0x2D80268

; Alter bank 0x0D to point to the custom bank
.orga 0x2D80090
.word @SEGMENT_START_ROM
.word @SEGMENT_END_ROM

; Alter the size of bank 0xE (may not be necessary)
.orga 0x2D8004C
.word (0x02EE0000-@CUSTOM_OBJECTS_DATA_SIZE)

; Import Snowgre
@SNOWGRE_SEGMENT_END equ (0x02EE0000-@CUSTOM_OBJECTS_DATA_SIZE)
@SNOWGRE_SEGMENT_SIZE equ 0x112A4
@SNOWGRE_SEGMENT_START equ (@SNOWGRE_SEGMENT_END-@SNOWGRE_SEGMENT_SIZE)

.headersize (0x0E000000-0x02D90000)
.orga @SNOWGRE_SEGMENT_START
.area @SNOWGRE_SEGMENT_SIZE
.align 4
.include "./snowgre/data.asm"
.include "./ghost/data.asm"
.include "./whomp/data.asm"
.endarea

; Import models
.orga @MODEL_ID_IMPORT_START_2
.area (@MODEL_ID_IMPORT_END_2-@MODEL_ID_IMPORT_START_2)
.word 0x22080046, cloud_geo_layout	; 70
.word 0x22080047, ice_block_geo_layout ; 71
.word 0x22080048, icicle_geo_layout ; 72
.word 0x22080049, snowball_geo_layout ; 73
.word 0x2208004A, snow_patch_geo_layout ; 74
.word 0x2208004B, ice_block_big_geo_layout ; 75
.word 0x2208004C, snowgre_body_geo_layout ; 76
.word 0x2208004D, snowgre_head_geo_layout ; 77
.word 0x2208004E, snowgre_claw_geo_layout ; 78
.word 0x2208004F, icicle_missile_geo_layout ; 79
.word 0x22080050, ice_cube_geo_layout ; 80
.word 0x22080051, angry_whomp_geo_layout ; 81
.word 0x22080052, ghost_geo_layout ; 82
.endarea

/* Debugging */

; Mountain 1 spawn point
.orga 0x18E118E
.halfword -5000
.halfword -6070
.halfword -6000

; Mountain 2 spawn point
.orga 0x2D8118E
.halfword 6075
.halfword -6000
.halfword 0
