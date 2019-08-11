.relativeinclude on
.open "Shroom Raider.z64",0x80245000
.erroronwarning on
.n64

.include "./labels-v3.2.asm"
.include "./macros-v3.2.asm"
.include "./behaviour-script-macros-v3.2.asm"
.include "./fast-3d-v3.2.asm"

@ROM_START equ 0x7CC6C0
@RAM_START equ 0x80367500

@RAM_OFFSET equ (@RAM_START - @ROM_START)

; (17,536 words)
@MAX_SIZE equ 0x11200

.orga 0x396C
.area 0x24
LI A0, @RAM_START
LI A1, @ROM_START
LI.U A2, @ROM_END
JAL 0x80278504
LI.L A2, @ROM_END
J @restore_overwritten_memory_setup_code
NOP
@end_of_overwritten_memory_setup_code:
.endarea
.skip 4

.orga @ROM_START
.headersize @RAM_OFFSET
.area @MAX_SIZE

@restore_overwritten_memory_setup_code:
OR A0, R0, R0
JAL 0x80277EE0
LUI A1, 0x8000
LUI A0, 0x8034
LUI A1, 0x8034
ADDIU A1, A1, 0xB044
ADDIU A0, A0, 0xB028
LI RA, @end_of_overwritten_memory_setup_code
J 0x803225A0
ADDIU A2, R0, 0x1

@on_every_mario_active_frame:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

; import your code that runs on every frame that Mario is active here
LI T0, g_mario
SETU AT, 0x2
SH AT, m_lives (T0)

JAL check_for_endgame
NOP
JAL wallrun_check
NOP
JAL tutorial_level_loop
NOP
JAL save_last_safe_location
NOP
JAL handle_respawn
NOP
JAL check_for_spike_trap
NOP
JAL check_for_hidden_spike_trap
NOP

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

@gui_extensions:
ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

; import your code that renders additional HUD elements here
JAL render_gui
NOP

JAL render_music_info
NOP

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18

; import your code here that gets loaded into free space
; don't use .org/.orga/.headersize in these files
.include "./helper-functions-v3.2.asm"

.include "./asm/ghost-of-mario-past.asm"
.include "./asm/wallrun-util.asm"
.include "./asm/custom-mario-airborne-actions.asm"
.include "./asm/custom-mario-cutscene-actions.asm"
.include "./asm/custom-mario-automatic-actions.asm"
.include "./asm/wallrun-check.asm"
.include "./asm/gui.asm"
.include "./asm/tutorial-level.asm"
.include "./asm/jump-inertia-fix.asm"
.include "./asm/music-info-flyout.asm"
.include "./asm/mario-respawn.asm"
.include "./asm/pause-screen-text.asm"
.include "./asm/spike-trap.asm"
.include "./asm/particle-opacity.asm"
.include "./asm/trial-of-blindsight.asm"
.include "./asm/draw-camera-shim.asm"

.include "./asm/custom-objects/tutorial-checkpoint.asm"
.include "./asm/custom-objects/respawn-orb.asm"
.include "./asm/custom-objects/checkpoint.asm"
.include "./asm/custom-objects/cloud.asm"
.include "./asm/custom-objects/music-switcher.asm"
.include "./asm/custom-objects/timed-ice-block.asm"
.include "./asm/custom-objects/icicle.asm"
.include "./asm/custom-objects/snowball.asm"
.include "./asm/custom-objects/snowball-spawner.asm"
.include "./asm/custom-objects/mafia-snowman.asm"
.include "./asm/custom-objects/snow-patch.asm"
.include "./asm/custom-objects/snowgre.asm"
.include "./asm/custom-objects/ice-cube.asm"
.include "./asm/custom-objects/angry-whomp.asm"
.include "./asm/custom-objects/ghost.asm"
.include "./asm/custom-objects/intro.asm"
.include "./asm/custom-objects/hidden-spike-trap.asm"
.include "./asm/custom-objects/trial-of-memory.asm"
.include "./asm/custom-objects/door.asm"
.include "./asm/custom-objects/brazier.asm"
.include "./asm/custom-objects/flame-of-opening.asm"
.include "./asm/custom-objects/sawblade.asm"
.include "./asm/custom-objects/ice-trap.asm"
.include "./asm/custom-objects/skull.asm"
.include "./asm/custom-objects/chalice-of-winter.asm"
.include "./asm/custom-objects/barrier.asm"

.include "./models/ice_cube.asm"

.endarea
@RAM_END:
.skip 4
.definelabel @ROM_END, (@RAM_END - @RAM_OFFSET)

.orga 0x8625C
J @on_every_mario_active_frame

.orga 0x9EE48
J @gui_extensions

; import your code here that overwrites the ROM in specific places
; you can freely use .org/.orga/.headersize here (and all files should start with .orga)

.orga 0xF970
JAL mario_air_actions_shim

.orga 0xF9A0
JAL mario_cutscene_actions_shim

.orga 0xF9B8
JAL mario_automatic_actions_shim

.orga 0xD458
J jump_inertia_fix_shim

.orga 0x11270
J sticky_floor_fix_shim

.orga 0x25224
J cloud_no_fall_damage_shim
NOP

.orga 0x21CCE8
.word mario_behaviour_shim

.orga 0x9EE18
JAL draw_camera_shim

.orga 0xB894
JAL check_void_plane_shim

.orga 0xE89E4
.word interact_snowball

.orga 0xE89D4
.word interact_freezing_wind

; Death warp shims
.orga 0x5B0C
JAL kill_mario
SETU A0, 0x30
J 0x8024AEC8
SETU V0, 0x30

.orga 0x5B94
JAL kill_mario
SETU A0, 0x1B
J 0x8024AEC8
SETU V0, 0x1B


.include "./asm/remove-vanilla-gui.asm"
.include "./asm/hud-icons.asm"

.include "./asm/purple-switch-mod.asm"
.include "./asm/misc-tweaks.asm"
.include "./asm/exposed_behaviour_scripts.asm"
.include "./asm/tutorial-texture-imports.asm"
.include "./asm/remove-borders.asm"
.include "./asm/revert-to-checkpoint.asm"
.include "./asm/ogre-cutscene.asm"
.include "./asm/star-dance-edits.asm"

.include "./models/mountain_models.asm"
.include "./models/crypt_models.asm"

.close
