#include "Atm328Adc.h"

/**
 * HPL for the Atmega328 A/D conversion susbsystem.
 *
 * @notes
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/adc/HplAtm128AdcP.nc</code>
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

module HplAtm328AdcP @safe() 
{
  provides interface HplAtm328Adc;
  uses interface McuPowerState;
}
implementation 
{
  //=== Direct read of HW registers. =================================
  async command Atm328_ADMUX_t HplAtm328Adc.getAdmux() 
  { 
    return *(Atm328_ADMUX_t*)&ADMUX; 
  }

  async command Atm328_ADCSRA_t HplAtm328Adc.getAdcsra() 
  { 
    return *(Atm328_ADCSRA_t*)&ADCSRA; 
  }

  async command Atm328_ADCSRB_t HplAtm328Adc.getAdcsrb() 
  { 
    return *(Atm328_ADCSRB_t*)&ADCSRB; 
  }

  async command uint16_t HplAtm328Adc.getValue() 
  { 
    return ADCL + ADCH*256; 
  }

  //=== Direct write of HW registers. ================================
  async command void HplAtm328Adc.setAdmux(Atm328_ADMUX_t x) 
  { 
    ADMUX = x.flat;
  }

  async command void HplAtm328Adc.setAdcsra(Atm328_ADCSRA_t x) 
  { 
    ADCSRA = x.flat;
  }

  async command void HplAtm328Adc.setAdcsrb(Atm328_ADCSRB_t x) 
  { 
    ADCSRB = x.flat;
  }

  async command void HplAtm328Adc.setPrescaler(uint8_t scale)
  {
    Atm328_ADCSRA_t current_val = call HplAtm328Adc.getAdcsra(); 
    current_val.bits.adif = 0;
    if (scale == ATM328_ADC_PRESCALE) scale = ATM328_ADC_PRESCALE_128;
    current_val.bits.adps = scale;
    call HplAtm328Adc.setAdcsra(current_val);
  }

  // Individual bit manipulation. These all clear any pending A/D interrupt.
  async command void HplAtm328Adc.enableAdc() 
  {
    SET_BIT(ADCSRA, ADEN); 
    call McuPowerState.update();
  }

  async command void HplAtm328Adc.disableAdc() 
  {
    CLR_BIT(ADCSRA, ADEN); 
    call McuPowerState.update();
  }

  async command void HplAtm328Adc.enableInterrupt() 
  { SET_BIT(ADCSRA, ADIE); }

  async command void HplAtm328Adc.disableInterrupt() 
  { CLR_BIT(ADCSRA, ADIE); }

  async command void HplAtm328Adc.setContinuous() 
  { 
    Atm328_ADCSRB_t current_val = call HplAtm328Adc.getAdcsrb(); 
    current_val.bits.adts = ATM328_ADC_ATS_FREE_RUN;
    call HplAtm328Adc.setAdcsrb(current_val);
    SET_BIT(ADCSRA, ADATE); 
  }

  async command void HplAtm328Adc.setSingle() 
  { CLR_BIT(ADCSRA, ADATE); }

  async command void HplAtm328Adc.resetInterrupt() 
  { CLR_BIT(ADCSRA, ADIF); }

  async command void HplAtm328Adc.startConversion() 
  { SET_BIT(ADCSRA, ADSC); }


  /* A/D status checks */
  async command bool HplAtm328Adc.isEnabled()
  {
    return (call HplAtm328Adc.getAdcsra()).bits.aden; 
  }

  async command bool HplAtm328Adc.isStarted()
  {
    return (call HplAtm328Adc.getAdcsra()).bits.adsc; 
  }
  
  async command bool HplAtm328Adc.isComplete()
  {
    return (call HplAtm328Adc.getAdcsra()).bits.adif; 
  }

  /* A/D interrupt handlers. Signals dataReady event with interrupts enabled */
  AVR_ATOMIC_HANDLER(ADC_vect) 
  {
    uint16_t data;

    call HplAtm328Adc.resetInterrupt();
    data = call HplAtm328Adc.getValue();

    __nesc_enable_interrupt();
    signal HplAtm328Adc.dataReady(data);
  }

  default async event void HplAtm328Adc.dataReady(uint16_t done) { }

  async command bool HplAtm328Adc.cancel() 
  { 
    /* This is tricky */
    atomic
    {
      Atm328_ADCSRA_t oldSr = call HplAtm328Adc.getAdcsra(), newSr;

      /* To cancel a conversion, first turn off ADEN, then turn off
         ADSC. We also cancel any pending interrupt.
         Finally we reenable the ADC.
         */
      newSr = oldSr;
      newSr.bits.aden = FALSE;
      newSr.bits.adif = TRUE;  /* This clears a pending interrupt... */
      newSr.bits.adie = FALSE; /* We don't want to start sampling again at the
                             next sleep */
      call HplAtm328Adc.setAdcsra(newSr);
      newSr.bits.adsc = FALSE;
      call HplAtm328Adc.setAdcsra(newSr);
      newSr.bits.aden = TRUE;
      call HplAtm328Adc.setAdcsra(newSr);

      return oldSr.bits.adif || oldSr.bits.adsc;
    }
  }
}
