@SEGMENT_START_ROM equ 0x018F0000
@SEGMENT_END_ROM equ 0x01A40000

@MODEL_ID_IMPORT_START equ 0x018E0180 
@MODEL_ID_IMPORT_SIZE equ 0xE8

@OBJECT_IMPORT_SIZE equ 0x32000 ; space allocated for custom objects

.headersize (0x0E000000-@SEGMENT_START_ROM)
.orga (@SEGMENT_END_ROM-@OBJECT_IMPORT_SIZE)
.area @OBJECT_IMPORT_SIZE
.include "./item-box/data.asm"
.include "./item-box-icon/data.asm"
.include "./press/data.asm"
.include "./explosion/data.asm"
.include "./secret/data.asm"
.include "./blue-shield/data.asm"
.include "./batbrain/data.asm"
.include "./spikes/data.asm"
.include "./chain/data.asm"
.include "./loose-block/data.asm"
.include "./weight/data.asm"
.include "./spike-platform/data.asm"
.include "./caterkiller/data.asm"
.include "./fireball-shooter/data.asm"
.include "./floating-block/data.asm"
.include "./lava-fall/data.asm"
.include "./bonus-ring/data.asm"
.include "./readme/data.asm"
.include "./sign/data.asm"
.include "./lava-chase/data.asm"

.include "./shared-textures/import.asm"

.align 4
lava_texture_1:
.incbin "../lava/texture-1.bin"
lava_texture_2:
.incbin "../lava/texture-2.bin"
lava_texture_3:
.incbin "../lava/texture-3.bin"
.endarea

; Don't import BBH object bank
.orga 0x18E00C8
.word 0x10040000, 0x10040000

.orga @MODEL_ID_IMPORT_START
.area @MODEL_ID_IMPORT_SIZE
.word 0x22080046, item_box_geo_layout		; 70
.word 0x22080047, press_geo_layout			; 71
.word 0x22080048, explosion_geo_layout		; 72
.word 0x22080049, shield_geo_layout			; 73
.word 0x2208004A, secret_geo_layout			; 74
.word 0x2208004B, batbrain_geo_layout		; 75
.word 0x2208004C, spikes_geo_layout			; 76
.word 0x2208004D, chain_geo_layout			; 77
.word 0x2208004E, loose_brick_geo_layout	; 78
.word 0x2208004F, item_box_icon_geo_layout	; 79
.word 0x22080050, weight_geo_layout			; 80
.word 0x22080051, spike_platform_geo_layout	; 81
.word 0x22080052, caterkiller_geo_layout	; 82
.word 0x22080053, fire_shooter_geo_layout	; 83
.word 0x22080054, lava_fall_geo_layout		; 84
.word 0x22080055, floating_block_geo_layout	; 85
.word 0x22080056, bonus_ring_geo_layout		; 86
.word 0x22080057, sign_geo_layout			; 87
.word 0x22080058, readme_geo_layout			; 88
.word 0x22080059, lava_chase_geo_layout_1	; 89
.word 0x2208005A, lava_chase_geo_layout_2	; 90
.endarea

