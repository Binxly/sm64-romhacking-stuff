; Write new health icons over the power metre
.headersize 0x254DBF4
.orga 0xAD57EC
.area 0x6000

heart_empty:
.incbin "../hud-icons/heart-empty.bin"

heart_quarter:
.incbin "../hud-icons/heart-¼.bin"

heart_half:
.incbin "../hud-icons/heart-½.bin"

heart_three_quarters:
.incbin "../hud-icons/heart-¾.bin"

heart_full:
.incbin "../hud-icons/heart-full.bin"

analog_stick_1:
.incbin "../hud-icons/analog-stick-1.bin"

analog_stick_2:
.incbin "../hud-icons/analog-stick-2.bin"

a_button_1:
.incbin "../hud-icons/a-button-1.bin"

a_button_2:
.incbin "../hud-icons/a-button-2.bin"

eye_icon:
.incbin "../hud-icons/eye.bin"

skull_16:
.incbin "../hud-icons/skull-16.bin"

skull_32:
.incbin "../hud-icons/skull-32.bin"

.fill 0x200, 0

mountain_img:
.incbin "../hud-icons/mountain.bin"

mario_img:
.incbin "../hud-icons/smw_mario.bin"

chalice_img:
.incbin "../hud-icons/chalice.bin"

; Not a HUD icon, but this was a convenient place to put this
ice_texture:
.incbin "../models/ice-block/texture.bin"

.endarea


; Replace dialog text characters

.orga 0x8099D6
.incbin "../hud-icons/hyphen.bin" ; left/right arrows ---> hyphen

.orga 0x809C56
.incbin "../hud-icons/forward-slash.bin" ; middle dot ---> forward slash
