This repo contains both a collection of files that are useful for ROMhacking
Super Mario 64 using assembly language. It also contains the "source" code for
some of my hacks.

## ROMhacks

The `My ROMhacks` folder contains `.bps` patches which you can patch onto the US
version of a vanilla Super Mario 64 ROM to play my ROMhack. You can patch the
ROM using [flips](https://github.com/Alcaro/Flips), which is available for both
Linux and Windows. If you have a Mac, you can run the Windows version through
WINE.

Additionally, I have also included the source code for the custom assembly code
used in these hacks. Note that this repo doesn't have enough to actually build
the hacks. Instead the purpose is to simply let you look through my code, so if
you saw something you want to use in your own hacks, or are interested to know
how it was accomplished, you can look at the code for yourself. To actually
download and play the hacks, use the `.bps` file instead.
  
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
printing, etc. You must also include *labels.asm* to use this.

### behaviour-script-macros.asm
This file contains macros for behaviour script commands.

### macros.asm
THe file contains some general purpose macros for additional pseudoinstructions.
