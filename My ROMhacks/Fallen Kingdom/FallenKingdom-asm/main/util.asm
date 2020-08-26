perspective_transform_2:
	; a0 = pointer to vector
	; v0 = x screen position (or -1 if offscreen)
	; v1 = y screen position (or -1 is offscreen)
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	L.S F12, 0x0 (A0)
	L.S F13, 0x4 (A0)
	JAL perspective_transform
	L.S F14, 0x8 (A0)
	
	
	LW RA, 0x14 (SP)
	ADDIU SP, SP, 0x18

	BEQ V0, R0, @@offscreen
	MTC1 R0, F4

	C.LT.S F0, F4
	LI.S F5, 1280
	BC1T @@offscreen
	C.LT.S F1, F4
	LI.S F6, 960
	BC1T @@offscreen
	C.LT.S F0, F5
	CVT.W.S F0, F0
	BC1F @@offscreen
	C.LT.S F1, F6
	CVT.W.S F1, F1
	BC1F @@offscreen
	MFC1 V0, F0
	MFC1 V1, F1
	JR RA
	NOP

	@@offscreen:
	SETS V0, 0xFFFF
	JR RA
	SETS V1, 0xFFFF

count_bits:
	MOVE V0, R0
	@loop:
		BEQ A0, R0, @@return
		ANDI AT, A0, 0x1
		ADDU V0, V0, AT
		B @loop
		SRL A0, A0, 1
	@@return:
	JR RA
	NOP

pitch_and_yaw_to_unit_vector:
	ADDIU SP, SP, 0xFFE0
	SW RA, 0x1C (SP)
	
	JAL angle_to_unit_vector
	SW A1, 0x10 (SP)
	
	NEG.S F0, F0
	S.S F0, 0x14 (SP)
	S.S F1, 0x18 (SP)
	
	JAL angle_to_unit_vector
	LW A0, 0x10 (SP)
	
	L.S F4, 0x18 (SP)
	MUL.S F0, F0, F4
	MUL.S F2, F1, F4
	L.S F1, 0x14 (SP)
	
	LW RA, 0x1C (SP)
	JR RA
	ADDIU SP, SP, 0x20

late_spawn_object:
	ADDIU SP, SP, 0xFFE8
	SW RA, 0x14 (SP)

	JAL spawn_object
	NOP
	
	SW V0, 0x10 (SP)
	JAL 0x80383D68
	MOVE A0, V0
	
	LW V0, 0x10 (SP)
	
	LW RA, 0x14 (SP)
	JR RA
	ADDIU SP, SP, 0x18
