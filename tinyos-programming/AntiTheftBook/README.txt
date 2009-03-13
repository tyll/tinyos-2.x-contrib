README for AntiTheftBook
Author/Contact: dgay42@gmail.com

Description:

This directory contains the successive "anti-theft" applications
developed in Chapter 6.1-6.5 of "TinyOS Programming".

Briefly:
- 6.1: a simple blinking LED
- 6.1.1: blinking LED without timing drift
- 6.2.1: theft detection using a photo sensor
- 6.2.4: theft detection using an accelerometer
- 6.3: wireless control and reporting (single-hop)
- 6.4: wireless control and reporting (multi-hop)
- 6.5.2: persistent settings (stored in/recovered from flash)

These applications are written for mica2, micaz or iris motes using
the mts310 sensor board, but should be readily portable to motes with
similar sensors.

These applications are derived from the more full-featured AntiTheft
application distributed with TinyOS 2.x.

Tools:

The settings script will send a settings message to the 6.3, 6.4 and
6.5.2 versions of the application. The listen script prints a raw hex
dump of the theft messages sent by the same versions. Both scripts take
a packet source specification as argument.

Usage:

The following instructions will get you started with these AntiTheft
examples (the instructions are for mica2 motes, replace mica2 with
micaz or iris if using either of those motes)

1. Compile and install the anti-theft code for your platform (mica2, micaz or
   iris):

    $ make mica2

   Install the anti-theft code on some number of mica2 motes, giving
   each mote a distinct id.

    $ make mica2 reinstall.N <your usual installation options>
    # For instance: make mica2 reinstall.22 mib510,/dev/ttyUSB0

2. For version 6.3, compile and install a BaseStation on a mote that 
   you connect to your PC:

    $ cd $TOSDIR/../apps/BaseStation
    $ make mica2 install.0 <your usual installation options>

3. For versions 6.4 and 6.5.2, build and install the root node code
   on a mote with a distinct identifier (e.g., 0):

    $ (cd root; make mica2 install.0 <your usual installation options>)
    # For instance: (cd root; make mica2 install.0 mib510,/dev/ttyUSB0)

4. Put some mts310 sensor boards on the non-root mica2 motes. You can use
   mts300 boards instead, but then the acceleration detection will not work.

5. Connect the root mica2 mote to your PC and switch on all motes.

6. Admire the blinking LEDs and the theft detection!

   Run ./listen <your packet source> to get a hex dump of theft report packets
   in versions 6.3, 6.4 and 6.5.2, e.g.

      $ ./listen serial@/dev/tty.usbserial-M49W90J5:telosb
      serial@/dev/tty.usbserial-M49W90J5:115200: resynchronising
      00 FF FF 00 0B 02 00 2A 00 0B 
      00 FF FF 00 0B 02 00 2A 00 0B 
      00 FF FF 00 0B 02 00 2A 00 0B 

   Run ./settings <your packet source> to change settings in versions
   6.3, 6.4 and 6.5.2: the required acceleration variance is increased
   to 16 (from 4, thus requiring stronger shaking) and the checking interval
   is increased to 4s (from 1/4s)

      $ ./settings serial@/dev/tty.usbserial-M49W90J5:telosb
      serial@/dev/tty.usbserial-M49W90J5:115200: resynchronising
      00 FF FF FF FF 04 00 2B 00 10 10 00 


Known bugs/limitations:

- In versions 6.4 and 6.5.2, a newly turned on mote may not send theft
  reports as:
  o It takes a little while after motes turn on for them to join the multihop
    collection network. 
  o It can take a little while for motes to receive the current settings.

$Id$
