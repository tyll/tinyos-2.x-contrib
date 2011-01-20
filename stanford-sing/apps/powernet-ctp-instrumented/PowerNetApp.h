/*
 * "Copyright (c) 2009 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF STANFORD UNIVERSITY HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
 * CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT,
 * UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/* File to declare the stucture of the message sent over the radio
 *
 * @author Maria A. Kazandjieva, <mariakaz@cs.stanford.edu>
 * @date Nov 18, 2008
 */

#include <AM.h>

#define SAMPLE_INTERVAL 1024
#define CTP_INTERVAL 307200L // 5 minute timer for CTP
#define RANDOM_INTERVAL 100
#define RANDOM_INTERVAL2 200
#define NUMENTRIES 10
// neccessary for SPI communication
#define CH1_WAVE_MODE_VAL 	0x580C
#define CH2_WAVE_MODE_VAL 	0x780C
#define IRQ_WAVE_SAMPLE_VAL	0x44
#define TEMP_MODE		0x002C

typedef nx_struct meter_msg {
	nx_uint32_t energy;
}meter_msg_t;

typedef nx_struct readings_t {
    meter_msg_t buffer[NUMENTRIES];
} readings_t;

enum
{
	AM_METER_MSG = 0xCD,
};

enum
{
	UNSET,
	SET_GAIN,
	SET_IRQ,
	SET_CH1_MODE,
	SET_CH2_MODE,
	SET_TEMP_MODE,
	GET_CH1,
	GET_CH2,
	GET_ENERGY,
	GET_MODE,
	GET_IRQ,
	GET_GAIN,
	GET_TEMP,
};
