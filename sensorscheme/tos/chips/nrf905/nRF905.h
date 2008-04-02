/* 
 * Copyright (c) 2008, University of Twente (UTWENTE), the Netherlands.
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
 * - Neither the name of the University of Twente (UTWENTE)
 *   nor the names of its contributors may be used to 
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
 * nRF905 constants and helper macros and functions.
 *
 */

/**
 * @author Leon Evers
 *
 */


#ifndef _nRF905CONST_H
#define _nRF905CONST_H

#include "AM.h"

typedef nx_struct nrf905_header_t {
  nx_am_addr_t dest;
  nx_am_addr_t source;
  nx_am_id_t type;
  nx_am_group_t group;
  nx_uint8_t ack;
} nrf905_header_t;

typedef nx_struct nrf905_footer_t {
#ifdef LOW_POWER_LISTENING
    nx_uint16_t rxInterval;
#endif
  nxle_uint16_t crc;
} nrf905_footer_t;

typedef nx_struct nrf905_metadata_t {
  nx_uint8_t length;
  nx_uint8_t strength;
} nrf905_metadata_t;


/*
 * Register address generators.
 */
#define nRF905_WRITE(register_)                 (((register_) << 1) | 0x01)
#define nRF905_READ(register_)                  (((register_) << 1) | 0x41)

/**
 * Register addresses.
 */
enum nrf905_register_enums {
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
  nRF905_RegCount
};

#ifndef TOSH_DATA_LENGTH
#define TOSH_DATA_LENGTH 28
#endif

enum {
  nrf905_mtu=TOSH_DATA_LENGTH + sizeof(nrf905_header_t) + sizeof(nrf905_footer_t)
};

enum {
    data_pattern = 0x893456,
    ack_pattern = 0x123fed
};


typedef enum {
  rx_irq0_none=0,
  rx_irq0_write_byte=1,
  rx_irq0_nFifoEmpty=2,
  rx_irq0_Pattern=3,   
}  nrf905_rx_irq0_src_t;

typedef enum nrf905_rx_irq1_src_t {
  rx_irq1_none=0,
  rx_irq1_FifoFull=1,
  rx_irq1_Rssi=2
} nrf905_rx_irq1_src_t;

// In TX, IRQ0 is always mapped to nFifoEmpty 
typedef enum {
  tx_irq1_FifoFull=0,
  tx_irq1_TxStopped=1
} nrf905_tx_irq1_src_t;


typedef enum {
  nrf905_channelpreset_868mhz=0,
  nrf905_channelpreset_869mhz=1,
  nrf905_channelpreset_870mhz=2,
  nrf905_channelpreset_433mhz=3,
  nrf905_channelpreset_434mhz=4,
  nrf905_channelpreset_435mhz=5,
} nrf905_channelpreset_t;

typedef enum {
  nrf905_txpower_0dbm=0,
  nrf905_txpower_5dbm=1,
  nrf905_txpower_10dbm=2,
  nrf905_txpower_15dbm=3
} nrf905_txpower_t;

typedef enum {
  nrf905_bitrate_152340=152340U,
  nrf905_bitrate_76170=76170U,
  nrf905_bitrate_50780=50780U,
  nrf905_bitrate_38085=38085U,
//   nrf905_bitrate_30468=30468,
//   nrf905_bitrate_19042=19042,
//   nrf905_bitrate_12695=12695,
//   nrf905_bitrate_8017=8017,
//   nrf905_bitrate_4760=4760
} nrf905_bitrate_t;



/**
 * Receiver modes.
 */
enum {
  nRF905_LnaModeA = 0,
  nRF905_LnaModeB = 1
};


/** 
 * Radio Transition times.
 * See Table 4 of the nRF905 data sheet.
 */
enum nrf905_transition_time_enums {
  nRF905_Standby_to_RX_Time = 700,   // RX wakeup time (us), with quartz oscillator enabled
  nRF905_TX_to_RX_Time = 500,    // RX wakeup time (us), with freq. synthesizer enabled
  nRF905_Standby_to_TX_Time = 250,   // TX wakeup time (us), with quartz oscillator enabled
  nRF905_RX_to_TX_Time = 100,    // TX wakeup time (us), with freq. synthesizer enabled
  nRF905_FS_Wakeup_Time = 200,    // Frequency synthesizer wakeup time 
  nRF905_Sleep_to_Standby_Time = 1000    // Quartz oscillator wakeup time ( xxx 7ms for 3rd overtone????)
};

// xxx merge into above enum but check
enum {
  nRF905_Sleep_to_RX_Time = nRF905_Sleep_to_Standby_Time + nRF905_Standby_to_RX_Time, 
  nRF905_Sleep_to_TX_Time = nRF905_Sleep_to_Standby_Time + nRF905_Standby_to_TX_Time
};



enum {
  RSSI_BELOW_110 = 0,
  RSSI_110_TO_105 = 1,
  RSSI_105_TO_100 = 2,
  RSSI_100_TO_95 = 3,
  RSSI_95_TO_90 = 4,
  RSSI_90_TO_85 = 5,
  RSSI_ABOVE_85 = 6
};

uint8_t const rssiTab[] = {
  RSSI_BELOW_110,  // 0b0000
  RSSI_110_TO_105, // 0b0001
  RSSI_105_TO_100, // 0b0010
  RSSI_100_TO_95,  // 0b0011
  RSSI_95_TO_90,   // 0b0100 *
  RSSI_95_TO_90,   // 0b0101 *
  RSSI_95_TO_90,   // 0b0110 *
  RSSI_95_TO_90,   // 0b0111
  RSSI_90_TO_85,   // 0b1000 *
  RSSI_90_TO_85,   // 0b1001 *
  RSSI_90_TO_85,   // 0b1010 *
  RSSI_90_TO_85,   // 0b1011 
  RSSI_ABOVE_85,   // 0b1100 *
  RSSI_ABOVE_85,   // 0b1101 *
  RSSI_ABOVE_85,   // 0b1110 *
  RSSI_ABOVE_85    // 0b1111 
  // (*) : 'inconsistent' pairs
};

#endif /* _nRF905CONST_H */

