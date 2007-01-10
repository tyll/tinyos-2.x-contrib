
/**
 * @author David Moss
 * @author Jon Wyant
 */

interface MessageTransport {

  /**
   * Set the maximum number of times attempt message delivery
   * Default is 0
   * @param msg
   * @param maxRetries the maximum number of attempts to deliver
   *     the message
   */
  command void setRetries(message_t *msg, uint16_t maxRetries);

  /**
   * Set a delay between each retry attempt
   * @param msg
   * @param retryDelay the delay betweeen retry attempts, in milliseconds
   */
  command void setRetryDelay(message_t *msg, uint16_t retryDelay);

  /** 
   * @return the maximum number of retry attempts for this message
   */
  command uint16_t getRetries(message_t *msg);

  /**
   * @return the delay between retry attempts in ms for this message
   */
  command uint16_t getRetryDelay(message_t *msg);

  /**
   * @return TRUE if the message was delivered.
   *     This should always be TRUE if the message was sent to the
   *     AM_BROADCAST_ADDR
   */
  command bool wasDelivered(message_t *msg);

}


