
/**
 * @author Jared Hill
 */
 
#ifndef CC2500_H
#define CC2500_H

#include "Blaze.h"

#warning "*** INCLUDING CC2500 RADIO ***"

enum {
  CC2500_RADIO_ID = unique( UQ_BLAZE_RADIO ),
};


enum cc2500_config_reg_state_enums {
  /** GDO2 asserts at Rx sync and deasserts at end of packet */
  CC2500_CONFIG_IOCFG2 = 0x06,
  
  /** GDO1 is High Impedance */
  CC2500_CONFIG_IOCFG1 = 0x2E,
  
  /** GDO0 goes high when the channel is clear */
  CC2500_CONFIG_IOCFG0 = 0x09, 
  
  CC2500_CONFIG_FIFOTHR = 0x07,
  CC2500_CONFIG_SYNC1 = 0xD3,
  CC2500_CONFIG_SYNC0 = 0x91,
  
  /** Maximum variable packet length is 61 per Errata */
  CC2500_CONFIG_PKTLEN = 0x3D,
  
  /** 0x0 and 0xFF are broadcast addresses, append 2 status bytes in Rx */
  CC2500_CONFIG_PKTCTRL1 = 0x07,
  
  /** No hardware CRC check, per errata */
  CC2500_CONFIG_PKTCTRL0 = 0x41,
  
  CC2500_CONFIG_ADDR = 0x00,
  CC2500_CONFIG_CHANNR = 0x20, // 0x37,
  CC2500_CONFIG_FSCTRL1 = 0x10,
  CC2500_CONFIG_FSCTRL0 = 0x00,
  CC2500_CONFIG_FREQ2 = 0x5D,
  CC2500_CONFIG_FREQ1 = 0xF1,
  CC2500_CONFIG_FREQ0 = 0x3B,
  CC2500_CONFIG_MDMCFG4 = 0x2D,
  CC2500_CONFIG_MDMCFG3 = 0x3B,
  CC2500_CONFIG_MDMCFG2 = 0xF3,
  CC2500_CONFIG_MDMCFG1 = 0x22,
  CC2500_CONFIG_MDMCFG0 = 0xF8,
  CC2500_CONFIG_DEVIATN = 0x00,
  CC2500_CONFIG_MCSM2 = 0x07,
  
  /** Switch to TX only on CCA; When done with Tx or Rx, stay in Rx */
  CC2500_CONFIG_MCSM1 = 0x3F,
  CC2500_CONFIG_MCSM0 = 0x18,
  CC2500_CONFIG_FOCCFG = 0x1D,
  CC2500_CONFIG_BSCFG = 0x1C,
  CC2500_CONFIG_AGCTRL2 = 0xC7,
  CC2500_CONFIG_AGCTRL1 = 0x00,
  CC2500_CONFIG_AGCTRL0 = 0xB2,
  CC2500_CONFIG_WOREVT1 = 0x87,
  CC2500_CONFIG_WOREVT0 = 0x6B,
  CC2500_CONFIG_WORCTRL = 0xF8,
  CC2500_CONFIG_FREND1 = 0xB6,
  CC2500_CONFIG_FREND0 = 0x10,
  CC2500_CONFIG_FSCAL3 = 0xEA,
  CC2500_CONFIG_FSCAL2 = 0x2A,
  CC2500_CONFIG_FSCAL1 = 0x00,
  CC2500_CONFIG_FSCAL0 = 0x11,

};


#endif



