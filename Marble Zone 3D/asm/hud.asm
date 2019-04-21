; Always show HP (in bonus level)
.orga 0x9E68C
ORI T0, R0, 0xC8
SH T0, 0x25F4 (T8)
.fill 32, 0

; Move HP to left side
.orga 0xED5F2
.halfword 0x20

; Completely hide HUD in Game Ogre level
.orga 0x36484
JAL render_hud_shim

; Only show ring counter in main level
.orga 0x9EDC8
JAL render_rings_shim

; Only show health in bonus level
.orga 0x9EE10
JAL render_health_shim

; Don't show life counter
.orga 0x9EDB0
NOP

.orga 0x9EE48
J render_healthbar
