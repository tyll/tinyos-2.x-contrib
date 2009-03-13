README for SoundLocalizer
Author/Contact: dgay42@gmail.com

Description:

This directory contains the "SoundLocalizer" application developed in
Chapter 13 of "TinyOS Programming". It is designed for micaz motes
with an mts300 sensor board, but should be portable to motes with
other sensors if the low-level sensor sampling code is rewritten.

SoundLocalizer implements a coordinated event detection system where a
group of motes detect a particular event - a loud sound - and then
communicate amongst themselves to figure out which mote detected the
event first and is therefore presumed closest to where the event
occurs.

A number of detector motes are placed on a surface a couple of feet
apart. When the single coordinator mote is switched on, it sends a
series of radio packets that let the detector motes synchronize their
clocks. At a time specified by the coordinator mote, all detectors
turn on their green LED and start listening for a loud sound such as a
hand clap. Once such a sound is heard, the motes turn on their yellow
LED. Finally, the motes enter a "voting" phase where only the mote
with the earliest detection time leaves its yellow LED on. The
earliest detection time should correspond to the mote closest to the
sound.

Tools:

None.

Usage:

1. Compile and install the coordinator code.

   If you are using TinyOS 2.1 or earlier, please first apply the patch 
   under Known Bugs below.

    $ (cd Coordinator; make micaz install.0 <your usual installation options>)

2. Compile and install the detector code on multiple motes:

    $ cd Detector
    $ make micaz

    Then for each detector mote:
    $ make micaz reinstall.<unique id> <your usual installation options>

3. Switch the coordinator mote off, and all the detector motes on.

4. Switch the coordinator mote on, and wait for the detector motes to turn
   their green LED on.

5. Make a loud sound. After a little while, the mote closest to the sound
   should be the only one whose yellow LED is on.

Known bugs/limitations:

- If on step 4, the motes turn on their red LED, you need to make the
following change to tinyos-2.x/tos/chips/atm128/i2c/Atm128I2CMasterPacketP.nc:
in the AsyncStdControl.start command (around line 90), replace
	call I2C.init(FALSE);

with

#ifndef ATM128_EXTERNAL_PULLDOWN
#define ATM128_EXTERNAL_PULLDOWN FALSE
#endif
	call I2C.init(ATM128_EXTERNAL_PULLDOWN);

- Better time synchronization would produce more reliable "closest to the
sound" detection...

$Id$
