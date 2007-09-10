 
/**
 * Manage the CC2500 SPI connection
 * @author Jared Hill
 * @author David Moss
 */
 
#include "Blaze.h"
#include "CC2500.h"

module CC2500InitP {

  provides {
    interface Init as SoftwareInit;
    interface BlazeRegSettings;
  }

  uses {
    interface GeneralIO as Csn;
    interface GeneralIO as Power;
    interface GeneralIO as Gdo0_io;
    interface GeneralIO as Gdo2_io;
    interface ActiveMessageAddress;
    interface Leds;
  }
}

implementation {

  /** Default register values. Change the configuration by editing CC2500.h */
  uint8_t regValues[] = {
      CC2500_CONFIG_IOCFG2, 
      CC2500_CONFIG_IOCFG1, 
      CC2500_CONFIG_IOCFG0,
      CC2500_CONFIG_FIFOTHR, 
      CC2500_CONFIG_SYNC1, 
      CC2500_CONFIG_SYNC0, 
      CC2500_CONFIG_PKTLEN,
      CC2500_CONFIG_PKTCTRL1, 
      CC2500_CONFIG_PKTCTRL0, 
      CC2500_CONFIG_ADDR, 
      CC2500_CONFIG_CHANNR,
      CC2500_CONFIG_FSCTRL1, 
      CC2500_CONFIG_FSCTRL0, 
      CC2500_CONFIG_FREQ2, 
      CC2500_CONFIG_FREQ1,
      CC2500_CONFIG_FREQ0, 
      CC2500_CONFIG_MDMCFG4, 
      CC2500_CONFIG_MDMCFG3, 
      CC2500_CONFIG_MDMCFG2,
      CC2500_CONFIG_MDMCFG1, 
      CC2500_CONFIG_MDMCFG0, 
      CC2500_CONFIG_DEVIATN, 
      CC2500_CONFIG_MCSM2,
      CC2500_CONFIG_MCSM1, 
      CC2500_CONFIG_MCSM0, 
      CC2500_CONFIG_FOCCFG, 
      CC2500_CONFIG_BSCFG,
      CC2500_CONFIG_AGCTRL2, 
      CC2500_CONFIG_AGCTRL1, 
      CC2500_CONFIG_AGCTRL0, 
      CC2500_CONFIG_WOREVT1,
      CC2500_CONFIG_WOREVT0, 
      CC2500_CONFIG_WORCTRL, 
      CC2500_CONFIG_FREND1, 
      CC2500_CONFIG_FREND0,
      CC2500_CONFIG_FSCAL3, 
      CC2500_CONFIG_FSCAL2, 
      CC2500_CONFIG_FSCAL1, 
      CC2500_CONFIG_FSCAL0,
  };
  
  /***************** SoftwareInit Commands ****************/
  command error_t SoftwareInit.init() {
    // TODO the struct is an nxle. Do we put the MSB's in the ADDR reg?
    regValues[BLAZE_ADDR] = (call ActiveMessageAddress.amAddress()) >> 8;
    
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

  /***************** ActiveMessageAddress Events ****************/
  async event void ActiveMessageAddress.changed() {   
    regValues[BLAZE_ADDR] = (call ActiveMessageAddress.amAddress()) >> 8;
  }
}
