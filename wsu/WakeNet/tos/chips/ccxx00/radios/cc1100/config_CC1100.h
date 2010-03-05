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
 * 250 kBaud Manchester
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
enum {
  CC1100_RADIO_ID = unique( UQ_BLAZE_RADIO ),
};
#warning "*** INCLUDING CC1100 RADIO ***"

/** 
 * This helps calculate new FREQx register settings at runtime 
 * The frequency is in Hz
 */
#define CC1100_CRYSTAL_HZ 26000000

#define CC1100_315_MHZ 0
#define CC1100_433_MHZ 1
#define CC1100_868_MHZ 2
#define CC1100_915_MHZ 3


/**** debraj start ****/

#define CC1100_250_KBaud_Man 0
#define CC1100_150_KBaud_Man 1

/**** debraj end ****/




/**
 * You can change the matching network at compile time
 */
#ifndef CC1100_MATCHING_NETWORK
#warning "Using CC1100 default matching network at 915 MHz"
#define CC1100_MATCHING_NETWORK CC1100_915_MHZ
#endif

/***** debrat start ****/

#ifndef CC1100_DATA_RATE
#warning "Using CC1100 - default 250 kBaud Manchester"
#define CC1100_DATA_RATE CC1100_250_KBaud_Man
#endif

/**** debraj end ****/


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
 
 
#if (CC1100_MATCHING_NETWORK == CC1100_315_MHZ)
/***************** 315 Matching Network ****************/

// Default channel is at 314.996490 MHz
#ifndef CC1100_DEFAULT_CHANNEL
#define CC1100_DEFAULT_CHANNEL 70
#endif

#ifndef CC1100_CHANNEL_MIN
#define CC1100_CHANNEL_MIN 0
#endif

#ifndef CC1100_CHANNEL_MAX
#define CC1100_CHANNEL_MAX 240
#endif

enum {  
  CC1100_LOWEST_FREQ = 300998,  // kHz
  CC1100_DEFAULT_FREQ2 = 0x0B,
  CC1100_DEFAULT_FREQ1 = 0x93,
  CC1100_DEFAULT_FREQ0 = 0xB1,
}; 

/** 
 * These values calculated using TI smart RF studio
 */
enum{
  CC1100_PA_PLUS_10 = 0xC0,
  CC1100_PA_PLUS_5 = 0x85,
  CC1100_PA_PLUS_0 = 0x60,
  CC1100_PA_MINUS_5 = 0x57,
  CC1100_PA_MINUS_10 = 0x26,
};

#ifndef CC1100_PA
#define CC1100_PA CC1100_PA_PLUS_10
#endif


#elif (CC1100_MATCHING_NETWORK == CC1100_433_MHZ)
/***************** 433 MHz Matching Network ****************/

// Default channel is at 433.191833 MHz
#ifndef CC1100_DEFAULT_CHANNEL
#define CC1100_DEFAULT_CHANNEL 161
#endif

#ifndef CC1100_CHANNEL_MIN
#define CC1100_CHANNEL_MIN 0
#endif

#ifndef CC1100_CHANNEL_MAX
#define CC1100_CHANNEL_MAX 255
#endif

enum {  
  CC1100_LOWEST_FREQ = 400998, 
  CC1100_DEFAULT_FREQ2 = 0x0F,
  CC1100_DEFAULT_FREQ1 = 0x6C,
  CC1100_DEFAULT_FREQ0 = 0x4E,
};  

/** 
 * These values calculated using TI smart RF studio
 */
enum{
  CC1100_PA_PLUS_10 = 0xC0,
  CC1100_PA_PLUS_5 = 0x85,
  CC1100_PA_PLUS_0 = 0x60,
  CC1100_PA_MINUS_5 = 0x57,
  CC1100_PA_MINUS_10 = 0x26,	
};

#ifndef CC1100_PA
#define CC1100_PA CC1100_PA_PLUS_10
#endif


#elif (CC1100_MATCHING_NETWORK == CC1100_868_MHZ)
/***************** 868 MHz Matching Network ****************/

// Default channel is at 868.192749 MHz
#ifndef CC1100_DEFAULT_CHANNEL
#define CC1100_DEFAULT_CHANNEL 141
#endif

#ifndef CC1100_CHANNEL_MIN
#define CC1100_CHANNEL_MIN 0
#endif

#ifndef CC1100_CHANNEL_MAX
#define CC1100_CHANNEL_MAX 255
#endif

enum {
  CC1100_LOWEST_FREQ = 839998, 
  CC1100_DEFAULT_FREQ2 = 0x20,
  CC1100_DEFAULT_FREQ1 = 0x4E,
  CC1100_DEFAULT_FREQ0 = 0xC4,
};  

/** 
 * These values calculated using TI smart RF studio
 */
enum{
  CC1100_PA_PLUS_10 = 0xC3,
  CC1100_PA_PLUS_5 = 0x85,
  CC1100_PA_PLUS_0 = 0x8E,
  CC1100_PA_MINUS_5 = 0x57,
  CC1100_PA_MINUS_10 = 0x34,	
};

#ifndef CC1100_PA
#define CC1100_PA CC1100_PA_PLUS_10
#endif


#else
/***************** 915 MHz Matching Network ****************/

// Default channel is at 914.996796 MHz
#ifndef CC1100_DEFAULT_CHANNEL
#define CC1100_DEFAULT_CHANNEL 35
#endif

#ifndef CC1100_CHANNEL_MIN
#define CC1100_CHANNEL_MIN 0
#endif

#ifndef CC1100_CHANNEL_MAX
#define CC1100_CHANNEL_MAX 135
#endif

enum {
  CC1100_LOWEST_FREQ = 901998, 
  CC1100_DEFAULT_FREQ2 = 0x22,
  CC1100_DEFAULT_FREQ1 = 0xB1,
  CC1100_DEFAULT_FREQ0 = 0x3B,
};  

/** 
 * These values calculated using TI smart RF studio
 */
enum{
  CC1100_PA_PLUS_10 = 0xC0,
  CC1100_PA_PLUS_5 = 0x85,
  CC1100_PA_PLUS_0 = 0x8E,
  CC1100_PA_MINUS_5 = 0x57,
  CC1100_PA_MINUS_10 = 0x26,	
};

#ifndef CC1100_PA
#define CC1100_PA CC1100_PA_MINUS_10
#endif


#endif


/**
 * These are used for calculating channels at runtime
 */
#define CC1100_CHANNEL_WIDTH 199 // kHz : Do not edit


/*** debraj start ****/

#if (CC1100_DATA_RATE == CC1100_150_KBaud_Man)

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
  
  CC1100_CONFIG_FSCTRL1 = 0x0C,
  CC1100_CONFIG_FSCTRL0 = 0x00,
  
  CC1100_CONFIG_FREQ2 = CC1100_DEFAULT_FREQ2,
  CC1100_CONFIG_FREQ1 = CC1100_DEFAULT_FREQ1,
  CC1100_CONFIG_FREQ0 = CC1100_DEFAULT_FREQ0,
  
  CC1100_CONFIG_MDMCFG4 = 0x2D,
  CC1100_CONFIG_MDMCFG3 = 0x3B,
  CC1100_CONFIG_MDMCFG2 = 0x0B,  // 0x03 = no manchester
  CC1100_CONFIG_MDMCFG1 = 0x22,
  CC1100_CONFIG_MDMCFG0 = 0xF8,
  CC1100_CONFIG_DEVIATN = 0x62,
  CC1100_CONFIG_MCSM2 = 0x07,
  
  /** TX on CCA; Stay in Rx after Rx and Tx */
  CC1100_CONFIG_MCSM1 = 0x3F,
  
  /** I experimented with a cal every 4th time, but I never saw any, ever..? */
  CC1100_CONFIG_MCSM0 = 0x18,
  
  CC1100_CONFIG_FOCCFG = 0x1D,
  CC1100_CONFIG_BSCFG = 0x1C,
  CC1100_CONFIG_AGCTRL2 = 0xC7,   // If no Tx, lower LNA's (look at AGC)
  CC1100_CONFIG_AGCTRL1 = 0x00,   // CCA thresholds
  CC1100_CONFIG_AGCTRL0 = 0xB0, 
  
  CC1100_CONFIG_WOREVT1 = 0x87,
  CC1100_CONFIG_WOREVT0 = 0x6B,
  CC1100_CONFIG_WORCTRL = 0xF8,
  CC1100_CONFIG_FREND1 = 0xB6,
  CC1100_CONFIG_FREND0 = 0x10,
  CC1100_CONFIG_FSCAL3 = 0xEA,
  CC1100_CONFIG_FSCAL2 = 0x2A,
  CC1100_CONFIG_FSCAL1 = 0x00,
  CC1100_CONFIG_FSCAL0 = 0x1F,
  
  CC1100_CONFIG_RCCTRL1 = 0x41,
  CC1100_CONFIG_RCCTRL0 = 0x00,
  CC1100_CONFIG_FSTEST = 0x59,
  CC1100_CONFIG_PTEST = 0x7F,
  CC1100_CONFIG_AGCTST = 0x3F,
  CC1100_CONFIG_TEST2 = 0x88,
  CC1100_CONFIG_TEST1 = 0x31,
  CC1100_CONFIG_TEST0 = 0x0B,
   
};

#else

enum CC1100_config_reg_state_enums {

    /* Registers preserve programming values in SLEEP */
    CC1100_CONFIG_IOCFG2    = 0x29,     // 0x00, GDO2 Output Pin Config
                                        //     7, RO,  not used
                                        //     6, R/W, GDO2_INV, Invert output. Default active high = 0x0.
                                        //   5:0, R/W, GDO2_CFG, Default CHP_RDYn = 0x29.

    CC1100_CONFIG_IOCFG1    = 0x2E,     // 0x01, GDO1 Output Pin Config
                                        //     7, R/W, GDO_DS, Output drive strength on GD0 pins. Default low = 0x0.
                                        //     6, R/W, GDO1_INV, Invert output. Default active high = 0x0.
                                        //   5:0, R/W, GDO2_CFG, Default Tri-state = 0x2E.

    CC1100_CONFIG_IOCFG0    = 0x01,     // 0x02, GDO0 Output Pin Config
                                        //     7, R/W, TEMP_SENSOR_ENABLE, Enable analog temp sensor. Default disable = 0x0. write 0 in all other bits if enabled
                                        //     6, R/W, GDO0_INV, Invert output. default active high = 0x0.
                                        //   5:0, R/W, GDO0_CFG, Default CLK_XOSC/192 = 0x3F.
                                        //                          0x01 = Associated to RX_FIFO

    CC1100_CONFIG_FIFOTHR   = 0x0F,     // 0x03, RX FIFO and TX FIFO Thresholds
                                        //     7, RO,  reserved, write 0 for future compatability
                                        //     6, R/W, ADC_RETENTION, Waking from SLEEP default = 0x0, TEST1 = 0x31 and TEST2 = 0x88. 
                                        //                          Set = 0x1, TEST1 = 0x35 and TEST2 = 0x81. 
                                        //   5:4, R/W, CLOSE_IN_RX, RX Attenuation, Default 0dB = 0x0.
                                        //   3:0, R/W, FIFO_THR, FIFO threshold in bytes. Default = 0x7, TX = 33 and RX = 32.
                                        //                          Set = 0xF, TX = 1 and RX = 64.

    CC1100_CONFIG_SYNC1     = 0xD3,		// 0x04, Sync Word, High Byte
                                        //   7:0, R/W, SYNC_H, 8 MSB of 16 bit sync word. Default 0xD3

    CC1100_CONFIG_SYNC0     = 0x91,		// 0x05, Sync Word, Low Byte
	                                    //   7:0, R/W, SYNC_L, 8 LSB of 16 bit sync word. Default 0x91

    CC1100_CONFIG_PKTLEN    = 0x3D,     // 0x06, Packet Length
                                        //   7:0, R/W, PACKET_LENGTH, Maximum variable packet length is 61 per Errata

    CC1100_CONFIG_PKTCTRL1  = 0x24,     // 0x07, Packet Automation Control
                                        //   7:5, R/W, PQT, Preamble quality estimator threshold, Default = 0x0
										//     4, RO,  not used
                                        //     3, R/W, CRC_AUTOFLUSH, Enable automatic flush of RX FIFO when CRC is not OK. Default disable = 0x0
                                        //     2, R/W, APPEND_STATUS, Default enabled = 0x1, CRC OK + LQI byte and RSSI byte appended to payload.
                                        //   1:0, R/W, ADR_CHK, Received packets address check config. Default No address check = 0x0.

    CC1100_CONFIG_PKTCTRL0  = 0x45,     // 0x08, Packet Automation Control
                                        //     7, RO,  not used
										//     6, R/W, WHITE_BIT, Turn data whitening on/off. Default on = 0x1.
                                        //   5:4, R/W, PKT_FORMAT, Format of RX/TX data, Default normal = 0x0.
                                        //     2, R/W, CRC_EN, CRC check. Default on = 0x1
                                        //   1:0, R/W, LENGTH_CONFIG, Config packet length, Default variable packet length mode = 0x1. 

    CC1100_CONFIG_ADDR      = 0x00,		// 0x09, Device Address
                                        //   7:0, R/W, DEVICE_ADDR, Address used for packet filtration. Default 0x00

    CC1100_CONFIG_CHANNR    = CC1100_DEFAULT_CHANNEL,	// 0x0A, Channel Number
                                        //   7:0, R/W, CHAN, 8bit usigned channel number. Default = 0x00

    CC1100_CONFIG_FSCTRL1   = 0x0E,     // 0x0B, Frequency Synthesizer Control
                                        //   7:6, RO,  not used
                                        //     5, R/W, reserved, write 0 for future compatability.
                                        //   4:0, R/W, FREQ_IF, Desired IF Frequency to employ in RX. Default = 0x0F

    CC1100_CONFIG_FSCTRL0   = 0x00,     // 0x0C, Frequency Synthesizer Control
                                        //   7:0, R/W, FREQOFF, Offset added to base Frequency for synthesizer. Default = 0x00
                                        
    CC1100_CONFIG_FREQ2     = 0x0F,     // 0x0D, Frequency Control Word, High
                                        //   7:6, RO,  FREQ, not used
                                        //   5:0, R/W, FREQ_H, Base frequency for synthesizer. Default = 0x1E

    CC1100_CONFIG_FREQ1     = 0x6C,     // 0x0E, Frequency Control Word, Middle
                                        //   7:0, R/W, FREQ_M, Ref FREQ2 register. Default = 0xC4

    CC1100_CONFIG_FREQ0     = 0x4E,     // 0x0F, Frequency Control Word, Low
                                        //   7:0, R/W, FREQ_L, Ref FREQ2 register. Default 0xEC

    CC1100_CONFIG_MDMCFG4   = 0x0C,     // 0x10, Modem Config
                                        //   7:6, R/W. CHANBW_E, channel bandwidth decimation ratio exponent. Default = 0x2
                                        //   5:4, R/W, CHANBW_M, channel bandwidth decimation ratio mantissa. Default = 0x0
                                        //   3:0, R/W, DRATE_E, User specified symbol rate exponent. Default = 0xC

    CC1100_CONFIG_MDMCFG3   = 0x3B,     // 0x11, Modem Config
                                        //   7:0, R/W. DRATE_M, User specified symbol rate mantissa. Default enable = 0x22

    CC1100_CONFIG_MDMCFG2   = 0x73,     // 0x12, Modem Config
                                        //     7, R/W. DEM_DCFILT_OFF, Disable digital DC blocking filter. Default enable = 0x0
                                        //   6:4, R/W, MOD_FORMAT, Modulation format. Default 2-FSK = 0x0
                                        //                          0x7 = MSK
                                        //     3, R/W, MANCHESTER_EN, . Enable Manchester. Default disable = 0x0
                                        //   2:0, R/W, SYNC_MODE, Combined sync-word qualifier mode. Default 16bit TX/RX sync word = 0x2
                                        //                          0x3 = repeated sync word TX, 30 of 32bit sync word bits detected RX

    CC1100_CONFIG_MDMCFG1   = 0x42,     // 0x13, Modem Config
                                        //     7, R/W. FEC_EN, Enable forward error correction. Default disabled = 0x0
                                        //   6:4, R/W, NUM_PREAMBLE, Minimum number of preable bytes. Default 4 preamble bytes = 0x2
                                        //                          0x4 = 8 preamble bytes
                                        //   3:2, RO,  not used
                                        //   1:0, R/W, CHANSPC_E, Channel spacing exponent. Default = 0x2

    CC1100_CONFIG_MDMCFG0   = 0xF8,     // 0x14, Modem Config
                                        //   7:0, R/W. CHANSPC_M, Channel spacing mantissa. Default = 0xF8

    CC1100_CONFIG_DEVIATN   = 0x00,     // 0x15, Modem Deviation Setting
                                        //     7, RO,  not used
                                        //   6:4, R/W, DEVIATION_E, Deviation exponent, Default = 0x4
                                        //     3, RO,  not used
                                        //   2:1, R/W, DEVIATION_M, Depends on modulation format. Default mantissa for 2-FSK = 0x7
                                        //                          For MSK specifies fraction of sample period when phase change occurs.

    CC1100_CONFIG_MCSM2     = 0x07,     // 0x16, Main Radio Control State Machine Config
                                        //   7:5, RO,  not used
                                        //     4, R/W, RX_TIME_RSSI, RX termination based on RSSI (carrier sense). Default off = 0x0
                                        //     3, R/W, RX_TIME_QUAL, When RX_TIME expires: Default checks if sync word found = 0x0. if = 0x1 checks sync word or PQI.
                                        //   2:0, R/W, RX_TIME, Timeout for sync word search in RX for both WOR mode and normal RX operation. Default = 0x7

    CC1100_CONFIG_MCSM1     = 0x3F,     // 0x17, Main Radio Control State Machine Config
                                        //   7:6, RO,  not used
                                        //   5:4, R/W, CCA_MODE, Selects CCA mode. Default channel indication if RSSI below threshold = 0x3.
                                        //   3:2, R/W, RXOFF_MODE, When packet RX'ed Default IDLE = 0x0.
                                        //                          0x3 = stay in RX.
                                        //   1:0, R/W, TXOFF_MODE, When packet TX'd Default IDLE = 0x0.
                                        //                          0x3 = RX

    CC1100_CONFIG_MCSM0     = 0x18,     // 0x18, Main Radio Control State Machine Config
                                        //   7:6, RO,  not used
                                        //   5:4, R/W, FS_AUTOCAL, Auto calibrate. Default never = 0x0.
                                        //                          0x1 = when going from IDLE to RX or TX.
                                        //   3:2, R/W, PO_TIMEOUT, Number of times 6bit ripple counter expires after stable XOSC, before CHP_RDYn goes low. Default 16 = 0x1
                                        //     1, R/W, PIN_CTRL_EN, Enables pin radio control option. Default disable = 0x0
                                        //     0, R/W, XOSC_FPRCE_ON, Force the XOSC to stay on in SLEEP state. Default off = 0x0

    CC1100_CONFIG_FOCCFG    = 0x1D,     // 0x19, Frequency Offset Compensation Config
                                        //   7:6, RO,  not used
                                        //     5, R/W, FOC_BS_CS_GATE, Default set = 0x1, demodulator freezes FOC and clock feedback until CS goes high.
                                        //   4:3, R/W, FOC_PRE_K, Freq comp loog gain used before sync word detected. Default 0x2 = 3K
                                        //                          0x3 = 4K.
                                        //     2, R/W, FOC_POST_K, Freq comp loop gain used after sync word detected. Default 0x1 = K/2 
                                        //   1:0, R/W, FOC_LIMIT, Saturation point for FOC algorithm. Default 0x2 = BW_CHAN/4
                                        //                          0x1 = BW_CHAN/8

    CC1100_CONFIG_BSCFG     = 0x1C,     // 0x1A, Bit Sync Config
                                        //   7:6, R/W, BS_PRE_KI, Clock recovery feedback loop integral gain before sync word. Default 2Ki = 0x1.
                                        //                          0x0 = Ki
                                        //   5:4, R/W, BS_PRE_KP, Clock recovery feedback loop proportional gain before syn word. Default 3Kp = 0x2.
                                        //     3, R/W, BS_POST_KI, Clock recovery feedback loop integral gain after sync word. Default Ki/2 = 0x1
                                        //     2, R/W, BS_POST_KP, Clock recovery feedback loop proportional gain after sync word. Default Kp = 0x1
                                        //   1:0, R/W, BS_LIMIT, Saturation point for the data rate offset compensation algorithm. Default none = 0x0

    CC1100_CONFIG_AGCTRL2   = 0xC7,     // 0x1B, AGC Control
                                        //   7:6, R/W, MAX_DVGA_GAIN, Reduces max allowable DVGA gain. Default all gain can be used = 0x0
                                        //                          0x3 = 3 highest gain settings can not be used
                                        //   5:3, R/W, MAX_LNA_GAIN,  Set max allowable LNA+LNA2 gain. Default max = 0x0
                                        //   2:0, R/W, MAGN_TARGET, Set digital channel filter average amplitude target. Default 33 dB = 0x3
                                        //                          0x7 = 42 dB 

    CC1100_CONFIG_AGCTRL1   = 0x00,     // 0x1C, AGC Control
                                        //     7, RO,  not used
                                        //     6, R/W, AGC_LNA_PRIORITY, LNA gain adjustment. Default 0x1 = decrease LNA first.
                                        //                          0x0 = LNA 2 decreased to min then LNA decreased.
                                        //   5:4, R/W, CARRIER_SENSE_REL_THR, Set relative change threshold for asserting carrier sense. Default disabled = 0x0.
                                        //   3:0, R/W, CARRIER_SENSE_ABS_THR, Set absolute RSSI threshold for asserting carrier sense. Default disabled = 0x0.

    CC1100_CONFIG_AGCTRL0   = 0xB0,     // 0x1D, AGC Control
                                        //   7:6, R/W, HYST_LEVEL, Set magnitude deviation hysteresis level. Default medium = 0x2
                                        //   5:4, R/W, WAIT_TIME, Set number of channel filter samples before AGC starts new samples. Default 16 = 0x1
                                        //                          0x3 = 32
                                        //   3:2, R/W, AGC_FREEZE, Set when to freeze AGC gain. Default normal = 0x0.
                                        //   1:0, R/W, FILTER_LENGTH, Set channel filter amplitude average length. 
                                        //                            Default 0x1 set length = 16, boundary = 8 dB.
                                        //                          0x0 set length = 8, boundary = 4 dB

    CC1100_CONFIG_WOREVT1   = 0x87,     // 0x1E, High Byte Event0 Timeout
                                        //   7:0, R/W, EVENT0, High byte of EVENT0 timeout register. Default = 0x87

    CC1100_CONFIG_WOREVT0   = 0x6B,     // 0x1F, Low Byte Event0 Timeout
                                        //   7:0, R/W, EVENT0, Low byte of EVENT0 timeout register. Default = 0x6B

    CC1100_CONFIG_WORCTRL   = 0xF8,     // 0x20, Wake On Radio Control
                                        //     7, R/W, RC_PD, Power down signal to RC osc. When 0x0 auto cal will be performed. Default = 0x1
                                        //   6:4, R/W, EVENT1, Timeout setting from register block. Decoded to EVENT1 timeout. Default 48 = 0x7.
                                        //     3, R/W, RC_CAL, Default enables = 0x1 or disables RC osc calibration.
                                        //     2, RO,  not used.
                                        //   1:0, R/W, WOR_RES, Controls EVENT0 resolution, WOR max timeout and RX normal operation max timeout. 
                                        //                      Default 0x0 set resolution = 1 period, timeout = 1.8 - 1.9 sec.

    CC1100_CONFIG_FREND1    = 0xB6,     // 0x21, Front End RX Config
                                        //   7:6, R/W, LNA_CURRENT, Adjust front-end LNA PTAT current output. Default = 0x1
                                        //   5:4, R/W, LNA2MIX_CURRENT, Adjust front-end PTAT outputs. Default = 0x1
                                        //   3:2, R/W, LODIC_BUF_CURRENT_RX, Adjust current in RX LO buffer. Default = 0x1
                                        //   1:0, R/W, MIX_CURRENT, Adjusts current in mixer. Default = 0x2

    CC1100_CONFIG_FREND0    = 0x10,     // 0x22, Front End TX Config
                                        //   7:6, RO,  not used
                                        //   5:4, R/W, LODIV_BUF_CURRENT_TX, Adjsut current in TX LO buffer. Default = 0x1
                                        //   3:2, RO,  not used.
                                        //   1:0, R/W, Selects PA power setting. Default = 0x0

    CC1100_CONFIG_FSCAL3    = 0xEA,     // 0x23, Frequency Synthesizer Calibration
                                        //   7:6, R/W, FSCAL3, Frequency synthesizer calibration config. Default = 0x2
                                        //   5:4, R/W, CHP_CURR_CAL_EN, when 0x0 disable charge pump calibration stage. Default = 0x2
                                        //   3:0, R/W, FSCAL3, Frequency synthesizer calibration result register. Default = 0x9

    CC1100_CONFIG_FSCAL2    = 0x2A,     // 0x24, Frequency Synthesizer Calibration
                                        //   7:6, RO,  not used
                                        //     5, R/W, VCO_CORE_H_EN, Choose high/low VCO. Default low = 0x0
                                        //   4:0, R/W, FSCAL2, Frequency synthesizer calibration result register. Default = 0x0A

    CC1100_CONFIG_FSCAL1    = 0x00,     // 0x25, Frequency Synthesizer Calibration
                                        //     7, RO,  not used
                                        //   6:0, R/W, FSCAL1, Frequency synthesizer calibration result register. Default = 0x20

    CC1100_CONFIG_FSCAL0    = 0x1F,     // 0x26, Frequency Synthesizer Calibration
                                        //     7, RO,  not used
                                        //   6:0, R/W, FSCAL0, Frequency synthesizer calibration control. Default = 0x13

    CC1100_CONFIG_RCCTRL1   = 0x41,     // 0x27, RC Oscillator Config
                                        //     7, RO,  not used
                                        //   6:0, R/W, RCCTRL1, RC osc config. Default = 0x41

    CC1100_CONFIG_RCCTRL0   = 0x00,     // 0x28, RC Oscillator Config
                                        //     7, RO,  not used
                                        //   6:0, R/W, RCCTRL0, RC osc config. Default = 0x00


    /* Registers loose programming values in SLEEP */
    CC1100_CONFIG_FSTEST    = 0x59,     // 0x29, Frequency Synthesizer Calibration Control
                                        //   7:0, R/W, FSTEST, For test only. DO NOT WRITE TO THIS REGISTER. Default 0x59

    CC1100_CONFIG_PTEST     = 0x7F,     // 0x2A, Production Test
                                        //   7:0, R/W, PTEST, For test mostly. Write 0xBF to make temperature sensor available in IDLE. 
                                        //                    Write 0x7F  back before leaving IDLE. Default 0x7F

    CC1100_CONFIG_AGCTST    = 0x3F,     // 0x2B, AGC Test
                                        //   7:0, R/W, AGCTEST, For test only. DO NOT WRITE TO THIS REGISTER. Default 0x3F

    CC1100_CONFIG_TEST2     = 0x88,     // 0x2D, Varoius Test Setting
                                        //   7:0, R/W, TEST2, Value to write in register determined by SmartRF. Default 0x88

    CC1100_CONFIG_TEST1     = 0x31,     // 0x2E, Varoius Test Setting
                                        //   7:0, R/W, TEST1, Value to write in register determined by SmartRF. Default 0x31

    CC1100_CONFIG_TEST0     = 0x0B      // 0x2F, Varoius Test Setting
                                        //   7:2, R/W, TEST0, Value to write in register determined by SmartRF. Default 0x02
                                        //     1, R/W, VCO_SEL_CAL_EN, Enable VCO selection calibration stage. Default enable = 0x1
                                        //     0, R/W, TEST0, Value to write in register determined by SmartRF. Default 0x1
};


#endif

/**** debraj end ****/
  
 

#ifndef CCXX00_RADIO_DEFINED
#define CCXX00_RADIO_DEFINED
#endif

#endif



