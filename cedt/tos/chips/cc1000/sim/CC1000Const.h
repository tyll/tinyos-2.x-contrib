// $Id$

/* -*- Mode: C; c-basic-indent: 2; indent-tabs-mode: nil -*- */ 
/*									tab:4
 *  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.  By
 *  downloading, copying, installing or using the software you agree to
 *  this license.  If you do not agree to this license, do not download,
 *  install, copy or use the software.
 *
 *  Intel Open Source License 
 *
 *  Copyright (c) 2002 Intel Corporation 
 *  All rights reserved. 
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are
 *  met:
 * 
 *	Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *      Neither the name of the Intel Corporation nor the names of its
 *  contributors may be used to endorse or promote products derived from
 *  this software without specific prior written permission.
 *  
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 *  PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE INTEL OR ITS
 *  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * 
 */

/*
 * Constants for CC1000 radio
 *
 * @author Phil Buonadonna
 */

/* 
 * Added constants required for CC1000 radio Simulation for TOSSIM
 *
 * @author Venkatesh S
 * @author Prabhakar T V
 *
 */
#ifndef CC1000CONST_H
#define CC1000CONST_H

#include <CC1000Msg.h>
#include <atm128const.h>

//CC1000 Reg Array

#define CC1K_MAX_REGS 0x47
uint8_t CC1KRegFile[TOSSIM_MAX_NODES][CC1K_MAX_REGS];

//CC1000 Reg Access
#define CC1K_REG_ACCESS(x) CC1KRegFile[sim_node()][x]

// Bit operators using bit number
#define CC1K_SET_BIT(reg, bit)    ((CC1K_REG_ACCESS(reg)) |= _BV(bit))
#define CC1K_CLR_BIT(reg, bit)    ((CC1K_REG_ACCESS(reg)) &= ~_BV(bit))
#define CC1K_READ_BIT(reg, bit)   (((CC1K_REG_ACCESS(reg)) & _BV(bit)) != 0)

//Tx power mode values
float CC1K_RADIO_PowerMode[256] = {0.0,
-20.000000,
-18.000000,
-15.000000,
-12.000000,
-10.000000,
-8.000000,
-7.000000,
-6.000000,
-5.000000,
-4.000000,
-3.000000,
-2.000000,
-1.495854,
-1.000000,
0.000000,
1.061160,
2.041808,
2.944313,
3.771047,
4.524382,
5.206689,
5.820338,
6.367701,
6.851149,
7.273054,
7.635786,
7.941716,
8.193216,
8.392658,
8.542411,
8.644848,
8.702340,
8.717257,
8.691971,
8.628853,
8.530275,
8.398607,
8.236220,
8.045486,
7.828777,
7.588462,
7.326914,
7.046503,
6.749601,
6.438579,
6.115807,
5.783658,
5.444503,
5.100712,
4.754657,
4.408709,
4.065238,
3.726618,
3.395217,
3.073409,
2.763563,
2.468051,
2.189244,
1.929514,
1.691232,
1.476768,
1.288494,
1.128781,
1.000000,
0.903771,
0.838702,
0.802653,
0.793480,
0.809042,
0.847196,
0.905799,
0.982711,
1.075787,
1.182887,
1.301867,
1.430586,
1.566901,
1.708669,
1.853750,
2.000000,
2.145582,
2.289879,
2.432577,
2.573365,
2.711930,
2.847958,
2.981139,
3.111158,
3.237703,
3.360462,
3.479123,
3.593372,
3.702896,
3.807384,
3.906523,
4.000000,
4.087632,
4.169752,
4.246823,
4.319310,
4.387673,
4.452377,
4.513885,
4.572659,
4.629162,
4.683858,
4.737209,
4.789678,
4.841729,
4.893824,
4.946427,
5.000000,
5.054917,
5.111192,
5.168752,
5.227522,
5.287427,
5.348392,
5.410344,
5.473208,
5.536909,
5.601373,
5.666525,
5.732290,
5.798595,
5.865365,
5.932525,
6.000000,
6.067701,
6.135479,
6.203168,
6.270603,
6.337620,
6.404053,
6.469738,
6.534509,
6.598202,
6.660651,
6.721692,
6.781160,
6.838890,
6.894716,
6.948475,
7.000000,
7.049167,
7.096009,
7.140599,
7.183010,
7.223316,
7.261588,
7.297900,
7.332325,
7.364936,
7.395806,
7.425009,
7.452616,
7.478701,
7.503337,
7.526597,
7.548554,
7.569281,
7.588851,
7.607337,
7.624812,
7.641349,
7.657021,
7.671901,
7.686062,
7.699577,
7.712518,
7.724960,
7.736975,
7.748635,
7.760015,
7.771186,
7.782222,
7.793197,
7.804182,
7.815251,
7.826477,
7.837933,
7.849692,
7.861827,
7.874410,
7.887516,
7.901216,
7.915585,
7.930694,
7.946617,
7.963427,
7.981197,
8.000000,
8.019891,
8.040854,
8.062855,
8.085860,
8.109835,
8.134746,
8.160560,
8.187243,
8.214760,
8.243078,
8.272162,
8.301980,
8.332496,
8.363677,
8.395490,
8.427899,
8.460872,
8.494374,
8.528372,
8.562831,
8.597718,
8.632999,
8.668639,
8.704606,
8.740864,
8.777381,
8.814121,
8.851052,
8.888139,
8.925349,
8.962647,
9.000000,
9.037373,
9.074734,
9.112047,
9.149279,
9.186396,
9.223365,
9.260150,
9.296719,
9.333037,
9.369071,
9.404786,
9.440149,
9.475126,
9.509683,
9.543785,
9.577400,
9.610492,
9.643029,
9.674976,
9.706300,
9.736966,
9.766940,
9.796189,
9.824679,
9.852376,
9.879245,
9.905254,
9.930368,
9.954553,
9.977775,
10.000000 };

/* used to get the kbps from baud rate, 
  assumed to be manchester encoding hence x*2
*/
uint32_t CC1K_RADIO_BAUDRATE[6]= {
	600*2, // 0.6 kbps
	1200*2, //
	2400*2,
	4800*2,
	9600*2,
	19200*2,//19.2 kbps
};

//Macro which returns 0 if the node is in RX state else 1 if TX state
//checks for the DDRB which is connected to the radio to know the 
//status of the radio

#define CC1K_RADIO_STATE (READ_BIT(ATM128_DDRB,2) && READ_BIT(ATM128_DDRB,3))?(1):(0)

//Macros which informs the status of the radio

#define CC1K_RADIO_CORE_ON ((CC1K_REG_ACCESS(CC1K_MAIN) & (1 << CC1K_CORE_PD))?(0):(1))

#define CC1K_RADIO_BIAS_ON ((CC1K_REG_ACCESS(CC1K_MAIN) & (1 << CC1K_BIAS_PD))?(0):(1))

#define CC1K_RADIO_OFF (((CC1K_REG_ACCESS(CC1K_MAIN) & (1 << CC1K_RX_PD | \
															   1 << CC1K_TX_PD | \
		  											 		   1 << CC1K_FS_PD | \
															   1 << CC1K_CORE_PD | \
															   1 << CC1K_BIAS_PD | \
			  											 	   1 << CC1K_RESET_N))?(0):(1))

//Macro to find the radio ticks based on Buadrate settings  and 
//the XLAT freq settings , for mica2 its 14 Mhz
#define CC1K_RADIO_TICKS 14745600/(6000*(uint32_t)pow(2,(CC1K_REG_ACCESS(CC1K_MODEM0) >> CC1K_BAUDRATE & 0X7))) 


//SPI event handler for all the nodes
sim_event_t* spi_event_t[TOSSIM_MAX_NODES];
bool spi_event_flags[TOSSIM_MAX_NODES];

#define spi_event spi_event_t[sim_node()]
#define spi_flag spi_event_flags[sim_node()]
/* Constants defined for CC1K */
/* Register addresses */

enum {
  CC1K_MAIN =           0x00,
  CC1K_FREQ_2A =        0x01,
  CC1K_FREQ_1A =        0x02,
  CC1K_FREQ_0A =        0x03,
  CC1K_FREQ_2B =        0x04,
  CC1K_FREQ_1B =        0x05,
  CC1K_FREQ_0B =        0x06,
  CC1K_FSEP1 =          0x07,
  CC1K_FSEP0 =          0x08,
  CC1K_CURRENT =        0x09,
  CC1K_FRONT_END =      0x0A, //10
  CC1K_PA_POW =         0x0B, //11
  CC1K_PLL =            0x0C, //12
  CC1K_LOCK =           0x0D, //13
  CC1K_CAL =            0x0E, //14
  CC1K_MODEM2 =         0x0F, //15
  CC1K_MODEM1 =         0x10, //16
  CC1K_MODEM0 =         0x11, //17
  CC1K_MATCH =          0x12, //18
  CC1K_FSCTRL =         0x13, //19
  CC1K_FSHAPE7 =        0x14, //20
  CC1K_FSHAPE6 =        0x15, //21
  CC1K_FSHAPE5 =        0x16, //22
  CC1K_FSHAPE4 =        0x17, //23
  CC1K_FSHAPE3 =        0x18, //24
  CC1K_FSHAPE2 =        0x19, //25
  CC1K_FSHAPE1 =        0x1A, //26
  CC1K_FSDELAY =        0x1B, //27
  CC1K_PRESCALER =      0x1C, //28
  CC1K_TEST6 =          0x40, //64
  CC1K_TEST5 =          0x41, //66
  CC1K_TEST4 =          0x42, //67
  CC1K_TEST3 =          0x43, //68
  CC1K_TEST2 =          0x44, //69
  CC1K_TEST1 =          0x45, //70
  CC1K_TEST0 =          0x46, //71

  // MAIN Register Bit Posititions
  CC1K_RXTX =		7,
  CC1K_F_REG =		6,
  CC1K_RX_PD =		5,
  CC1K_TX_PD =		4,
  CC1K_FS_PD =		3,
  CC1K_CORE_PD =	2,
  CC1K_BIAS_PD =	1,
  CC1K_RESET_N =	0,

  // CURRENT Register Bit Positions
  CC1K_VCO_CURRENT =	4,
  CC1K_LO_DRIVE =	2,
  CC1K_PA_DRIVE =	0,

  // FRONT_END Register Bit Positions
  CC1K_BUF_CURRENT =	5,
  CC1K_LNA_CURRENT =	3,
  CC1K_IF_RSSI =	1,
  CC1K_XOSC_BYPASS =	0,

  // PA_POW Register Bit Positions
  CC1K_PA_HIGHPOWER =	4,
  CC1K_PA_LOWPOWER =	0,

  // PLL Register Bit Positions
  CC1K_EXT_FILTER =	7,
  CC1K_REFDIV =		3,
  CC1K_ALARM_DISABLE =	2,
  CC1K_ALARM_H =	1,
  CC1K_ALARM_L =	0,

  // LOCK Register Bit Positions
  CC1K_LOCK_SELECT =		4,
  CC1K_PLL_LOCK_ACCURACY =	3,
  CC1K_PLL_LOCK_LENGTH =	2,
  CC1K_LOCK_INSTANT =		1,
  CC1K_LOCK_CONTINUOUS =	0,

  // CAL Register Bit Positions
  CC1K_CAL_START =	7,
  CC1K_CAL_DUAL =	6,
  CC1K_CAL_WAIT =	5,
  CC1K_CAL_CURRENT =	4,
  CC1K_CAL_COMPLETE =	3,
  CC1K_CAL_ITERATE =	0,

  // MODEM2 Register Bit Positions
  CC1K_PEAKDETECT =		7,
  CC1K_PEAK_LEVEL_OFFSET =	0,

  // MODEM1 Register Bit Positions
  CC1K_MLIMIT =		5,
  CC1K_LOCK_AVG_IN =	4,
  CC1K_LOCK_AVG_MODE =	3,
  CC1K_SETTLING =	1,
  CC1K_MODEM_RESET_N =	0,

  // MODEM0 Register Bit Positions
  CC1K_BAUDRATE =	4,
  CC1K_DATA_FORMAT =	2,
  CC1K_XOSC_FREQ =	0,

  // MATCH Register Bit Positions
  CC1K_RX_MATCH =	4,
  CC1K_TX_MATCH =	0,

  // FSCTLR Register Bit Positions
  CC1K_DITHER1 =	3,
  CC1K_DITHER0 =	2,
  CC1K_SHAPE =		1,
  CC1K_FS_RESET_N =	0,

  // PRESCALER Register Bit Positions
  CC1K_PRE_SWING =	6,
  CC1K_PRE_CURRENT =	4,
  CC1K_IF_INPUT =	3,
  CC1K_IF_FRONT =	2,

  // TEST6 Register Bit Positions
  CC1K_LOOPFILTER_TP1 =	7,
  CC1K_LOOPFILTER_TP2 =	6,
  CC1K_CHP_OVERRIDE =	5,
  CC1K_CHP_CO =		0,

  // TEST5 Register Bit Positions
  CC1K_CHP_DISABLE =	5,
  CC1K_VCO_OVERRIDE =	4,
  CC1K_VCO_AO =		0,

  // TEST3 Register Bit Positions
  CC1K_BREAK_LOOP =	4,
  CC1K_CAL_DAC_OPEN =	0,


  /* 
   * CC1K Register Parameters Table
   *
   * This table follows the same format order as the CC1K register 
   * set EXCEPT for the last entry in the table which is the 
   * CURRENT register value for TX mode.
   *  
   * NOTE: To save RAM space, this table resides in program memory (flash). 
   * This has two important implications:
   *	1) You can't write to it (duh!)
   *	2) You must read it using the PRG_RDB(addr) macro. IT CANNOT BE ACCESSED AS AN ORDINARY C ARRAY.  
   * 
   * Add/remove individual entries below to suit your RF tastes.
   * 
   */
  CC1K_433_002_MHZ =	0x00,
  CC1K_915_998_MHZ =	0x01,
  CC1K_434_845_MHZ =    0x02,
  CC1K_914_077_MHZ =    0x03,
  CC1K_315_178_MHZ =    0x04,

  //#define CC1K_SquelchInit        0x02F8 // 0.90V using the bandgap reference
  CC1K_SquelchInit =        0x120,
  CC1K_SquelchTableSize =   9,
  CC1K_MaxRSSISamples =     5,
  CC1K_Settling =           1,
  CC1K_ValidPrecursor =     2,
  CC1K_SquelchIntervalFast = 128,
  CC1K_SquelchIntervalSlow = 2560,
  CC1K_SquelchCount =       30,
  CC1K_SquelchBuffer =      12,

  CC1K_LPL_STATES =         9,

  CC1K_LPL_PACKET_TIME =    16,

  CC1K_LPL_CHECK_TIME =     16, /* In tenth's of milliseconds, this should
				  be an approximation of the on-time for
			          a LPL check rather than the total check
			          time. */
  CC1K_LPL_MIN_INTERVAL =    5, /* In milliseconds, the minimum interval
				   between low-power-listening checks */
  CC1K_LPL_MAX_INTERVAL =    10000  /* In milliseconds, the maximum interval
				       between low-power-listening checks.
				       Arbitrary value, but must be at
				       most 32767 because of the way
				       sleep interval is stored in outgoing
				       messages */
};

#ifdef CC1K_DEFAULT_FREQ
#define CC1K_DEF_PRESET (CC1K_DEFAULT_FREQ)
#endif
#ifdef CC1K_MANUAL_FREQ
#define CC1K_DEF_FREQ (CC1K_MANUAL_FREQ)
#endif

#ifndef CC1K_DEF_PRESET
#define CC1K_DEF_PRESET	(CC1K_434_845_MHZ)
#endif 

static const_uint8_t CC1K_Params[6][20] = {
  // (0) 433.002 MHz channel, 19.2 Kbps data, Manchester Encoding, High Side LO
  { // MAIN   0x00
    0x31,
    // FREQ2A,FREQ1A,FREQ0A  0x01-0x03
    0x58,0x00,0x00,					
    // FREQ2B,FREQ1B,FREQ0B  0x04-0x06
    0x57,0xf6,0x85,    //XBOW
    // FSEP1, FSEP0     0x07-0x08
    0X03,0x55,
    // CURRENT RX MODE VALUE   0x09 also see below
    4 << CC1K_VCO_CURRENT | 1 << CC1K_LO_DRIVE,	
    // FRONT_END  0x0a
    1 << CC1K_IF_RSSI,
    // PA_POW  0x0b
    0x0 << CC1K_PA_HIGHPOWER | 0xf << CC1K_PA_LOWPOWER, 
    // PLL  0x0c
    12 << CC1K_REFDIV,		
    // LOCK  0x0d
    0xe << CC1K_LOCK_SELECT,
    // CAL  0x0e
    1 << CC1K_CAL_WAIT | 6 << CC1K_CAL_ITERATE,	
    // MODEM2  0x0f
    0 << CC1K_PEAKDETECT | 28 << CC1K_PEAK_LEVEL_OFFSET,
    // MODEM1  0x10
    3 << CC1K_MLIMIT | 1 << CC1K_LOCK_AVG_MODE | CC1K_Settling << CC1K_SETTLING | 1 << CC1K_MODEM_RESET_N, 
    // MODEM0  0x11
    5 << CC1K_BAUDRATE | 1 << CC1K_DATA_FORMAT | 1 << CC1K_XOSC_FREQ,
    // MATCH  0x12
    0x7 << CC1K_RX_MATCH | 0x0 << CC1K_TX_MATCH,
    // tx current (extra)
    8 << CC1K_VCO_CURRENT | 1 << CC1K_PA_DRIVE,
  },

  // 1 915.9988 MHz channel, 19.2 Kbps data, Manchester Encoding, High Side LO
  { // MAIN   0x00 
    0x31,
    // FREQ2A,FREQ1A,FREQ0A  0x01-0x03
    0x7c,0x00,0x00,					
    // FREQ2B,FREQ1B,FREQ0B  0x04-0x06
    0x7b,0xf9,0xae,					
    // FSEP1, FSEP0     0x07-0x8
    0x02,0x38,
    // CURRENT RX MODE VALUE   0x09 also see below
    8 << CC1K_VCO_CURRENT | 3 << CC1K_LO_DRIVE,
    //0x8C,	
    // FRONT_END  0x0a
    1 << CC1K_BUF_CURRENT | 2 << CC1K_LNA_CURRENT | 1 << CC1K_IF_RSSI,
    //0x32,
    // PA_POW  0x0b
    0x8 << CC1K_PA_HIGHPOWER | 0x0 << CC1K_PA_LOWPOWER, 
    //0xff,
    // PLL  0xc
    8 << CC1K_REFDIV,		
    //0x40,
    // LOCK  0xd
    0x1 << CC1K_LOCK_SELECT,
    //0x10,
    // CAL  0xe
    1 << CC1K_CAL_WAIT | 6 << CC1K_CAL_ITERATE,	
    //0x26,
    // MODEM2  0xf
    1 << CC1K_PEAKDETECT | 33 << CC1K_PEAK_LEVEL_OFFSET,
    //0xA1,
    // MODEM1  0x10
    3 << CC1K_MLIMIT | 1 << CC1K_LOCK_AVG_MODE | CC1K_Settling << CC1K_SETTLING | 1 << CC1K_MODEM_RESET_N, 
    //0x6f, 
    // MODEM0  0x11
    5 << CC1K_BAUDRATE | 1 << CC1K_DATA_FORMAT | 1 << CC1K_XOSC_FREQ,
    //0x55,
    // MATCH 0x12
    0x1 << CC1K_RX_MATCH | 0x0 << CC1K_TX_MATCH,
    // tx current (extra)
    15 << CC1K_VCO_CURRENT | 3 << CC1K_PA_DRIVE,
  },

  // 2 434.845200 MHz channel, 19.2 Kbps data, Manchester Encoding, High Side LO
  { // MAIN   0x00
    0x31,
    // FREQ2A,FREQ1A,FREQ0A  0x01-0x03
    0x51,0x00,0x00,					
    // FREQ2B,FREQ1B,FREQ0B  0x04-0x06
    0x50,0xf7,0x4F,    //XBOW
    // FSEP1, FSEP0     0x07-0x08
    0X03,0x0E,
    // CURRENT RX MODE VALUE   0x09 also see below
    4 << CC1K_VCO_CURRENT | 1 << CC1K_LO_DRIVE,	
    // FRONT_END  0x0a
    1 << CC1K_IF_RSSI,
    // PA_POW  0x0b
    0x0 << CC1K_PA_HIGHPOWER | 0xf << CC1K_PA_LOWPOWER, 
    // PLL  0x0c
    11 << CC1K_REFDIV,		
    // LOCK  0x0d
    0xe << CC1K_LOCK_SELECT,
    // CAL  0x0e
    1 << CC1K_CAL_WAIT | 6 << CC1K_CAL_ITERATE,	
    // MODEM2  0x0f
    1 << CC1K_PEAKDETECT | 33 << CC1K_PEAK_LEVEL_OFFSET,
    // MODEM1  0x10
    3 << CC1K_MLIMIT | 1 << CC1K_LOCK_AVG_MODE | CC1K_Settling << CC1K_SETTLING | 1 << CC1K_MODEM_RESET_N, 
    // MODEM0  0x11
    5 << CC1K_BAUDRATE | 1 << CC1K_DATA_FORMAT | 1 << CC1K_XOSC_FREQ,
    // MATCH  0x12
    0x7 << CC1K_RX_MATCH | 0x0 << CC1K_TX_MATCH,
    // tx current (extra)
    8 << CC1K_VCO_CURRENT | 1 << CC1K_PA_DRIVE,
  },

 
  // 3 914.077 MHz channel, 19.2 Kbps data, Manchester Encoding, High Side LO
  { // MAIN   0x00 
    0x31,
    // FREQ2A,FREQ1A,FREQ0A  0x01-0x03
    0x5c,0xe0,0x00,					
    // FREQ2B,FREQ1B,FREQ0B  0x04-0x06
    0x5c,0xdb,0x42,					
    // FSEP1, FSEP0     0x07-0x8
    0x01,0xAA,
    // CURRENT RX MODE VALUE   0x09 also see below
    8 << CC1K_VCO_CURRENT | 3 << CC1K_LO_DRIVE,
    //0x8C,	
    // FRONT_END  0x0a
    1 << CC1K_BUF_CURRENT | 2 << CC1K_LNA_CURRENT | 1 << CC1K_IF_RSSI,
    //0x32,
    // PA_POW  0x0b
    0x8 << CC1K_PA_HIGHPOWER | 0x0 << CC1K_PA_LOWPOWER, 
    //0xff,
    // PLL  0xc
    6 << CC1K_REFDIV,		
    //0x40,
    // LOCK  0xd
    0x1 << CC1K_LOCK_SELECT,
    //0x10,
    // CAL  0xe
    1 << CC1K_CAL_WAIT | 6 << CC1K_CAL_ITERATE,	
    //0x26,
    // MODEM2  0xf
    1 << CC1K_PEAKDETECT | 33 << CC1K_PEAK_LEVEL_OFFSET,
    //0xA1,
    // MODEM1  0x10
    3 << CC1K_MLIMIT | 1 << CC1K_LOCK_AVG_MODE | CC1K_Settling << CC1K_SETTLING | 1 << CC1K_MODEM_RESET_N, 
    //0x6f, 
    // MODEM0  0x11
    5 << CC1K_BAUDRATE | 1 << CC1K_DATA_FORMAT | 1 << CC1K_XOSC_FREQ,
    //0x55,
    // MATCH 0x12
    0x1 << CC1K_RX_MATCH | 0x0 << CC1K_TX_MATCH,
    // tx current (extra)
    15 << CC1K_VCO_CURRENT | 3 << CC1K_PA_DRIVE,
  },

  // 4 315.178985 MHz channel, 38.4 Kbps data, Manchester Encoding, High Side LO
  { // MAIN   0x00
    0x31,
    // FREQ2A,FREQ1A,FREQ0A  0x01-0x03
    0x45,0x60,0x00,					
    // FREQ2B,FREQ1B,FREQ0B  0x04-0x06
    0x45,0x55,0xBB,
    // FSEP1, FSEP0     0x07-0x08
    0X03,0x9C,
    // CURRENT RX MODE VALUE   0x09 also see below
    8 << CC1K_VCO_CURRENT | 0 << CC1K_LO_DRIVE,	
    // FRONT_END  0x0a
    1 << CC1K_IF_RSSI,
    // PA_POW  0x0b
    0x0 << CC1K_PA_HIGHPOWER | 0xf << CC1K_PA_LOWPOWER, 
    // PLL  0x0c
    13 << CC1K_REFDIV,		
    // LOCK  0x0d
    0xe << CC1K_LOCK_SELECT,
    // CAL  0x0e
    1 << CC1K_CAL_WAIT | 6 << CC1K_CAL_ITERATE,	
    // MODEM2  0x0f
    1 << CC1K_PEAKDETECT | 33 << CC1K_PEAK_LEVEL_OFFSET,
    // MODEM1  0x10
    3 << CC1K_MLIMIT | 1 << CC1K_LOCK_AVG_MODE | CC1K_Settling << CC1K_SETTLING | 1 << CC1K_MODEM_RESET_N, 
    // MODEM0  0x11
    5 << CC1K_BAUDRATE | 1 << CC1K_DATA_FORMAT | 0 << CC1K_XOSC_FREQ,
    // MATCH  0x12
    0x7 << CC1K_RX_MATCH | 0x0 << CC1K_TX_MATCH,
    // tx current (extra)
    8 << CC1K_VCO_CURRENT | 1 << CC1K_PA_DRIVE,
  },

  // 5 Spare
  { // MAIN   0x00
    0x31,
    // FREQ2A,FREQ1A,FREQ0A  0x01-0x03
    0x58,0x00,0x00,					
    // FREQ2B,FREQ1B,FREQ0B  0x04-0x06
    0x57,0xf6,0x85,    //XBOW
    // FSEP1, FSEP0     0x07-0x08
    0X03,0x55,
    // CURRENT RX MODE VALUE   0x09 also see below
    8 << CC1K_VCO_CURRENT | 4 << CC1K_LO_DRIVE,	
    // FRONT_END  0x0a
    1 << CC1K_IF_RSSI,
    // PA_POW  0x0b
    0x0 << CC1K_PA_HIGHPOWER | 0xf << CC1K_PA_LOWPOWER, 
    // PLL  0x0c
    12 << CC1K_REFDIV,		
    // LOCK  0x0d
    0xe << CC1K_LOCK_SELECT,
    // CAL  0x0e
    1 << CC1K_CAL_WAIT | 6 << CC1K_CAL_ITERATE,	
    // MODEM2  0x0f
    1 << CC1K_PEAKDETECT | 33 << CC1K_PEAK_LEVEL_OFFSET,
    // MODEM1  0x10
    3 << CC1K_MLIMIT | 1 << CC1K_LOCK_AVG_MODE | CC1K_Settling << CC1K_SETTLING | 1 << CC1K_MODEM_RESET_N,    // MODEM0  0x11
    5 << CC1K_BAUDRATE | 1 << CC1K_DATA_FORMAT | 1 << CC1K_XOSC_FREQ,
    // MATCH  0x12
    0x7 << CC1K_RX_MATCH | 0x0 << CC1K_TX_MATCH,
    // tx current (extra)
    8 << CC1K_VCO_CURRENT | 1 << CC1K_PA_DRIVE,
  },
};

#define UQ_CC1000_RSSI "CC1000RssiP.Rssi"

#endif /* CC1000CONST_H */
