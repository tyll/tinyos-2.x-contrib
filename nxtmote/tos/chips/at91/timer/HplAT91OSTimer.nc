/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */
// Remember to use the TIMER_PID function to remap the channel id to the
// actual AT91 timer channel

interface HplAT91OSTimer
{
  /**
   * Opens a timer channel for a given resolution such as TMilli. It will 
   * configure the timer channel to generate interrupts when the counter 
   * register matches the TC_RC register.
   */
   //TODO: Use parameter to describe tab instead of testing with milliseconds.
  async command bool open();
  
  /**
   * Get the current counter register value for the channel.
   */
  async command uint32_t getTCCV();
  
  /**
   * Get the current match register value for the channel. See TC_RC.
   */
  async command uint32_t getTCRC();

  /**
   * Set/initialize the match register for the channel.
   */
  async command void setTCRC(uint32_t val); 
  
  /**
   * Returns the RC compare status of the status register. See TC_SR.
   */
  async command bool getTCSR();
  
  /**
   * Sets the TC_IER bit corresponding to the timer match.
   */
  async command void setTCIER(bool flag);
  
  /**
   * Clear the interrupt.
   */
  async command void setICCR();
  
  /** 
   * Enable the interrupt.
   */ 
  async command void setIECR();
  
  /** 
   * Disable the interrupt.
   */
  async command void setIDCR();
  
  /**
   * Reset and start the counter. setTCRC should be called first.
   */
  async command void setSWTRG();
  
  /**
   * Fired.
   */
  async event void fired();

}
