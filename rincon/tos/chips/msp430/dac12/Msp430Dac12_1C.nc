
#included "Msp430Dac12.h"

/**
 * MSP430 DAC12_1 configuration
 * @author David Moss
 */
configuration Msp430Dac12_1C {
  provides {
    interface StdControl as StdControl;
  }
  
  uses {
    interface Configure<const msp430_dac12_control_t *>;
  }
}

implementation {

  components new Msp430Dac12_xP() as Msp430Dac12_1P;
  StdControl = Msp430Dac12_1P;
  Configure = Msp430Dac12_1P;
  
  components HplMsp430Dac12C;
  Msp430Dac12_1P.HplMsp430Dac12 -> HplMsp430Dac12C.HplMsp430Dac12_1;
  
}
