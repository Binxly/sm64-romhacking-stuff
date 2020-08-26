instant_warp_shim:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
JAL drop_object
SW A0, 0x10 (SP)
LW A0, 0x10 (SP)
LW RA, 0x14 (SP)
J 0x8027B0C0
ADDIU SP, SP, 0x18

drop_object:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LI.U A0, g_mario
JAL 0x8024C894
LI.L A0, g_mario

LI A0, g_mario
LW T0, m_action (A0)
LI T1, 0x20810446
BNE T0, T1, @@endif_riding_shell_on_ground
	LI A1, 0x0188088A
	JAL set_mario_action
	MOVE A2, R0
	B @@break
@@endif_riding_shell_on_ground:

LI S0, @held_action_table
@@loop:
	LI A0, g_mario
	LW T0, m_action (A0)
	LW T1, 0x0 (S0)
	BNE T0, T1, @@continue
		LW T1, 0x4 (S0)
		SW T1, m_action (A0)
		B @@break
		SW T0, m_prev_action (A0)
	@@continue:
	ADDIU S0, S0, 8
	LI T0, @held_action_table_end
	BNE S0, T0, @@loop
	NOP
@@break:

LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@held_action_table:
.word 0x08000206, 0x0C400205
.word 0x08000207, 0x0C400201
.word 0x08000208, 0x0C400201
.word 0x08000234, 0x0C000230
.word 0x08000235, 0x0C000232
.word 0x0800043F, 0x0C00023E
.word 0x00000442, 0x04000440
.word 0x00000447, 0x04000440
.word 0x0000044B, 0x0400044A
.word 0x00000051, 0x00000050
.word 0x00840454, 0x00840452
.word 0x008C0455, 0x008C0453
.word 0x00000474, 0x04000470
.word 0x00000475, 0x04000471
.word 0x00000477, 0x00000476
.word 0x030008A0, 0x03000880
.word 0x010008A1, 0x0100088C
.word 0x010008A2, 0x0300088E
.word 0x010008A3, 0x01000889
.word 0x380022C1, 0x380022C0
.word 0x300022C3, 0x300022C2
.word 0x300024D3, 0x300024D0
.word 0x300024D4, 0x300024D1
.word 0x300024D5, 0x300024D2
.word 0x080042F1, 0x080042F0
.word 0x000044F3, 0x000044F2
.word 0x000042F5, 0x000042F4
.word 0x000042F7, 0x000042F6
.word 0x000044F9, 0x000044F8
.word 0x000044FB, 0x000044FA
; riding shell (air)
.word 0x0281089A, 0x03000880
.word 0x0081089B, 0x0100088C
@held_action_table_end:
NOP
