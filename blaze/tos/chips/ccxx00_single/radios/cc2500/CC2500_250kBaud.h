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
 * 250 kBaud (MSK)
 */
 
/**
 * All frequency settings assume a 26 MHz crystal.
 * If you have a 27 MHz crystal, you'll need to fix the defined FREQ registers
 * 
 * @author Jared Hill
 * @author David Moss
 * @author Roland Hendel
 */
 
#ifndef CC2500_H
#define CC2500_H

#include "Blaze.h"

#warning "*** INCLUDING CC2500 RADIO ***"

enum {
  CC2500_RADIO_ID = unique( UQ_BLAZE_RADIO ),
};

/** 
 * This helps calculate new FREQx register settings at runtime.
 * The frequency is in MHz.
 */
#define CC2500_CRYSTAL_MHZ 26

/**
 * All default channels and FREQx registers obtained from SmartRF studio. We
 * are not trying to define channel frequencies to match up with any sort of
 * specification; instead, we want flexibility.  If you want to align with 
 * specs, then go for it.
 *
 * Note you can setup the CC2500 to match your antenna characteristics.
 * Maybe your antenna is tuned to +/- 20 MHz around 2442.4 MHz
 * You want your center frequency to be 2442.4 MHz, and your lower edge to be 
 * 2422.4 MHz and your upper edge to be 2462.4 MHz. 
 *
 *   Lower Channel Calculation:
 *      CC2500_CHANNEL_MIN = [(2422400 desired kHz) - (CC2500_LOWEST_FREQ)]
 *                           ---------------------------------------------
 *                                     324 kHz channel spacing
 *
 *         Where CC2500_LOWEST_FREQ is 2400998 kHz and 324 kHz is 
 *         approximately the channel spacing, CC2500_CHANNEL_WIDTH
 *
 *      CC2500_CHANNEL_MIN ~= 66
 *
 *  
 *   Upper Channel Calculation:
 *      CC2500_CHANNEL_MAX = [(320000 desired kHz) - (CC2500_LOWEST_FREQ)]
 *                           ---------------------------------------------
 *                                     324 kHz channel spacing
 * 
 *      CC2500_CHANNEL_MAX ~= 189
 * 
 * Incidentally, (189+66)/2 ~= 128, which is our default center channel.
 * 
 * When you apply the MAX and MIN values, the radio stack will automatically 
 * make sure you're within bounds when you set the frequency or channel during
 * runtime.
 *
 * We defined the channel spacing below so all channels from 0 to 255 fit 
 * within the 2.400 - 2.483 GHz band.
 */
 
 
/***************** 2.4 GHz Matching Network ****************/
// Default channel is at 2441.565277 MHz
#ifndef CC2500_DEFAULT_CHANNEL
#define CC2500_DEFAULT_CHANNEL 125
#endif

#ifndef CC2500_CHANNEL_MIN
#define CC2500_CHANNEL_MIN 0
#endif

#ifndef CC2500_CHANNEL_MAX
#define CC2500_CHANNEL_MAX 255
#endif

enum {
  CC2500_LOWEST_FREQ = 2400998,  // kHz
  CC2500_DEFAULT_FREQ2 = 0x5C,
  CC2500_DEFAULT_FREQ1 = 0x58,
  CC2500_DEFAULT_FREQ0 = 0x9D,
};  

/** 
 * These values calculated using TI smart RF studio
 */
enum{
  CC2500_PA_PLUS_1 = 0xFF,
  CC2500_PA_MINUS_4 = 0xA9,
  CC2500_PA_MINUS_10 = 0x97,	
};

#ifndef CC2500_PA
#define CC2500_PA CC2500_PA_PLUS_1
#endif


/**
 * These are used for calculating channels at runtime
 */
#define CC2500_CHANNEL_WIDTH 324 // kHz : Do not edit

enum cc2500_config_reg_state_enums {
  /** GDO2 is CHIP_RDY, even when the chip is first powered */
  CC2500_CONFIG_IOCFG2 = 0x29,
  
  /** GDO1 is High Impedance */
  CC2500_CONFIG_IOCFG1 = 0x2E,
  
  /** GDO0 asserts when there is data in the RX FIFO */
  CC2500_CONFIG_IOCFG0 = 0x01, 
  
  CC2500_CONFIG_FIFOTHR = 0xE,
  CC2500_CONFIG_SYNC1 = 0xD3,
  CC2500_CONFIG_SYNC0 = 0x91,
  
  /** Maximum variable packet length is 61 per Errata */
  CC2500_CONFIG_PKTLEN = 0x3D,
  
  /** No hw address recognition for better ack rate, append 2 status bytes */
  CC2500_CONFIG_PKTCTRL1 = 0x24,
  
  /** CRC appending, variable length packets */
  CC2500_CONFIG_PKTCTRL0 = 0x45,
  
  CC2500_CONFIG_ADDR = 0x00,
  
  CC2500_CONFIG_CHANNR = CC2500_DEFAULT_CHANNEL,
  
  CC2500_CONFIG_FSCTRL1 = 0x10,
  CC2500_CONFIG_FSCTRL0 = 0x00,
  
  CC2500_CONFIG_FREQ2 = CC2500_DEFAULT_FREQ2,
  CC2500_CONFIG_FREQ1 = CC2500_DEFAULT_FREQ1,
  CC2500_CONFIG_FREQ0 = CC2500_DEFAULT_FREQ0,
  
  CC2500_CONFIG_MDMCFG4 = 0x2D,
  CC2500_CONFIG_MDMCFG3 = 0x3B,
  CC2500_CONFIG_MDMCFG2 = 0x7B,
  CC2500_CONFIG_MDMCFG1 = 0x22,
  CC2500_CONFIG_MDMCFG0 = 0xF8,
  CC2500_CONFIG_DEVIATN = 0x01,
  CC2500_CONFIG_MCSM2 = 0x07,
  
  /** TX on CCA; Stay in Rx after Rx and Tx */
  CC2500_CONFIG_MCSM1 = 0x3F,
  CC2500_CONFIG_MCSM0 = 0x18,
  CC2500_CONFIG_FOCCFG = 0x1D,
  CC2500_CONFIG_BSCFG = 0x1C,
  CC2500_CONFIG_AGCTRL2 = 0xC7, // LNA's
  CC2500_CONFIG_AGCTRL1 = 0x00, // CCA threshold definition
  CC2500_CONFIG_AGCTRL0 = 0xB0, 
  
  CC2500_CONFIG_WOREVT1 = 0x87,
  CC2500_CONFIG_WOREVT0 = 0x6B,
  CC2500_CONFIG_WORCTRL = 0xF8,
  CC2500_CONFIG_FREND1 = 0xB6,
  CC2500_CONFIG_FREND0 = 0x10,
  CC2500_CONFIG_FSCAL3 = 0xEA,
  CC2500_CONFIG_FSCAL2 = 0x0A,
  CC2500_CONFIG_FSCAL1 = 0x00,
  CC2500_CONFIG_FSCAL0 = 0x11,
  
  CC2500_CONFIG_RCCTRL1 = 0x41,
  CC2500_CONFIG_RCCTRL0 = 0x00,
  CC2500_CONFIG_FSTEST = 0x59,
  CC2500_CONFIG_PTEST = 0x7F,
  CC2500_CONFIG_AGCTST = 0x3F,
  CC2500_CONFIG_TEST2 = 0x88,
  CC2500_CONFIG_TEST1 = 0x31,
  CC2500_CONFIG_TEST0 = 0x0B,
   
  
};


#ifndef CCXX00_RADIO_DEFINED
#define CCXX00_RADIO_DEFINED
#endif

#endif



