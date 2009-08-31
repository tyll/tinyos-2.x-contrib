
#include "Msp430Dac12.h"

/**
 * @author David Moss
 */
 
module DacConfigurationP {
  provides {
    interface Configure<const msp430_dac12_control_t *>;
  }
}

implementation {
  
  const msp430_dac12_control_t config = {
    dac12srefx : DAC12SREF_VREF,
    dac12res   : DAC12RES_12BIT,
    dac12lselx : DAC12LSEL_DATA_WRITTEN_ALWAYS,
    dac12ir    : DAC12IR_1X_VOLTREF,
    dac12ampx  : DAC12AMP_INPUTHIGH_OUTPUTHIGH,
    dac12df    : DAC12_DATAFORMAT_BINARY,
    dac12ie    : DAC12_INTERRUPTS_DISABLED,
    dac12grp   : DAC12_NOT_GROUPED,
  };
  
  async command const msp430_dac12_control_t *Configure.getConfiguration() {
    return &config;
  }
  
}

