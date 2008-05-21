#include "Hcs08Adc.h"

#ifndef ADC_CHANNEL
#define ADC_CHANNEL Hcs08_ADC_VREFL
#endif

module SensorP
{
  provides interface ResourceConfigure;
  provides interface Hcs08AdcConfig as AdcConfig;
}
implementation
{
  async command uint8_t AdcConfig.getChannel(){
  	return ADC_CHANNEL;
  }
  async command uint8_t AdcConfig.getPrescaler(){ 
    return Hcs08_ADC_PRESCALE_18;
  }
  
  async command bool AdcConfig.get8bit(){ 
    return FALSE;
  }
  
  async command bool AdcConfig.getSigned(){ 
    return FALSE;
  }
  
  async command bool AdcConfig.getLeftJustify(){ 
    return FALSE;
  }

  async command void ResourceConfigure.configure() {
  }

  async command void ResourceConfigure.unconfigure() {
  }
}