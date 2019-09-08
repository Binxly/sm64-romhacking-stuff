This directory contains my wallrunning code. Feel free to use it in your hacks!
Some sort of shoutout to me on a sign or credits would be appreciated if you use
it, but it's not required.

## Using the Code

You can download this code directly from GitLab by clicking on the download
button (top-right) and clicking on the desired file format under the **Download
this directory** panel.

If you are not doing any custom assembly of your own in your hack, and simply
want to use this code, just copy this directory into the folder where you have
your ROMhack, then either
* run the `master-armips-gui.asm` file in Armips GUI  
 **or**
* alter the `master-armips-cli.asm` file to have the filename of your ROMhack
 and run it in Armips by command line.

If you have your own custom assembly code, you can integrate it into this code.
The `master-armips-gui.asm` file contains basic code hooks you can use to add
your own custom code into the ROM.

You can tweak the wallrunning behaviour easily by editing the `wallrun-config.asm`
file in the `asm` directory.
