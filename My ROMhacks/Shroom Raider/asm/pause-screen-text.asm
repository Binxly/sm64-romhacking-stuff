exit_course_text_shim:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW A0, 0x18 (SP)
SW A1, 0x1C (SP)

LBU T0, @is_text_encoded
BNE T0, R0, @endif_encode_text
	LI A0, @revert_to_last_checkpoint
	JAL encode_text
	MOVE A1, A0
	SETU T0, 0x1
	SB T0, @is_text_encoded
@endif_encode_text:

LW A0, 0x18 (SP)
LW A1, 0x1C (SP)
LI A2, @revert_to_last_checkpoint

LW RA, 0x14 (SP)
J print_encoded_text
ADDIU SP, SP, 0x18

@revert_to_last_checkpoint:
.asciiz "REVERT TO LAST CHECKPOINT"
@is_text_encoded:
.byte 0

.align 4
