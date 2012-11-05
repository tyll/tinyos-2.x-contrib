/* $Id$ */

/**
 *  @author Roman Lim
 */

interface CollectionLowPowerListening {

   /**
   * Set a default Rx sleep interval for every transmitted packet
   * @param sleepInterval The receiving node's sleep interval, in [ms]
   */
  command void setDefaultRxSleepInterval(uint16_t sleepIntervalMs);
  
  /**
   * Set a default Rx duty cycle rate for every transmitted packet
   * Duty cycle is in units of [percentage*100], i.e. 0.25% duty cycle = 25.
    * @param dutyCycle The duty cycle of the receiving mote, in units of 
   *     [percentage*100]
   */
  command void setDefaultRxDutyCycle(uint16_t dutyCycle);

}
