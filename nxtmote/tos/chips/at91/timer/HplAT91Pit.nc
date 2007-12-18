/**
 * Periodic Interval Timer Interface.
 * @author Rasmus Pedersen
 */

interface HplAT91Pit
{
  async command uint32_t getPITMR();

  async command void setPITMR(uint32_t val);   

  async command uint32_t getPITSR();
  
  async command uint32_t getPITPIVR();
  
  async command uint32_t getPITPIIR();
  
  /**
   * Fired. The event handler must call getPITSR() in this interface.
   * It will clear the status register.
   */
  async event void fired();
  
  /** 
  * Same as fired, but signalled from a task (posted by the fired event().
  * If this event is used then it is not necessary to post a task in the signalled
  * component to get sync code.
  * @param taskMiss   how many times fired failed to post the task that signals
  *                   firedTask(). Would mean that "something" is taking longer
  *                   than 1 ms somewhere in the system without giving up control.
  */
  event void firedTask(uint32_t taskMiss);
}
