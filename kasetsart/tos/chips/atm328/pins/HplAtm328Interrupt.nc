/**
 * Interface to an ATmega328 external interrupt pin
 *
 * @notes
 * This file is modified from
 * <code>tinyos-2.1.0/tos/chips/atm128/pins/HplAtm128Interrupt.nc</code>
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

interface HplAtm328Interrupt
{
  /** 
   * Enables ATmega328 hardware interrupt on a particular port
   */
  async command void enable();

  /** 
   * Disables ATmega328 hardware interrupt on a particular port
   */
  async command void disable();

  /** 
   * Gets the current value of the input voltage of a port
   *
   * @return TRUE if the pin is set high, FALSE if it is set low
   */
  async command bool getValue();

  /** 
   * Sets whether the edge should be high to low or low to high.
   * @param TRUE if the interrupt should be triggered on a low to high
   *        edge transition, false for interrupts on a high to low transition
   */
  async command void edge(bool low_to_high);

  /**
   * Signalled when an interrupt occurs on a port
   */
  async event void fired();
}
