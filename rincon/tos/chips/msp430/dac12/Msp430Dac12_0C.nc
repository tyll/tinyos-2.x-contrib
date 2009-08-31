
#include "Msp430Dac12.h"

/**
 * MSP430 DAC12_0 configuration
 * @author David Moss
 */
configuration Msp430Dac12_0C {
  provides {
    interface StdControl as StdControl;
    interface Msp430Dac12;
  }
  
  uses {
    interface Configure<const msp430_dac12_control_t *>;
  }
}

implementation {

  components new Msp430Dac12_xP() as Msp430Dac12_0P;
  StdControl = Msp430Dac12_0P;
  Configure = Msp430Dac12_0P;
  Msp430Dac12 = Msp430Dac12_0P;
  
  components HplMsp430Dac12C;
  Msp430Dac12_0P.HplMsp430Dac12 -> HplMsp430Dac12C.HplMsp430Dac12_0;
  
}
