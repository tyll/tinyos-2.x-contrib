
interface TrafficPriority {

  /**
   * Users must call back using the setPriority() command within the event.
   *  
   * @param msg The message being sent
   * @param destination The destination address of the message
   */
  event void requestPriority(am_addr_t destination, message_t *msg);
  
  /** 
   * This may only be called within the requestPriority() event, otherwise
   * it has no effect.  If you do not call it, the packet will be sent with
   * default priority
   */
  command void highPriority();
  
}

