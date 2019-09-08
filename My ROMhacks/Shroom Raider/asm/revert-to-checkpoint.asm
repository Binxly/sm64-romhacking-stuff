; Replace the Exit Course functionality in the pause menu with a Revert to Last Checkpoint option

.orga 0x6644
.area 0x68

JAL 0x80248CE8
SETU A0, 0x1

LI T0, 0x8033C848
LHU T1, 0x0 (T0)
ANDI T1, T1, 0x7FFF
SH T1, 0x0 (T0)

JAL 0x80249764
SETU A0, 0x0

JAL kill_mario
SETU A0, 30

J 0x8024B6AC
NOP

.endarea


.orga 0x96FB4
JAL exit_course_text_shim
