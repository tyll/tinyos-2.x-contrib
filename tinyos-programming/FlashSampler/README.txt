README for FlashSampler
Author/Contact: dgay42@gmail.com

Description:

This directory contains the "FlashSampler" application developed in
Chapter 6.5.3 of "TinyOS Programming". It is designed for micaz motes
with an mts310 sensor board, but should be easily ported to use another
sensor and/or mote.

FlashSampler is a two-level sampling application. It periodically
collect 32k samples of an accelerometer, storing the data in a Block
storage volume.  It then logs a summary of this sample to a circular
log. As a result, the system will at all times have the most recent
measurement with full fidelity, and some number of older measurements
with reduced fidelity.

Tools:

None.

Usage:

1. Compile and install the application:

    $ make micaz install <your usual installation options>)

2. Once you turn the mote on, it will sample to flash for ~30s at 1kHz,
   write a summary of the sample to the log, go to sleep for a minute,
   then repeat. LED 0 is on during sampling, LED 1 is on during
   summarization. LED 2 is toggled on every buffer swap during sampling.

Known bugs/limitations:

Note: writing a tool to extract the data from the flash is an exercise
left to the reader...

$Id$
