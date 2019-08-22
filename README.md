This repo contains both a collection of files that are useful for ROMhacking
Super Mario 64 using assembly language. It also contains the "source" code for
some of my hacks.

## ROMhacks

Note that this repo doesn't have enough to actually build the hacks. Instead the
purpose is to simply let you look through my code, so if you saw something you
want to use in your own hacks, or are interested to know how it was
accomplished, you can look at the code for yourself.  
  
## Useful ASM Files

### code-hooks-skeleton.asm
This file contains a basic code injection file you can use to get your code into
the ROM where you want.

### labels.asm
This file contains a number of labels for the memory addresses of useful
functions and global variables, as well as memory offsets for different fields
in important structs.

### helper-functions.asm
This file contains a number of helper functions I have writen to accomplish
common things such as trigonometric functions, vector manipulation, text
printing, etc.

### behaviour-script-macros.asm
This file contains macros for behaviour script commands.

### macros.asm
THe file contains some general purpose macros for additional pseudoinstructions.
