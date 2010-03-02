/* 
 * Copyright (c) 2005, Ecole Polytechnique Federale de Lausanne (EPFL)
 * and Shockfish SA, Switzerland.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Ecole Polytechnique Federale de Lausanne (EPFL) 
 *   and Shockfish SA, nor the names of its contributors may be used to 
 *   endorse or promote products derived from this software without 
 *   specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ========================================================================
 */
/*
 * XE1205 constants and helper macros and functions.
 *
 */

/**
 * @author Henri Dubois-Ferriere
 * @author Remy Blank
 *
 */


#ifndef _SX1211CONST_H
#define _SX1211CONST_H

#include "AM.h"

typedef nx_struct sx1211_header_t {
	nx_uint8_t len;
    nx_am_addr_t dest;
    nx_am_addr_t source;
    nx_am_id_t type;
    nx_am_group_t group;
    nx_uint8_t ack;
} sx1211_header_t;

typedef nx_struct sx1211_footer_t {
#ifdef LOW_POWER_LISTENING
    nx_uint16_t rxInterval;
#endif
    //    nxle_uint16_t crc;
} sx1211_footer_t;

typedef nx_struct sx1211_metadata_t {
    nx_uint16_t time;
    nx_uint8_t length;
    nx_uint8_t strength;
} sx1211_metadata_t;


/*
 * Register address generators.
 */
#define SX1211_WRITE(register_)    (((register_) << 1) & 0x3E)
#define SX1211_READ(register_)     ((((register_) << 1) & 0x7E) | 0x40)

/**
 * Register addresses.
 */
enum sx1211_register_enums {
  MCParam_0    = 0,
  MCParam_1    = 1,
  MCParam_2    = 2,
  MCParam_3    = 3,
  MCParam_4    = 4,
  IrqParam_5   = 5,
  IrqParam_6   = 6,
  TXParam_7    = 7,
  RXParam_8    = 8,
  RXParam_9    = 9,
  RXParam_10   = 10,
  RXParam_11   = 11,
  RXParam_12   = 12,
  Pattern_13   = 13,
  Pattern_14   = 14,
  Pattern_15   = 15,
  Pattern_16   = 16,
  OscParam_17  = 17,
  OscParam_18  = 18,
  TParam_19    = 19,
  TParam_21    = 21,
  TParam_22    = 22,
  SX1211_RegCount
};
enum sx1211_reg_addr {

    // Main Configuration Param
    REG_MCPARAM1                 = 0x00,
    REG_MCPARAM2                 = 0x01,
    REG_FDEV                     = 0x02,
    REG_BITRATE                  = 0x03,
    REG_OOKFLOORTHRESH           = 0x04,
    REG_MCPARAM6                 = 0x05,
    REG_R1                       = 0x06,
    REG_P1                       = 0x07,
    REG_S1                       = 0x08,
    REG_R2                       = 0x09,
    REG_P2                       = 0x0A,
    REG_S2                       = 0x0B,
    REG_PARAMP                   = 0x0C,

    // IRQ Param
    REG_IRQ0PARAM                = 0x0D,
    REG_IRQ1PARAM                = 0x0E,
    REG_RSSIIRQTHRESH            = 0x0F,

    // RX Param
    REG_RXPARAM1                 = 0x10,
    REG_RXPARAM2                 = 0x11,
    REG_RXPARAM3                 = 0x12,
    REG_RES19                    = 0x13,
    REG_RSSIVALUE                = 0x14,
    REG_RXPARAM6                 = 0x15,

    // Sync Param
    REG_SYNCBYTE1                = 0x16,
    REG_SYNCBYTE2                = 0x17,
    REG_SYNCBYTE3                = 0x18,
    REG_SYNCBYTE4                = 0x19,

    // TX Param
    REG_TXPARAM                  = 0x1A,
   
    // OSC Param
    REG_OSCPARAM                 = 0x1B,

    // Pckt Param
    REG_PKTPARAM1                = 0x1C,
    REG_NODEADRS                 = 0x1D,
    REG_PKTPARAM3                = 0x1E,
    REG_PKTPARAM4                = 0x1F,
    // SX1211_RegCount
};

// Chip operating mode
#define MC1_SLEEP                     0x00
#define MC1_STANDBY                   0x20
#define MC1_SYNTHESIZER               0x40
#define MC1_RECEIVER                  0x60
#define MC1_TRANSMITTER               0x80
// Frequency band
#define MC1_BAND_915L                 0x00
#define MC1_BAND_915H                 0x08
#define MC1_BAND_868                  0x10
#define MC1_BAND_950                  0x10

// VCO trimming
#define MC1_VCO_TRIM_00               0x00
#define MC1_VCO_TRIM_01               0x02
#define MC1_VCO_TRIM_10               0x04
#define MC1_VCO_TRIM_11               0x06

// RF frequency selection
#define MC1_RPS_SELECT_1              0x00
#define MC1_RPS_SELECT_2              0x01

// MC Param 2
// Modulation scheme selection
#define MC2_MODULATION_OOK            0x40
#define MC2_MODULATION_FSK            0x80

// Data operation mode
#define MC2_DATA_MODE_CONTINUOUS      0x00
#define MC2_DATA_MODE_BUFFERED        0x20
#define MC2_DATA_MODE_PACKET          0x04

// Rx OOK threshold mode selection
#define MC2_OOK_THRESH_TYPE_FIXED     0x00
#define MC2_OOK_THRESH_TYPE_PEAK      0x08
#define MC2_OOK_THRESH_TYPE_AVERAGE   0x10

// Gain on IF chain
#define MC2_GAIN_IF_00                0x00
#define MC2_GAIN_IF_01                0x01
#define MC2_GAIN_IF_10                0x02
#define MC2_GAIN_IF_11                0x03

// Frequency deviation (kHz)
/**
 * RF_FDEV >= RF_BITRATE
 **/
#define RF_FDEV_33                       0x0B
#define RF_FDEV_40                       0x09
#define RF_FDEV_50                       0x07
#define RF_FDEV_80                       0x04
#define RF_FDEV_100                      0x03
#define RF_FDEV_133                      0x02
#define RF_FDEV_200                      0x01

// Bitrate (bit/sec)  
#define RF_BITRATE_1600                  0x7C
#define RF_BITRATE_2000                  0x63
#define RF_BITRATE_2500                  0x4F
#define RF_BITRATE_5000                  0x27
#define RF_BITRATE_8000                  0x18
#define RF_BITRATE_10000                 0x13
#define RF_BITRATE_20000                 0x09
#define RF_BITRATE_25000                 0x07
#define RF_BITRATE_40000                 0x04
#define RF_BITRATE_50000                 0x03
#define RF_BITRATE_66700                 0x02
#define RF_BITRATE_100000                0x01
#define RF_BITRATE_200000                0x00

// MC Param 6
// FIFO size
#define MC6_FIFO_SIZE_16              0x00
#define MC6_FIFO_SIZE_32              0x40
#define MC6_FIFO_SIZE_48              0x80
#define MC6_FIFO_SIZE_64              0xC0

// FIFO threshold
#define RF_MC6_FIFO_THRESH_VALUE         0x0F


// SynthR1
#define RF_R1_VALUE                      0x77
// SynthP1
#define RF_P1_VALUE                      0x64
// SynthS1
#define RF_S1_VALUE                      0x32
// SynthR2
#define RF_R2_VALUE                      0x74
// SynthP2
#define RF_P2_VALUE                      0x62
// SynthS2
#define RF_S2_VALUE                      0x32

// PA ramp times in OOK
#define RF_PARAMP_00                     0x00
#define RF_PARAMP_01                     0x08
#define RF_PARAMP_10                     0x10
#define RF_PARAMP_11                     0x18


// IRQ Param 1
// Select RX&STDBY IRQ_0 sources (Packet mode)
#define RF_IRQ0_RX_STDBY_PAYLOADREADY    0x00
#define RF_IRQ0_RX_STDBY_WRITEBYTE       0x40
#define RF_IRQ0_RX_STDBY_FIFOEMPTY       0x80
#define RF_IRQ0_RX_STDBY_SYNCADRS        0xC0

// Select RX&STDBY IRQ_1 sources (Packet mode)
#define RF_IRQ1_RX_STDBY_CRCOK           0x00
#define RF_IRQ1_RX_STDBY_FIFOFULL        0x10
#define RF_IRQ1_RX_STDBY_RSSI            0x20
#define RF_IRQ1_RX_STDBY_FIFOTHRESH      0x30

// Select TX IRQ_1 sources (Packet mode)
#define RF_IRQ1_TX_FIFOFULL              0x00
#define RF_IRQ1_TX_TXDONE                0x08

// FIFO overrun/clear 
#define RF_IRQ1_FIFO_OVERRUN_CLEAR       0x01


// IRQ Param 2
// Select TX start condition and IRQ_0 source (Packet mode)
#define RF_IRQ0_TX_FIFOTHRESH_START_FIFOTHRESH     0x00
#define RF_IRQ0_TX_FIFOEMPTY_START_FIFONOTEMPTY    0x10

// RSSI IRQ flag
#define RF_IRQ2_RSSI_IRQ_CLEAR           0x04

// PLL_Locked flag
#define RF_IRQ2_PLL_LOCK_CLEAR           0x02

// PLL_Locked pin
#define RF_IRQ2_PLL_LOCK_PIN_OFF         0x00
#define RF_IRQ2_PLL_LOCK_PIN_ON          0x01

// RSSI threshold for interrupt
#define RF_RSSIIRQTHRESH_VALUE           0x00


// RX Param 1
// Passive filter (kHz)
/*
 * RX1_PASSIVEFILT ~= 3(RF_FDEV + RF_BITRATE/2)
 */
#define RX1_PASSIVEFILT_65            0x00
#define RX1_PASSIVEFILT_82            0x10
#define RX1_PASSIVEFILT_109           0x20
#define RX1_PASSIVEFILT_137           0x30
#define RX1_PASSIVEFILT_157           0x40
#define RX1_PASSIVEFILT_184           0x50
#define RX1_PASSIVEFILT_211           0x60
#define RX1_PASSIVEFILT_234           0x70
#define RX1_PASSIVEFILT_262           0x80
#define RX1_PASSIVEFILT_321           0x90
#define RX1_PASSIVEFILT_378           0xA0
#define RX1_PASSIVEFILT_414           0xB0
#define RX1_PASSIVEFILT_458           0xC0
#define RX1_PASSIVEFILT_514           0xD0
#define RX1_PASSIVEFILT_676           0xE0
#define RX1_PASSIVEFILT_987           0xF0



// Butterworth filter (kHz)
/*
 * 3*RX1_FC_FOPLUS <= RX1_PASSIVEFILT <= 4*RX1_FC_FOPLUS
 */
#define RX1_FC_VALUE                  0x03
// !!! Values defined below only apply if RFCLKREF = DEFAULT VALUE = 0x07 !!!
#define RX1_FC_FOPLUS25               0x00
#define RX1_FC_FOPLUS50               0x01
#define RX1_FC_FOPLUS75               0x02
#define RX1_FC_FOPLUS100              0x03
#define RX1_FC_FOPLUS125              0x04
#define RX1_FC_FOPLUS150              0x05
#define RX1_FC_FOPLUS175              0x06
#define RX1_FC_FOPLUS200              0x07
#define RX1_FC_FOPLUS225              0x08
#define RX1_FC_FOPLUS250              0x09
#define RX1_FC_FOPLUS275              0x0A
#define RX1_FC_FOPLUS300              0x0B
#define RX1_FC_FOPLUS325              0x0C
#define RX1_FC_FOPLUS350              0x0D
#define RX1_FC_FOPLUS375              0x0E
#define RX1_FC_FOPLUS400              0x0F




// RX Param 2
// Polyphase filter center value (kHz)
/*
 * RX2_FO >=RX1_PASSIVEFILT/2
 */

#define RX2_FO_VALUE                  0x03
// !!! Values defined below only apply if RFCLKREF = DEFAULT VALUE = 0x07 !!!
#define RX2_FO_50                     0x10
#define RX2_FO_75                     0x20
#define RX2_FO_100                    0x30
#define RX2_FO_125                    0x40
#define RX2_FO_150                    0x50
#define RX2_FO_175                    0x60
#define RX2_FO_200                    0x70
#define RX2_FO_225                    0x80
#define RX2_FO_250                    0x90
#define RX2_FO_275                    0xA0
#define RX2_FO_300                    0xB0
#define RX2_FO_325                    0xC0
#define RX2_FO_350                    0xD0
#define RX2_FO_375                    0xE0
#define RX2_FO_400                    0xF0


// Rx Param 3
// Polyphase filter enable
#define RX3_POLYPFILT_ON              0x80
#define RX3_POLYPFILT_OFF             0x00

// Bit synchronizer
// Automatically activated in Packet mode

#define RX3_SYNC_RECOG_ON             0x20
#define RX3_SYNC_RECOG_OFF            0x00

// Sync word recognition
// Automatically activated in Packet mode
// Size of the reference sync word
#define RX3_SYNC_SIZE_8               0x00
#define RX3_SYNC_SIZE_16              0x08
#define RX3_SYNC_SIZE_24              0x10
#define RX3_SYNC_SIZE_32              0x18

// Number of tolerated errors for the sync word recognition
#define RX3_SYNC_TOL_0                0x00
#define RX3_SYNC_TOL_1                0x02
#define RX3_SYNC_TOL_2                0x04
#define RX3_SYNC_TOL_3                0x06


// TX Param 
// Interpolator filter Tx (kHz)
#define TX_FC_VALUE                   0x70
// !!! Values defined below only apply if RFCLKREF = DEFAULT VALUE = 0x07 !!!
#define TX_FC_25                      0x00
#define TX_FC_50                      0x10
#define TX_FC_75                      0x20
#define TX_FC_100                     0x30
#define TX_FC_125                     0x40
#define TX_FC_150                     0x50
#define TX_FC_175                     0x60
#define TX_FC_200                     0x70
#define TX_FC_225                     0x80
#define TX_FC_250                     0x90
#define TX_FC_275                     0xA0
#define TX_FC_300                     0xB0
#define TX_FC_325                     0xC0
#define TX_FC_350                     0xD0
#define TX_FC_375                     0xE0
#define TX_FC_400                     0xF0

#define TX_POWER_13DB                 0x00
#define TX_POWER_10DB                 0x01
#define TX_POWER_7DB                  0x02
#define TX_POWER_4DB                  0x03
#define TX_POWER_1DB                  0x04
#define TX_POWER_MIN2DB               0x05
#define TX_POWER_MIN5DB               0x06
#define TX_POWER_MIN8DB               0x07




// PKT Param 1
// Manchester enable
#define PKT1_MANCHESTER_ON            0x80
#define PKT1_MANCHESTER_OFF           0x00

// Payload length
#define PKT1_LENGTH_VALUE             0x00


// Node Address
#define NODEADRS_VALUE                0x00


// PKT Param 3
//Packet format
#define PKT3_FORMAT_FIXED             0x00
#define PKT3_FORMAT_VARIABLE          0x80

// Preamble size
#define PKT3_PREAMBLE_SIZE_8          0x00
#define PKT3_PREAMBLE_SIZE_16         0x20
#define PKT3_PREAMBLE_SIZE_24         0x40
#define PKT3_PREAMBLE_SIZE_32         0x60

// Whitening enable
#define PKT3_WHITENING_ON             0x10
#define PKT3_WHITENING_OFF            0x00

// CRC enable
#define PKT3_CRC_ON                   0x08
#define PKT3_CRC_OFF                  0x00

// Address filtering
#define PKT3_ADRSFILT_00              0x00
#define PKT3_ADRSFILT_01              0x02
#define PKT3_ADRSFILT_10              0x04
#define PKT3_ADRSFILT_11              0x06

//CRC status (Read only)
#define PKT3_CRC_STATUS               0x01


// PKT Param 4
// FIFO autoclear if CRC failed for current packet
#define PKT4_AUTOCLEAR_ON             0x00
#define PKT4_AUTOCLEAR_OFF            0x80

// Select FIFO access in standby mode (read or write)
#define PKT4_FIFO_STANDBY_WRITE       0x00
#define PKT4_FIFO_STANDBY_READ        0x40 

#define TS_OS          160 // Quartz Osc wake up time, typ 1.5 ms, max 5 ms
#define TS_FS          26 // Freq Synth wake-up time from OS, max 800 us
#define TS_RE          16 // Receiver wake-up time from FS, max 500 us
#define TS_TR          16 // Transmitter wake-up time from FS, max 500 us

#ifndef TOSH_DATA_LENGTH
#define TOSH_DATA_LENGTH 28
#endif

enum {
  sx1211_mtu=TOSH_DATA_LENGTH + sizeof(sx1211_header_t) + sizeof(sx1211_footer_t),
  sx1211_ack_timeout=8000,
};

typedef enum {
    data_pattern = 0x893456,
    ack_pattern = 0x123fed,
    buf_pattern = 0xAAAAAA,
} pattern_t;


typedef enum {
  rx_irq0_none=0,
  rx_irq0_write_byte=1,
  rx_irq0_nFifoEmpty=2,
  rx_irq0_Pattern=3,   
}  sx1211_rx_irq0_src_t;

typedef enum sx1211_rx_irq1_src_t {
  rx_irq1_none=0,
  rx_irq1_FifoFull=1,
  rx_irq1_Rssi=2
} sx1211_rx_irq1_src_t;

// In TX, IRQ0 is always mapped to nFifoEmpty 
typedef enum {
  tx_irq1_FifoFull=0,
  tx_irq1_TxStopped=1
} sx1211_tx_irq1_src_t;


typedef enum {
    sx1211_channelpreset_868mhz=0,
    sx1211_channelpreset_869mhz=1,
    sx1211_channelpreset_870mhz=2,
    sx1211_channelpreset_433mhz=3,
    sx1211_channelpreset_434mhz=4,
    sx1211_channelpreset_435mhz=5,
}  sx1211_channelpreset_t;

typedef enum {
    sx1211_bitrate_152340=152340U,
    sx1211_bitrate_76170=76170U,
    sx1211_bitrate_50780=50780U,
    sx1211_bitrate_38085=38085U,
    //   xe1205_bitrate_30468=30468,
    //   xe1205_bitrate_19042=19042,
    //   xe1205_bitrate_12695=12695,
    //   xe1205_bitrate_8017=8017,
    //   xe1205_bitrate_4760=4760
} sx1211_bitrate_t;

typedef enum {
    reg1 = 0,
    reg2 = 1,
} sx1211_regFreq_t;

typedef enum {
    freq_867_075 = 0,
    freq_867_225 = 1,
    freq_867_375 = 2,
    freq_867_524 = 3,
    freq_867_674 = 4,
    freq_867_825 = 5,
    freq_867_975 = 6,
    freq_868_126 = 7,
    freq_868_275 = 8,
    freq_868_424 = 9,
    freq_868_575 = 10,
    freq_868_725 = 11,
    freq_868_875 = 12,
    freq_869_025 = 13,
    freq_869_175 = 14,
    freq_869_324 = 15,
    freq_869_474 = 16, // 500mW ISM
    freq_869_625 = 17, // 500mW ISM
    freq_869_777 = 18,
    freq_869_924 = 19,
} sx1211_freq_t;

uint8_t const rpsPllTable[] = {
    102,   81,  52, //867.075728
    124,   99,  28, //867.225600
    127,  101,  60, //867.375000
    142,  113,  65, //867.524476
    144,  115,  37, //867.674483
    127,  101,  64, //867.825000
    162,  130,   0, //867.975460
    163,  130,  62, //868.126829
    127,  101,  68, //868.275000
    165,  132,  36, //868.424096
    106,   85,   4, //868.575701
    //  167,  134, 22,
    127,  101,  72, //868.725000
    126,  101,  13, //868.875591
    148,  118,  67, //869.025503
    127,  102,   1, //869.175000
    118,  94,   59, //869.324370
    120,  96,   31, //869.474380
    127, 102,    5, //869.625000
    166, 133,   37, //869.777246
    157, 126,   20, //869.924051
};
#endif /* _SX1211CONST_H */
