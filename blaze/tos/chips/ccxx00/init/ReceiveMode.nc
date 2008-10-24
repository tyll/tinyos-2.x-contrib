
/**
 * This interface was created in response to bad state logic on the CCxx00 
 * radios. Advice from TI: reset the radio using SRES everytime before you 
 * put the radio into RX mode.
 * @author David Moss
 */

#include "Blaze.h"

interface ReceiveMode {

  /**
   * This is like a split-phase SRX.strobe() command: you must own the SPI
   * bus resource and have set CSn low before calling this.
   */
  command void srx(radio_id_t radioId);
  
  /**
   * The radio is now in RX mode.
   */
  event void srxDone();
  
}

