.headersize 0x12DE6200
.orga 0x21B544
.area 0x58

beh_tutorial_checkpoint:	; 0x13001744
BHV_START OBJ_LIST_DEFAULT
BHV_JUMP beh_tutorial_checkpoint_impl

beh_checkpoint:				; 0x13001750
BHV_START OBJ_LIST_LEVEL
BHV_JUMP beh_checkpoint_impl

beh_springy_cloud:			; 0x1300175C
BHV_START OBJ_LIST_SURFACE
BHV_JUMP beh_springy_cloud_impl

beh_music_switcher:			; 0x13001768
BHV_START OBJ_LIST_GENERIC
BHV_JUMP beh_music_switcher_impl

beh_timed_ice_block:		; 0x13001774
BHV_START OBJ_LIST_SURFACE
BHV_JUMP beh_timed_ice_block_impl

beh_icicle:					; 0x13001780
BHV_START OBJ_LIST_LEVEL
BHV_JUMP beh_icicle_impl

beh_snowball_spawner:		; 0x1300178C
BHV_START OBJ_LIST_SPAWNER
BHV_JUMP beh_snowball_spawner_impl

.endarea

.orga 0x21A078
.area 0x40

beh_mafia_snowman:			; 0x13000278
BHV_START OBJ_LIST_GENERIC
BHV_JUMP beh_mafia_snowman_impl

beh_snow_patch:				; 0x13000284
BHV_START OBJ_LIST_LEVEL
BHV_JUMP beh_snow_patch_impl

beh_timed_big_ice_block:	; 0x13000290
BHV_START OBJ_LIST_SURFACE
BHV_JUMP beh_timed_big_ice_block_impl

beh_snowgre:				; 0x1300029C
BHV_START OBJ_LIST_GENERIC
BHV_JUMP beh_snowgre_impl

beh_ghost:					; 0x130002A8
BHV_START OBJ_LIST_LEVEL
BHV_JUMP beh_ghost_impl

.endarea

.orga 0x21B408
.area 0x48

beh_intro:					; 0x13001608
BHV_START OBJ_LIST_DEFAULT
BHV_JUMP beh_intro_impl

beh_trial_of_blindsight:	; 0x13001614
BHV_START OBJ_LIST_DEFAULT
BHV_OR_FLAGS o_flags, OBJ_ALWAYS_ACTIVE
BHV_END

beh_trial_of_memory:		; 0x13001620
BHV_START OBJ_LIST_DEFAULT
BHV_JUMP beh_trial_of_memory_impl

beh_door:					; 0x1300162C
BHV_START OBJ_LIST_SURFACE
BHV_JUMP beh_door_impl

beh_brazier:				; 0x13001638
BHV_START OBJ_LIST_LEVEL
BHV_JUMP beh_brazier_impl

beh_flame_of_opening:		; 0x13001644
BHV_START OBJ_LIST_DEFAULT
BHV_JUMP beh_flame_of_opening_impl

.endarea

.orga 0x21D220
.area 0x34

beh_sawblade:				; 0x13003420
BHV_START OBJ_LIST_LEVEL
BHV_JUMP beh_sawblade_impl

beh_ice_trap:				; 0x1300342C
BHV_START OBJ_LIST_SPAWNER
BHV_JUMP beh_ice_trap_impl

beh_chalice_of_winter:		; 0x13003438
BHV_START OBJ_LIST_LEVEL
BHV_JUMP beh_chalice_of_winter_impl

beh_barrier:				; 0x13003444
BHV_START OBJ_LIST_LEVEL
BHV_JUMP beh_barrier_impl

.endarea

