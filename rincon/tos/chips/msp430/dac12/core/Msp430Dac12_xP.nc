
#include "Msp430Dac12.h"

/**
 * @author David Moss
 */
generic module Msp430Dac12_xP() {
  provides {
    interface StdControl;
    interface Msp430Dac12;
  }
  
  uses {
    interface Configure<const msp430_dac12_control_t *>;
    interface HplMsp430Dac12;
  }
}

implementation {

  
  /***************** StdControl Commands ****************/
  command error_t StdControl.start() {
    msp430_dac12_control_t localCtl;
    
    memcpy(&localCtl, call Configure.getConfiguration(), sizeof(msp430_dac12_control_t));
    localCtl.dac12enc = 0;
    localCtl.dac12calon = 0;
   
    call HplMsp430Dac12.configure(&localCtl);
    call HplMsp430Dac12.calibrate();
    call HplMsp430Dac12.enableConversion(TRUE);
    return SUCCESS;
  }
  
  command error_t StdControl.stop() {
    call HplMsp430Dac12.enableConversion(FALSE);
    call HplMsp430Dac12.setDac12Amp(DAC12AMP_INPUTOFF_OUTPUTHIGHZ);
    return SUCCESS;
  }
  
  /***************** Msp430Dac12 Commands ****************/
  command void Msp430Dac12.write(uint16_t data) {
    call HplMsp430Dac12.write(data);
  }
  
  command void Msp430Dac12.recalibrate() {
    call HplMsp430Dac12.calibrate();
  }
  
  command void Msp430Dac12.group(bool grouped) {
    call HplMsp430Dac12.group(grouped);
  }
  

}

