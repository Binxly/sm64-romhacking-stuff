/*
This skeleton was autogenerated by Bowser's Blueprints. It will NOT be replaced
on rebuilding, so you are free to modify this file.

Do NOT use the .org, .orga, or .headersize commands in this file or files
included by this file. Anything that needs to write to elsewhere in the ROM
should go into globals.asm instead.

The code in this file will run once when the game starts. All main memory is
loaded at this point, but the first frame has not yet run.
*/

ADDIU SP, SP, 0xFFE8
SW RA, 0x14 (SP)

; Your code goes here
LI T0, has_pegasus_boots
SW T0, ALLOW_WALLRUNNING_CHECK

LW RA, 0x14 (SP)
JR RA
ADDIU SP, SP, 0x18