
/**
 * @author Jared Hill
 * @author David Moss
 */
interface BlazePower {

  /**
   * Restart the chip.  All registers come up in their default settings.
   */
  async command void reset();
  
  /**
   * Stop the oscillator.
   */
  async command void deepSleep();

  /**
   * Completely power down radios on platforms that have a power pin
   */
  async command void shutdown();

}
