#include "Atm328Adc.h"

/**
 * HPL interface to the Atmega328 A/D conversion subsystem.
 *
 * @notes
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/adc/HplAtm128Adc.nc</code>
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

interface HplAtm328Adc 
{
  /**
   * Read the ADMUX (ADC selection) register
   * @return Current ADMUX value
   */
  async command Atm328_ADMUX_t getAdmux();

  /**
   * Set the ADMUX (ADC selection) register
   * @param admux New ADMUX value
   */
  async command void setAdmux(Atm328_ADMUX_t admux);

  /**
   * Read the ADCSRA (ADC control) register
   * @return Current ADCSRA value
   */
  async command Atm328_ADCSRA_t getAdcsra();

  /**
   * Read the ADCSRB (ADC control) register A
   * @return Current ADCSRB value
   */
  async command Atm328_ADCSRB_t getAdcsrb();

  /**
   * Set the ADCSRA (ADC control) register A
   * @param adcsra New ADCSRA value
   */
  async command void setAdcsra(Atm328_ADCSRA_t adcsra);

  /**
   * Set the ADCSRA (ADC control) register B
   * @param adcsra New ADCSRB value
   */
  async command void setAdcsrb(Atm328_ADCSRB_t adcsrb);

  /**
   * Read the latest A/D conversion result
   * @return A/D value
   */
  async command uint16_t getValue();

  /// A/D control utilities. All of these clear any pending A/D interrupt.

  /**
   * Enable ADC sampling
   */
  async command void enableAdc();
  /**
   * Disable ADC sampling
   */
  async command void disableAdc();

  /**
   * Enable ADC interrupt
   */
  async command void enableInterrupt();
  /**
   * Disable ADC interrupt
   */
  async command void disableInterrupt();
  /**
   * Clear the ADC interrupt flag
   */
  async command void resetInterrupt();

  /**
   * Start ADC conversion. If ADC interrupts are enabled, the dataReady event
   * will be signaled once (in non-continuous mode) or repeatedly (in
   * continuous mode).
   */
  async command void startConversion();
  /**
   * Enable continuous sampling
   */
  async command void setContinuous();
  /**
   * Disable continuous sampling
   */
  async command void setSingle();

  /* A/D status checks */

  /**
   * Is ADC enabled?
   * @return TRUE if the ADC is enabled, FALSE otherwise
   */
  async command bool isEnabled();

  /**
   * Is A/D conversion in progress?
   * @return TRUE if the A/D conversion is in progress, FALSE otherwise
   */
  async command bool isStarted();

  /**
   * Is A/D conversion complete? Note that this flag is automatically
   * cleared when an A/D interrupt occurs.
   * @return TRUE if the A/D conversion is complete, FALSE otherwise
   */
  async command bool isComplete();

  /**
   * Set ADC prescaler selection bits
   * @param scale New ADC prescaler. Must be one of the
   * ATM328_ADC_PRESCALE_xxx values from Atm328Adc.h
   */
  async command void setPrescaler(uint8_t scale);

  /**
   * Cancel A/D conversion and any pending A/D interrupt. Also disables the
   * ADC interruption (otherwise a sample might start at the next sleep
   * instruction). This command can assume that the A/D converter is enabled. 
   *
   * @return TRUE if an A/D conversion was in progress or an A/D interrupt was
   * pending, FALSE otherwise. In single conversion mode, a return of TRUE
   * implies that the dataReady event will not be signaled.
   */
  async command bool cancel();

  /**
   * A/D interrupt occured
   * @param data Latest A/D conversion result
   */
  async event void dataReady(uint16_t data);
}

