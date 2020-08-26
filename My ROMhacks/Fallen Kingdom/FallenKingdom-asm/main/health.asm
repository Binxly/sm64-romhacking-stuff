set_max_health:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW RA, 0x10 (SP)

SH A0, (global_vars + gv_max_health)

LUI T0, 0x8025
ADDIU AT, A0, 1
SH AT, 0x4226 (T0)
SH A0, 0x4236 (T0)
SH A0, 0x502A (T0)

JAL commit_all_writes
NOP

LI A0, 0x80254234
JAL invalidate_instruction_cache
SETU A1, 0x14

LI A0, 0x80255028
JAL invalidate_instruction_cache
SETU A1, 0x4

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
