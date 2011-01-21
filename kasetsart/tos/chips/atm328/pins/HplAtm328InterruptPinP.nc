/**
 * Interrupt interface access for interrupt capable GPIO pins.  Currently
 * only pin-change interrupts are supported.
 *
 * @notes
 * This file is modified from
 * <code>tinyos-2.1.0/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc</code>
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
generic module HplAtm328InterruptPinP (
                 uint8_t pin_reg, 
                 uint8_t pin_bit,
                 uint8_t mask_reg, 
                 uint8_t mask_bit, 
				 uint8_t pcicr_bit) @safe()
{
  provides interface HplAtm328Interrupt as Irq;
  uses interface HplAtm328InterruptSig as IrqSignal;
}
implementation
{
  bool m_low_to_high = TRUE;
  bool m_prev_pin_val;

#define REG(addr)  (*TCAST(volatile uint8_t * ONE, addr))

  inline async command bool Irq.getValue() 
  { 
    return (REG(pin_reg) & (1 << pin_bit)) != 0; 
  }

  inline async command void Irq.enable()
  { 
    REG(mask_reg) |= 1 << mask_bit; // turn this pin's mask on
    PCICR |= 1 << pcicr_bit;        // enable pin-change interrupt for this group
    atomic
    {
      m_prev_pin_val = call Irq.getValue(); // save the current pin value
    }
  }

  inline async command void Irq.disable()
  {
    REG(mask_reg) &= ~(1 << mask_bit); 

    // disable PCINT group if no PCINT in this group is used
    if (REG(mask_reg) == 0) PCICR &= ~(1 << pcicr_bit);
  }

  inline async command void Irq.edge(bool low_to_high) 
  {
    atomic { m_low_to_high = low_to_high; }
  }

  /** 
   * Forward the pin-change interrupt signal to appropriate handler.
   */
  async event void IrqSignal.fired() 
  { 
    atomic
    {
      // check if I should forward this event
      bool current_val = call Irq.getValue();
      if (m_prev_pin_val != current_val)
      {
        m_prev_pin_val = current_val;

        if (current_val == m_low_to_high)
          signal Irq.fired(); 
      }
    }
  }

  default async event void Irq.fired() { }
}
