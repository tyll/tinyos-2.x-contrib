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

#ifndef __BLAZE_H__
#define __BLAZE_H__

#ifndef BLAZE_ENABLE_WHILE_LOOP_PRINTF
#define BLAZE_ENABLE_WHILE_LOOP_PRINTF 0
#endif

#ifndef BLAZE_ENABLE_WHILE_LOOP_LEDS
#define BLAZE_ENABLE_WHILE_LOOP_LEDS 0
#endif

#ifndef BLAZE_ENABLE_TIMING_LEDS
#define BLAZE_ENABLE_TIMING_LEDS 0
#endif

#ifndef BLAZE_ENABLE_SPI_WOR_RX_LEDS
#define BLAZE_ENABLE_SPI_WOR_RX_LEDS 0
#endif

#ifndef BLAZE_ENABLE_LPL_LEDS
#define BLAZE_ENABLE_LPL_LEDS 0
#endif

#ifndef BLAZE_ENABLE_CRC_32
#define BLAZE_ENABLE_CRC_32 1
#endif

#ifndef PRINTF_DUTY_CYCLE
#define PRINTF_DUTY_CYCLE 0
#endif

typedef uint8_t blaze_status_t;
typedef uint8_t radio_id_t;

/**
 * Note that the first 8 bytes of the header are identical to the
 * 8 bytes found in blaze_ack_t
 */
typedef nx_struct blaze_header_t {
  nxle_uint8_t length;
  nxle_uint16_t dest;
  nxle_uint8_t fcf;
  nxle_uint8_t dsn;
  nxle_uint16_t src;
  nxle_uint8_t destpan;
  nxle_uint8_t type;
} blaze_header_t;

typedef nx_struct blaze_footer_t {
#if BLAZE_ENABLE_CRC_32
  nx_uint32_t crc;
#endif
} blaze_footer_t;

typedef nx_struct blaze_metadata_t {
  nx_uint8_t rssi;
  nx_uint8_t lqi;
  nx_uint8_t radio;
  nx_uint8_t txPower;
  nx_uint16_t rxInterval;
  nx_uint16_t maxRetries;
  nx_uint16_t retryDelay;
} blaze_metadata_t;


/**
 * Acknowledgement frame structure.
 */
typedef nx_struct blaze_ack_t {
  nxle_uint8_t length;
  nxle_uint16_t dest;
  nxle_uint8_t fcf;
  nxle_uint8_t dsn;
  nxle_uint16_t src;
} blaze_ack_t;

enum {
  // size of the header not including the length byte
  MAC_HEADER_SIZE = sizeof( blaze_header_t ) - 1,
  
  // size of the footer
  MAC_FOOTER_SIZE = sizeof( blaze_footer_t ),
  
  // size of the acknowledgement frame, not including the length byte
  ACK_FRAME_LENGTH = sizeof( blaze_ack_t ) - 1,
};


enum blaze_cmd_strobe_enums {

  BLAZE_SRES = 0x30,
  BLAZE_SFSTXON = 0x31,
  BLAZE_SXOFF = 0x32,
  BLAZE_SCAL = 0x33,
  BLAZE_SRX = 0x34,
  BLAZE_STX = 0x35,
  BLAZE_SIDLE = 0x36,
  BLAZE_SWOR = 0x38,
  BLAZE_SPWD = 0x39,
  BLAZE_SFRX = 0x3A,
  BLAZE_SFTX = 0x3B,
  BLAZE_SWORRST = 0x3C,
  BLAZE_SNOP = 0x3D,
  
};

enum blaze_addr_enums {

  BLAZE_PATABLE = 0x3E,
  BLAZE_TXFIFO = 0x3F,
  BLAZE_RXFIFO = 0xBF,

};

enum blaze_state_enums{

  BLAZE_S_IDLE = 0x00,
  BLAZE_S_RX = 0x01,
  BLAZE_S_TX = 0x02,
  BLAZE_S_FSTXON = 0x03,
  BLAZE_S_CALIBRATE = 0x04,
  BLAZE_S_SETTLING = 0x05,
  BLAZE_S_RXFIFO_OVERFLOW = 0x06,
  BLAZE_S_TXFIFO_UNDERFLOW = 0x07,
  
};

enum blaze_mask_enums {

  BLAZE_WRITE = 0x00,
  BLAZE_READ = 0x80,
  BLAZE_SINGLE = 0x00, 
  BLAZE_BURST = 0x40,
};

enum blaze_config_reg_addr_enums {

  BLAZE_IOCFG2 = 0x00,
  BLAZE_IOCFG1 = 0x01,
  BLAZE_IOCFG0 = 0x02,
  BLAZE_FIFOTHR = 0x03,
  BLAZE_SYNC1 = 0x04,
  BLAZE_SYNC0 = 0x05,
  BLAZE_PKTLEN = 0x06,
  BLAZE_PKTCTRL1 = 0x07,
  BLAZE_PKTCTRL0 = 0x08,
  BLAZE_ADDR = 0x09,
  BLAZE_CHANNR = 0x0A,
  BLAZE_FSCTRL1 = 0x0B,
  BLAZE_FSCTRL0 = 0x0C,
  BLAZE_FREQ2 = 0x0D,
  BLAZE_FREQ1 = 0x0E,
  BLAZE_FREQ0 = 0x0F,
  BLAZE_MDMCFG4 = 0x10,
  BLAZE_MDMCFG3 = 0x11,
  BLAZE_MDMCFG2 = 0x12,
  BLAZE_MDMCFG1 = 0x13,
  BLAZE_MDMCFG0 = 0x14,
  BLAZE_DEVIATN = 0x15,
  BLAZE_MCSM2 = 0x16,
  BLAZE_MCSM1 = 0x17,
  BLAZE_MCSM0 = 0x18,
  BLAZE_FOCCFG = 0x19,
  BLAZE_BSCFG = 0x1A,
  BLAZE_AGCTRL2 = 0x1B,
  BLAZE_AGCTRL1 = 0x1C,
  BLAZE_AGCTRL0 = 0x1D,
  BLAZE_WOREVT1 = 0x1E,
  BLAZE_WOREVT0 = 0x1F,
  BLAZE_WORCTRL = 0x20,
  BLAZE_FREND1 = 0x21,
  BLAZE_FREND0 = 0x22,
  BLAZE_FSCAL3 = 0x23,
  BLAZE_FSCAL2 = 0x24,
  BLAZE_FSCAL1 = 0x25,
  BLAZE_FSCAL0 = 0x26,
  BLAZE_RCCTRL1 = 0x27, 
  BLAZE_RCCTRL0 = 0x28,
  BLAZE_FSTEST = 0x29,
  BLAZE_PTEST = 0x2A,
  BLAZE_AGCTEST = 0x2B,
  BLAZE_TEST2 = 0x2C,
  BLAZE_TEST1 = 0x2D,
  BLAZE_TEST0 = 0x2E,
  BLAZE_PARTNUM = 0x30 | BLAZE_BURST,
  BLAZE_VERSION = 0x31 | BLAZE_BURST,
  BLAZE_FREQEST = 0x32 | BLAZE_BURST,
  BLAZE_LQI = 0x33 | BLAZE_BURST,
  BLAZE_RSSI = 0x34 | BLAZE_BURST,
  BLAZE_MARCSTATE = 0x35 | BLAZE_BURST,
  BLAZE_WORTIME1 = 0x36 | BLAZE_BURST,
  BLAZE_WORTIME0 = 0x37 | BLAZE_BURST,
  BLAZE_PKSTATUS = 0x38 | BLAZE_BURST,
  BLAZE_VCO_VC_DAC = 0x39 | BLAZE_BURST,
  BLAZE_TXBYTES = 0x3A | BLAZE_BURST,
  BLAZE_RXBYTES = 0x3B | BLAZE_BURST,

};

#ifndef UQ_BLAZE_RADIO
#define UQ_BLAZE_RADIO "Unique_Blaze_Radio"
#endif

#endif



