 
/**
 * Manage the CC1100 SPI connection
 * @author Jared Hill
 * @author David Moss
 */
 
#include "Blaze.h"
#include "CC1100.h"

module CC1100InitP {

  provides {
    interface Init as SoftwareInit;
    interface BlazeRegSettings;
  }

  uses {
    interface GeneralIO as Csn;
    interface GeneralIO as Power;
    interface GeneralIO as Gdo0_io;
    interface GeneralIO as Gdo2_io;
    interface Leds;
  }
}

implementation {

  /** Default register values. Change the configuration by editing CC1100.h */
  uint8_t regValues[] = {
      CC1100_CONFIG_IOCFG2, 
      CC1100_CONFIG_IOCFG1, 
      CC1100_CONFIG_IOCFG0,
      CC1100_CONFIG_FIFOTHR, 
      CC1100_CONFIG_SYNC1, 
      CC1100_CONFIG_SYNC0, 
      CC1100_CONFIG_PKTLEN,
      CC1100_CONFIG_PKTCTRL1, 
      CC1100_CONFIG_PKTCTRL0, 
      CC1100_CONFIG_ADDR, 
      CC1100_CONFIG_CHANNR,
      CC1100_CONFIG_FSCTRL1, 
      CC1100_CONFIG_FSCTRL0, 
      CC1100_CONFIG_FREQ2, 
      CC1100_CONFIG_FREQ1,
      CC1100_CONFIG_FREQ0, 
      CC1100_CONFIG_MDMCFG4, 
      CC1100_CONFIG_MDMCFG3, 
      CC1100_CONFIG_MDMCFG2,
      CC1100_CONFIG_MDMCFG1, 
      CC1100_CONFIG_MDMCFG0, 
      CC1100_CONFIG_DEVIATN, 
      CC1100_CONFIG_MCSM2,
      CC1100_CONFIG_MCSM1, 
      CC1100_CONFIG_MCSM0, 
      CC1100_CONFIG_FOCCFG, 
      CC1100_CONFIG_BSCFG,
      CC1100_CONFIG_AGCTRL2, 
      CC1100_CONFIG_AGCTRL1, 
      CC1100_CONFIG_AGCTRL0, 
      CC1100_CONFIG_WOREVT1,
      CC1100_CONFIG_WOREVT0, 
      CC1100_CONFIG_WORCTRL, 
      CC1100_CONFIG_FREND1, 
      CC1100_CONFIG_FREND0,
      CC1100_CONFIG_FSCAL3, 
      CC1100_CONFIG_FSCAL2, 
      CC1100_CONFIG_FSCAL1, 
      CC1100_CONFIG_FSCAL0,
  };
  
  /***************** SoftwareInit Commands ****************/
  command error_t SoftwareInit.init() {
    call Csn.makeOutput();
    call Power.makeOutput();
    
    // Keep GDO's output low to avoid floaters
    call Gdo0_io.makeInput();  // TODO platform init this to output
    call Gdo2_io.makeInput();  // TODO should be output perhaps
    call Gdo0_io.clr();
    call Gdo2_io.clr();
    
    return SUCCESS;
  }
  
  /***************** BlazeInit Commands ****************/
  command uint8_t *BlazeRegSettings.getDefaultRegisters() {
    return regValues;
  }

}
