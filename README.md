# REpsych
Psychological Warfare in Reverse Engineering

## Overview

The REpsych toolset is a proof-of-concept illustrating the generation of images through a program's control flow graph (CFG).

The process used to generate the proper control flow is outlined in the [DEF CON presentation](slides/domas_2015_repsych.pdf).

Although there is no specific point to the project, possible (non-serious) applications are outlined in the presentation.

The program works reliably with all tested versions of the IDA Pro reverse engineering tool, and semi-reliably with other CFG viewers (Hopper, BinNavi, radare2, etc).

## Usage

The toolset translates source images into functioning programs, such that the program's control flow graph generates the source image.  The tool will create a basic block (CFG node) for each pixel of the source image; as such, you should try to use small source images (not larger than 100x100), and you may need to increase the number of allowed nodes in your CFG viewer.

To generate a new program from an image:

* Save the image as a 24 BPP bitmap.
* Copy the image to gfx/bitmap.bmp
* Run make in the root directory of the project.

Two functioning programs will be created: repsych_v1 and repsych_v2.  Each uses a different strategy for ensuring the CFG renderer correctly places the CFG nodes.

# Examples

![Example 1](examples/repsych_1.png?raw=true)

![Example 4](examples/repsych_4.png?raw=true)

![Example 3](examples/repsych_3.png?raw=true)

![Example 2](examples/repsych_2.png?raw=true)

