/**
 * Interface to an ATmega328 external interrupt pin that exposes just the
 * interrupt vector routine for easy linking to generic components (see
 * HplAtm328Interrupt for the full interface).
 *
 * @notes
 * This file is modified from
 * <code>tinyos-2.1.0/tos/chips/atm128/pins/HplAtm128InterruptSig.nc</code>
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 *
 * @see HplAtm328Interrupt
 */
interface HplAtm328InterruptSig
{
  /**
   * Signalled when an interrupt occurs on a pin
   */
  async event void fired();
}

