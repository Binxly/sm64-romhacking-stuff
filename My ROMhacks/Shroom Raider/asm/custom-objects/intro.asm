.definelabel beh_intro_impl, (org()-0x80000000)
;BHV_START OBJ_LIST_DEFAULT
BHV_EXEC @set_mario_state
BHV_DELETE
BHV_END

@set_mario_state:
LI A0, g_mario
LI A1, ACT_INTRO_TEXT
J set_mario_action
MOVE A2, R0
