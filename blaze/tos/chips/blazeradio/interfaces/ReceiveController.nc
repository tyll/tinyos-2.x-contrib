
/**
 * @author David Moss
 */
interface ReceiveController {

  /** 
   * The RX interrupt fired.  Notify the module responsible for receiving
   * the packet to do its job.
   * @return SUCCESS if the packet will be read.  Receive MIGHT be signaled
   *     EBUSY if we're already servicing another request
   *     FAIL if we won't even try to read in the packet.
   */
  async command error_t beginReceive();
  
}

