
/**
 * Interface to request and specify backoff periods for messages
 * @author David Moss
 */
 
interface RadioBackoff {

  /**
   * Must be called within a requestInitialBackoff event
   * @param backoffTime the amount of time in some unspecified units to backoff
   */
  async command void setInitialBackoff(uint16_t backoffTime);
  
  /**
   * Must be called within a requestCongestionBackoff event
   * @param backoffTime the amount of time in some unspecified units to backoff
   */
  async command void setCongestionBackoff(uint16_t backoffTime);
  
  
  /**
   * Must be called within a requestLplBackoff event
   * @param backoffTime the amount of time in some unspecified units to backoff
   */
  async command void setLplBackoff(uint16_t backoffTime);



  /**  
   * Request for input on the initial backoff
   * @param msg pointer to the message being sent
   */
  async event void requestInitialBackoff(message_t *msg);
  
  /**
   * Request for input on the congestion backoff
   * @param msg pointer to the message being sent
   */
  async event void requestCongestionBackoff(message_t *msg);
  
  /**
   * Request for input on the low power listening backoff
   * This should be somewhat random, but as short as possible
   * @param msg pointer to the message being sent
   */
  async event void requestLplBackoff(message_t *msg);
  
}

