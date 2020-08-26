global_vars:
.halfword 0x8FF ; gv_max_health
.byte 0x0 ; gv_items
.byte 0x0 ; gv_talismans
.byte 0x0 ; gv_bombs
.byte WARP_CHASM | WARP_TOWN ; gv_warps
.halfword 0 ; gv_shrooms
.word 0 ; gv_env_flags
/* additional save file data */
.halfword 0x01FF ; sv_health
.halfword 0x0009 ; sv_level
.word 0xDEADBEEF ; sv_signature
.fill 36, 0 ; padding

default_save_data:
.halfword 0x8FF ; gv_max_health
.byte 0x0 ; gv_items
.byte 0x0 ; gv_talismans
.byte 0x0 ; gv_bombs
.byte WARP_CHASM | WARP_TOWN ; gv_warps
.halfword 0 ; gv_shrooms
.word 0 ; gv_env_flags
/* additional save file data */
.halfword 0x01FF ; sv_health
.halfword 0x0009 ; sv_level
.word 0xDEADBEEF ; sv_signature
