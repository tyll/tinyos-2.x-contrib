/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */
/**
 * at91 interrupt mapping
 */

interface HplAT91Interrupt
{
  /** 
   * Allocates interrupts
   */
  async command error_t allocate();

  /**
   * Enables a periperhal interrupt.
   */
  async command void enable();

  /**
   * Disables a peripheral interrupt.
   */
  async command void disable();

  /**
   * The peripheral interrupt event.
   */
  async event void fired();
}
