.definelabel beh_checkpoint_impl, (org()-0x80000000)
;BHV_START OBJ_LIST_LEVEL
BHV_OR_FLAGS o_flags, OBJ_FLAG_UPDATE_GFX | OBJ_STORE_DISTANCE_TO_MARIO
BHV_BILLBOARD
BHV_SCALE 700
BHV_SET_INTERACTION 0x00040000
BHV_SET_INT o_intangibility_timer, 0
BHV_SET_HITBOX 50, 25, 25
BHV_EXEC @init
BHV_LOOP_BEGIN
	BHV_SET_INT o_interaction_status, 0
	.word 0x341A0002 ; texture animation thingy
	BHV_EXEC @loop
BHV_LOOP_END

active_checkpoint:
.word 0

@init:
SW R0, active_checkpoint
LW T0, g_current_obj_ptr
SW R0, o_state (T0)
LHU T1, o_gfx_flags (T0)
ORI T1, T1, 0x10
JR RA
SH T1, o_gfx_flags (T0)

@loop:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)
SW S0, 0x10 (SP)

LW S0, g_current_obj_ptr

LW T0, o_state (S0)
LW T1, active_checkpoint
BNE T0, R0, @checkpoint_active
NOP
@checkpoint_inactive:
	BNE T1, S0, @endif_become_active
		@activate:
		SETU AT, 0x1
		SW AT, o_state (S0)
		SW S0, active_checkpoint
		LUI A0, 0x527F
		JAL play_sound
		ORI A0, A0, 0x8081
		LHU T0, o_gfx_flags (S0)
		ANDI T0, T0, 0xFFEF
		SH T0, o_gfx_flags (S0)
		B @endif_become_inactive
	@endif_become_active:
	LUI AT, 0x4416
	MTC1 AT, F5
	L.S F4, o_distance_to_mario (S0)
	C.LE.S F4, F5
	NOP
	BC1F @return
	NOP
	B @activate
	NOP
@checkpoint_active:
	BEQ T1, S0, @endif_become_inactive
		@deactivate:
		LHU T0, o_gfx_flags (S0)
		ORI T0, T0, 0x10
		SH T0, o_gfx_flags (S0)
		B @return
		SW R0, o_state (S0)
	@endif_become_inactive:
	LUI AT, 0x43FA
	MTC1 AT, F5
	L.S F4, o_distance_to_mario (S0)
	C.LE.S F4, F5
	LI T0, g_mario
	BC1F @return
		LBU AT, m_hurt_counter (T0)
		BNE AT, R0, @return
		LBU T1, m_heal_counter (T0)
		MAXI T1, T1, 0x1
		SB T1, m_heal_counter (T0)

@return:
LW S0, 0x10 (SP)
LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18
