
/**
 * Used to notify BlazeInit to commit register changes for a particular radio
 * to hardware
 * @author David Moss
 */
 
interface BlazeCommit {

  /**
   * Only call commit() on the radio that is currently turned on.
   * The event commitDone() will always be signaled, so no return is necessary
   */
  command void commit();
  
  event void commitDone();
  
}

