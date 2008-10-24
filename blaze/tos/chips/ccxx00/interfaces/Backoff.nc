
/**
 * Interface to request and specify backoff periods for messages
 * 
 * We use a call back method for setting the backoff as opposed to 
 * events that return backoff values.  
 * 
 * This is because of fan-out issues with multiple components wanting to
 * affect backoffs for whatever they're interested in:
 * If you signal out an *event* to request an initial backoff and
 * several components happen to be listening, then those components
 * would be required to return a backoff value.  We don't want that
 * behavior.
 
 * With this strategy, components can listen for the requests and then
 * decide if they want to affect the behavior.  If the component wants to
 * affect the behavior, it calls back using the setXYZBackoff(..) command.
 * If several components call back, then the last component to get its 
 * word in has the final say. 
 *
 * @author David Moss
 */

interface Backoff {

  /**
   * Set the backoff of the particular event. This must be called
   * within the requestBackoff() event, otherwise it will be ignored.
   * @param backoffTime the amount of time to backoff, in a uint32_t
   *     alarm.
   */
  async command void setBackoff(uint16_t backoffTime);
  
  /**  
   * Request for input on the backoff
   * Reply using setBackoff(..)
   * @param msg pointer to the message being sent
   */
  async event void requestBackoff(message_t *msg);
  
}
