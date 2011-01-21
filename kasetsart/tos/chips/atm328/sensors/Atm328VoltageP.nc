#include "Atm328Adc.h"

/**
 * Provides internal voltage probe for ATmega328 microcontroller
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

module Atm328VoltageP
{
  provides interface AdcConfigure<const Atm328Adc_config_t*>;
}
implementation
{
  const Atm328Adc_config_t config = {
    channel:     ATM328_ADC_MUX_1_1,
    ref_voltage: ATM328_ADC_VREF_AVCC,
    prescaler:   ATM328_ADC_PRESCALE
  };

  async command const Atm328Adc_config_t* AdcConfigure.getConfiguration()
  {
    return &config;
  }
}
