/* Change these constants to tweak the wallrunning behaviour.
Note that angles are stored as 16-bit shorts, so 0x2000 is 45 degrees, 0x4000
is 90 degrees, etc. Time is in number of frames (SM64 is 30fps)
*/

; Maximum number of frames you can continuously wallrun (default: 60 (2 seconds))
MAX_WALLRUN_TIME equ 60

; Minimum angle along the wall at which you can start a wallrun (default: 0x038E (5 degrees))
MIN_WALLRUN_ANGLE equ 0x38E

; Maximum angle along the wall at which you can start a wallrun (default: 0x2000 (45 degrees))
MAX_WALLRUN_ANGLE equ 0x2000

; Maximum angle difference between two surfaces that you can continue a wallrun across (default: 0x18E4 (35 degrees))
; Must be less than 45 degrees
MAX_WALLRUN_ANGLE_CHANGE equ 0x18E4

; Minimum horizontal speed Mario must have to start a wallrun (default: 15)
MIN_WALLRUN_H_SPEED equ 15

; Maximum absolute vertical speed Mario can be rising/falling at and still start a wallrun (default: 25)
MAX_WALLRUN_V_SPEED equ 25

; Width of the stamina bar on screen in pixels (default: 43)
WALLRUN_STAMINA_BAR_WIDTH equ 43

; Height of the stamina bar on screen in pixels (default: 5)
WALLRUN_STAMINA_BAR_HEIGHT equ 5

/* The following constants give the RGB components of the colour, but each
colour component is only 5 bits, so it ranges from 0 to 31. So the colour
white would be 31,31,31 and orange would be 31,16,0 etc.
*/
WALLRUN_STAMINA_BAR_BORDER_COLOUR equ 0,0,0
WALLRUN_STAMINA_BAR_BACKGROUND_COLOUR equ 20,20,20
WALLRUN_STAMINA_BAR_FILL_COLOUR equ 2,28,2

; Surface types that Mario is allowed to wallrun on are defined in wallrun-util.asm
