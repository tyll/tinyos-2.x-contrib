/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * 433MHz 2.4 kBaud Manchester 
 */
 
/**
 * All frequency settings assume a 26 MHz crystal.
 * If you have a 27 MHz crystal, you'll need to fix the defined FREQ registers
 * 
 * @author Jared Hill
 * @author David Moss
 * @author Roland Hendel
 */
 
#ifndef CC1100_H
#define CC1100_H

#include "Blaze.h"


/** SLOW THINGS DOWN FOR THIS DATA RATE */
#define BLAZE_ACK_WAIT 5000
#define TRANSMITTER_QUALITY_THRESHOLD 200
#define BLAZE_MIN_INITIAL_BACKOFF 2500
#define BLAZE_MIN_BACKOFF 200


#warning "*** INCLUDING CC1100 RADIO ***"

/** 
 * This helps calculate new FREQx register settings at runtime 
 * The frequency is in Hz
 */
#define CC1100_CRYSTAL_HZ 26000000

#define CC1100_433_MHZ 0

/**
 * You can change the matching network at compile time
 */
#ifndef CC1100_MATCHING_NETWORK
#warning "Using CC1100 default matching network at 433 MHz"
#define CC1100_MATCHING_NETWORK CC1100_433_MHZ
#endif


/**
 * All default channels and FREQx registers obtained from SmartRF studio. We
 * are not trying to define channel frequencies to match up with any sort of
 * specification; instead, we want flexibility.  If you want to align with 
 * specs, then go for it.
 *
 * Note you can setup the CC1100 to match your antenna characteristics.
 * Maybe your antenna is tuned to +/- 5 MHz with a center frequency of 315 MHz.
 * You want your center frequency to be 314.996 MHz, and your lower edge to be 
 * 310 MHz and your upper edge to be 320 MHz. 
 *
 *   Lower Channel Calculation:
 *      CC1100_CHANNEL_MIN = [(310000 desired kHz) - (CC1100_LOWEST_FREQ)]
 *                           ---------------------------------------------
 *                                     199 kHz channel spacing
 *
 *         Where CC1100_LOWEST_FREQ is defined for each band and 199 kHz is 
 *         approximately the channel spacing, CC1100_CHANNEL_WIDTH
 *
 *      CC1100_CHANNEL_MIN ~= 45
 *
 *  
 *   Upper Channel Calculation:
 *      CC1100_CHANNEL_MAX = [(320000 desired kHz) - (CC1100_LOWEST_FREQ)]
 *                           ---------------------------------------------
 *                                     199 kHz channel spacing
 * 
 *      CC1100_CHANNEL_MAX ~= 95
 * 
 * Incidentally, (95+45)/2 = 70, which is our default center channel.
 * 
 * When you apply the MAX and MIN values, the radio stack will automatically 
 * make sure you're within bounds when you set the frequency or channel during
 * runtime.
 *
 * We defined the minimum and maximum channels for the various bands below
 * so they generally stay within the limits of the CC1100 radio defined in the
 * datasheet.
 */
 
 
#if (CC1100_MATCHING_NETWORK == CC1100_433_MHZ)
/***************** 433 Matching Network ****************/

// Default channel is at 432.999817 MHz
#ifndef CC1100_DEFAULT_CHANNEL
#define CC1100_DEFAULT_CHANNEL 0
#endif

#ifndef CC1100_CHANNEL_MIN
#define CC1100_CHANNEL_MIN 0
#endif

#ifndef CC1100_CHANNEL_MAX
#define CC1100_CHANNEL_MAX 240
#endif

enum {  
  CC1100_LOWEST_FREQ = 300998,  // kHz
  CC1100_DEFAULT_FREQ2 = 0x10,
  CC1100_DEFAULT_FREQ1 = 0xA7,
  CC1100_DEFAULT_FREQ0 = 0x62,
}; 

/** 
 * These values calculated using TI smart RF studio
 */
enum{
  CC1100_PA_PLUS_10 = 0xC0,
  CC1100_PA_PLUS_7 = 0xC8,
  CC1100_PA_PLUS_5 = 0x84,
  CC1100_PA_PLUS_0 = 0x60,
  CC1100_PA_MINUS_5 = 0x57,
  CC1100_PA_MINUS_10 = 0x26,
};

#ifndef CC1100_PA
#define CC1100_PA CC1100_PA_PLUS_5
#endif

#endif

/**
 * These are used for calculating channels at runtime
 */
#define CC1100_CHANNEL_WIDTH 199 // kHz : Do not edit

enum CC1100_config_reg_state_enums {
  /** GDO2 is CHIP_RDY, even when the chip is first powered */
  CC1100_CONFIG_IOCFG2 = 0x29,
  
  /** GDO1 is High Impedance */
  CC1100_CONFIG_IOCFG1 = 0x2E,
  
  /** GDO0 asserts when there is data in the RX FIFO */
  CC1100_CONFIG_IOCFG0 = 0x01, 
  
  CC1100_CONFIG_FIFOTHR = 0x0F,
  CC1100_CONFIG_SYNC1 = 0xD3,
  CC1100_CONFIG_SYNC0 = 0x91,
  
  /** Maximum variable packet length is 61 per Errata */
  CC1100_CONFIG_PKTLEN = 0x3D,
  
  /** No hw address recognition for better ack rate, append 2 status bytes */
  CC1100_CONFIG_PKTCTRL1 = 0x24,
  
  /** CRC appending, variable length packets */
  CC1100_CONFIG_PKTCTRL0 = 0x45,
  
  CC1100_CONFIG_ADDR = 0x00,
  
  CC1100_CONFIG_CHANNR = CC1100_DEFAULT_CHANNEL,
  
  CC1100_CONFIG_FSCTRL1 = 0x06,
  CC1100_CONFIG_FSCTRL0 = 0x00,
  
  CC1100_CONFIG_FREQ2 = CC1100_DEFAULT_FREQ2,
  CC1100_CONFIG_FREQ1 = CC1100_DEFAULT_FREQ1,
  CC1100_CONFIG_FREQ0 = CC1100_DEFAULT_FREQ0,
  
  CC1100_CONFIG_MDMCFG4 = 0xF6,
  CC1100_CONFIG_MDMCFG3 = 0x83,
  CC1100_CONFIG_MDMCFG2 = 0x1B,  // 0x03 = no manchester
  CC1100_CONFIG_MDMCFG1 = 0x22,
  CC1100_CONFIG_MDMCFG0 = 0xF8,
  CC1100_CONFIG_DEVIATN = 0x15,
  CC1100_CONFIG_MCSM2 = 0x07,
  
  /** TX on CCA; Stay in Rx after Rx and Tx */
  CC1100_CONFIG_MCSM1 = 0x3F,
  
  /** I experimented with a cal every 4th time, but I never saw any, ever..? */
  CC1100_CONFIG_MCSM0 = 0x18,
  
  CC1100_CONFIG_FOCCFG = 0x16,
  CC1100_CONFIG_BSCFG = 0x6C,
  CC1100_CONFIG_AGCTRL2 = 0x03,   // If no Tx, lower LNA's (look at AGC)
  CC1100_CONFIG_AGCTRL1 = 0x40,   // CCA thresholds
  CC1100_CONFIG_AGCTRL0 = 0x91, 
  
  CC1100_CONFIG_WOREVT1 = 0x87,
  CC1100_CONFIG_WOREVT0 = 0x6B,
  CC1100_CONFIG_WORCTRL = 0xF8,
  CC1100_CONFIG_FREND1 = 0x56,
  CC1100_CONFIG_FREND0 = 0x10,
  CC1100_CONFIG_FSCAL3 = 0xE9,
  CC1100_CONFIG_FSCAL2 = 0x2A,
  CC1100_CONFIG_FSCAL1 = 0x00,
  CC1100_CONFIG_FSCAL0 = 0x1F,
  
  CC1100_CONFIG_RCCTRL1 = 0x41,
  CC1100_CONFIG_RCCTRL0 = 0x00,
  CC1100_CONFIG_FSTEST = 0x59,
  CC1100_CONFIG_PTEST = 0x7F,
  CC1100_CONFIG_AGCTST = 0x3F,
  CC1100_CONFIG_TEST2 = 0x81,
  CC1100_CONFIG_TEST1 = 0x35,
  CC1100_CONFIG_TEST0 = 0x09,
   
};


#ifndef CCXX00_RADIO_DEFINED
#define CCXX00_RADIO_DEFINED
#endif

#endif

