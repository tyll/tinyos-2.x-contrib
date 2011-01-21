/**
 * Implementation of TEP 112 (Microcontroller Power Management) for the
 * Atmega328.
 *
 * @notes
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/McuSleepC.nc</code>
 *
 * @author Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

module McuSleepC @safe() 
{
  provides 
  {
    interface McuSleep;
    interface McuPowerState;
  }
  uses 
  {
    interface McuPowerOverride;
  }
}
implementation 
{

  /* sorted by highest -> lowest power consumption */
  const_uint8_t atm328PowerBits[ATM328_POWER_DOWN + 1] = 
  {
    (0<<SM2)|(0<<SM1)|(0<<SM0),  /* idle */
    (0<<SM2)|(0<<SM1)|(1<<SM0),  /* adc */
    (1<<SM2)|(1<<SM1)|(1<<SM0),  /* ext standby */
    (0<<SM2)|(1<<SM1)|(1<<SM0),  /* power save */
    (1<<SM2)|(1<<SM1)|(0<<SM0),  /* standby */
    (0<<SM2)|(1<<SM1)|(0<<SM0)   /* power down */
  };

  mcu_power_t getPowerState() 
  {
    // Note: we go to sleep even if timer 1, 2, or 3's overflow interrupt
    // is enabled - this allows using these timers as TinyOS "Alarm"s
    // while still having power management.

    // Are external timers running?  
    if (TIMSK0 & ~(1 << OCIE0B | 1 << OCIE0A | 1 << TOIE0) ||
        TIMSK1 & ~(1 << ICIE1 | 1 << OCIE1B | 1 << OCIE1A | 1 << TOIE1) ||
        TIMSK2 & ~(1 << OCIE2B | 1 << OCIE2A | 1 << TOIE2)) 
    {
      return ATM328_POWER_IDLE;
    }
    // SPI
    else if (bit_is_set(SPCR, SPE)) 
    { 
      return ATM328_POWER_IDLE;
    }
    // A UART is active
    else if (UCSR0B & (1 << TXCIE0 | 1 << RXCIE0))  // UART
    {
      return ATM328_POWER_IDLE;
    }
    // I2C (Two-wire) is active
    else if (bit_is_set(TWCR, TWEN))
    {
      return ATM328_POWER_IDLE;
    }
    // ADC is enabled
    else if (bit_is_set(ADCSRA, ADEN)) 
    { 
      // TODO: supposed to return ATM328_POWER_ADC_NR.  However,
      // Timer/Counter2 is not currently programmed to run asynchronously
      return ATM328_POWER_IDLE;
    }
    else 
    {
      return ATM328_POWER_DOWN;
    }
  }
  
  async command void McuSleep.sleep() 
  {
    uint8_t powerState;

    powerState = mcombine(getPowerState(), call McuPowerOverride.lowestState());
    SMCR = (1<<SE) | read_uint8_t(&atm328PowerBits[powerState]);

    sei();
    // All of memory may change at this point...
    asm volatile ("sleep" : : : "memory");
    cli();
  }

  async command void McuPowerState.update() { }

  default async command mcu_power_t McuPowerOverride.lowestState() 
  {
    return ATM328_POWER_DOWN;
  }
}
