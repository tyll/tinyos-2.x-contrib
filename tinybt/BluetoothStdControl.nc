/**
 *
 * $Rev:: 48          $:  Revision of last commit
 * $Author$:  Author of last commit
 * $Date$:  Date of last commit
 *
 **/
interface BluetoothStdControl
{
  /**
   * Start this component and all of its subcomponents.
   *
   * @return SUCCESS if the component was either already on or was 
   *         successfully turned on<br>
   *         FAIL otherwise
   */
  command error_t start();

  /**
   * Stop the component and any pertinent subcomponents (not all
   * subcomponents may be turned off due to wakeup timers, etc.).
   *
   * @return SUCCESS if the component was either already off or was 
   *         successfully turned off<br>
   *         FAIL otherwise
   */
  command error_t stop();
  
  /**
   * Reset the BT component.
   *
   *
   */
  command void reset();
  
  /**
   * Tells when the reset is Done
   */
  event void resetDone();
}
