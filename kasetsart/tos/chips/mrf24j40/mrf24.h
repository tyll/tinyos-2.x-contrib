#ifndef __MRF24_H__
#define __MRF24_H__

#ifndef TFRAMES_ENABLED
#define MRF24_IFRAME_TYPE
#endif

#ifndef TOSH_DATA_LENGTH
#define TOSH_DATA_LENGTH 28
#endif

#ifndef MRF24_DEF_CHANNEL
#define MRF24_DEF_CHANNEL 26
#endif

/** 
 * The 6LowPAN NALP ID for a TinyOS network is 63 (TEP 125).
 */
#ifndef TINYOS_6LOWPAN_NETWORK_ID
#define TINYOS_6LOWPAN_NETWORK_ID 0x3f
#endif

#define CHANNEL(x) (0x2|((x-11)<<4))
#define LOW_BYTE(x) (x & 0xFF)
#define HIGH_BYTE(x) (x >> 8)

typedef nx_struct mrf24_header
{
  nxle_uint16_t frame_ctrl;
  nxle_uint8_t  frame_id;
  nxle_uint16_t dstpan;
  nxle_uint16_t dst;
  //nxle_uint16_t srcpan; --> Not used in intra-PAN
  nxle_uint16_t src;

  /*** IEEE 802.15.4 data payload starts here ***/
#ifdef MRF24_IFRAME_TYPE
  nxle_uint8_t  network;
#endif
  nxle_uint8_t  type;
} mrf24_header_t;

typedef nx_struct mrf24_footer
{
} mrf24_footer_t;

typedef nx_struct mrf24_metadata
{
  nxle_uint8_t payload_len;
  nxle_uint8_t lqi;
  nxle_uint8_t rssi;
  nxle_uint8_t num_retries;
  nx_bool      cca_fail;
  nx_bool      acked;
} mrf24_metadata_t;

typedef enum ShortRegAddress
{
    RXMCR      = 0x00,
    PANIDL     = 0x01,
    PANIDH     = 0x02,
    SADRL      = 0x03,
    SADRH      = 0x04,
    EADR0      = 0x05,
    EADR1      = 0x06,
    EADR2      = 0x07,
    EADR3      = 0x08,
    EADR4      = 0x09,
    EADR5      = 0x0A,
    EADR6      = 0x0B,
    EADR7      = 0x0C,
    RXFLUSH    = 0x0D,
    ORDER      = 0x10,
    TXMCR      = 0x11,
    ACKTMOUT   = 0x12,
    ESLOTG1    = 0x13,
    SYMTICKL   = 0x14,
    SYMTICKH   = 0x15,
    PACON0     = 0x16,
    PACON1     = 0x17,
    PACON2     = 0x18,
    TXBCON0    = 0x1A,
    TXNCON     = 0x1B,
    TXG1CON    = 0x1C,
    TXG2CON    = 0x1D,
    ESLOTG23   = 0x1E,
    ESLOTG45   = 0x1F,
    ESLOTG67   = 0x20,
    TXPEND     = 0x21,
    WAKECON    = 0x22,
    FRMOFFSET  = 0x23,
    TXSTAT     = 0x24,
    TXBCON1    = 0x25,
    GATECLK    = 0x26,
    TXTIME     = 0x27,
    HSYMTMRL   = 0x28,
    HSYMTMRH   = 0x29,
    SOFTRST    = 0x2A,
    SECCON0    = 0x2C,
    SECCON1    = 0x2D,
    TXSTBL     = 0x2E,
    RXSR       = 0x30,
    INTSTAT    = 0x31,
    INTCON     = 0x32,
    GPIO       = 0x33,
    TRISGPIO   = 0x34,
    SLPACK     = 0x35,
    RFCTL      = 0x36,
    SECCR2     = 0x37,
    BBREG0     = 0x38,
    BBREG1     = 0x39,
    BBREG2     = 0x3A,
    BBREG3     = 0x3B,
    BBREG4     = 0x3C,
    BBREG6     = 0x3E,
    CCAEDTH    = 0x3F
} ShortRegAddr;

typedef enum LongRegAddress
{
    RFCON0     = 0x200,
    RFCON1     = 0x201,
    RFCON2     = 0x202,
    RFCON3     = 0x203,
    RFCON5     = 0x205,
    RFCON6     = 0x206,
    RFCON7     = 0x207,
    RFCON8     = 0x208,
    SLPCAL0    = 0x209,
    SLPCAL1    = 0x20A,
    SLPCAL2    = 0x20B,
    RFSTATE    = 0x20F,
    RSSI       = 0x210,
    SLPCON0    = 0x211,
    SLPCON1    = 0x220,
    Reserved   = 0x221,
    WAKETIMEL  = 0x222,
    WAKETIMEH  = 0x223,
    REMCNTL    = 0x224,
    REMCNTH    = 0x225,
    MAINCNT0   = 0x226,
    MAINCNT1   = 0x227,
    MAINCNT2   = 0x228,
    MAINCNT3   = 0x229,
    TESTMODE   = 0x22F,
    ASSOEADR0  = 0x230,
    ASSOEADR1  = 0x231,
    ASSOEADR2  = 0x232,
    ASSOEADR3  = 0x233,
    ASSOEADR4  = 0x234,
    ASSOEADR5  = 0x235,
    ASSOEADR6  = 0x236,
    ASSOEADR7  = 0x237,
    ASSOSADR0  = 0x238,
    ASSOSADR1  = 0x239,
    UPNONCE0   = 0x240,
    UPNONCE1   = 0x241,
    UPNONCE2   = 0x242,
    UPNONCE3   = 0x243,
    UPNONCE4   = 0x244,
    UPNONCE5   = 0x245,
    UPNONCE6   = 0x246,
    UPNONCE7   = 0x247,
    UPNONCE8   = 0x248,
    UPNONCE9   = 0x249,
    UPNONCE10  = 0x24A,
    UPNONCE11  = 0x24B,
    UPNONCE12  = 0x24C,
    RXFRMLEN   = 0x300,
    RXSRCADDRL = 0x30A
} LongRegAddr;

enum 
{
    MRF24_TX_NORMAL_FIFO = 0x000,
    MRF24_RX_NORMAL_FIFO = 0x300
};

/////////////////////////////////////////////////
// INTSTAT: Interrupt Status Register (page 51)
/////////////////////////////////////////////////
typedef union
{
    uint8_t flat;
    struct 
    {
        uint8_t txnif     : 1;
        uint8_t txg1ie    : 1;
        uint8_t txg2ie    : 1;
        uint8_t rxif      : 1;
        uint8_t secie     : 1;
        uint8_t hsymtmrie : 1;
        uint8_t wakeie    : 1;
        uint8_t slpie     : 1;
    } bits;
} Mrf24_INTSTAT_t;

/////////////////////////////////////////////////
// TXSTAT: TX MAC Status Register (page 41)
/////////////////////////////////////////////////
typedef union
{
    uint8_t flat;
    struct 
    {
        uint8_t txnstat  : 1;
        uint8_t txg1stat : 1;
        uint8_t txg2stat : 1;
        uint8_t txg1fnt  : 1;
        uint8_t txg2fnt  : 1;
        uint8_t ccafail  : 1;
        uint8_t txnretry : 2;
    } bits;
} Mrf24_TXSTAT_t;

#endif
