
/**
 * Used to notify BlazeInit to commit register changes for a particular radio
 * to hardware
 * @author David Moss
 */
 
interface BlazeCommit {

  /**
   * Commit changes made to a radio's registers stored in RAM on the 
   * microcontroller to the radio. 
   */
  command error_t commit();
  
  event void commitDone();
  
}

