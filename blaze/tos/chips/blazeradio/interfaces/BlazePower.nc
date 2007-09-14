
/**
 * @author Jared Hill
 * @author David Moss
 */
interface BlazePower {

  /**
   * Restart the chip.  All registers come up in their default settings.
   * @return FAIL if the given radio is not the one in use
   *     SUCCESS if the command will go through
   */
  async command error_t reset();

  /**
   * Stop the oscillator. 
   * @return FAIL if the given radio is not the one in use
   *     SUCCESS if the command will go through
   */
  async command error_t deepSleep();
  
  
  /**
   * Completely power down radios on platforms that have a power pin
   * This doesn't need to return an error_t because it doesn't need to
   * secure the SPI bus for the radio, and the radio doesn't have to be
   * in any special mode.
   */
  async command void shutdown();


  /**
   * The radio has now been reset
   */
  event void resetComplete();
  
  
  /**
   * The radio is now in deep sleep 
   */
  event void deepSleepComplete();
      
  
  
}
