/* "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 * ACme Energy Monitor
 * @author Fred Jiang <fxjiang@eecs.berkeley.edu>
 * @version $Revision$
 */

/**********************
 * types and register defs for ADE7753 energy meter
 */



// Register addresses
#define ADE7753_GAIN            0x0F
#define ADE7753_AENERGY         0x02
#define ADE7753_RAENERGY        0x03
#define ADE7753_LAENERGY		0x04
#define ADE7753_VAENERGY		0x05
#define ADE7753_RVAENERGY		0x06
#define ADE7753_LVAENERGY		0x07
#define ADE7753_LVARENERGY		0x08
#define ADE7753_MODE            0x09
#define ADE7753_IRMS            0x16
#define ADE7753_LINECYC			0x1C


// Register values

// Gain for CH2 is 2 and CH1 is 16 at 0.5 scale
// #define ADE7753_GAIN_VAL        0x24
// Try 0011 for CH1 gain
#define ADE7753_GAIN_VAL        0x04
//#define ADE7753_GAIN_VAL        0x24


// MSB enabled for no-creep
#define ADE7753_MODE_VAL        0x800C
// Set MODE to line cycle accumulation mode CYCMODE
//#define ADE7753_MODE_VAL        0x008C
// #define ADE7753_MODE_VAL        0x000C

#define ADE7753_LINECYC_VAL        0x000A
