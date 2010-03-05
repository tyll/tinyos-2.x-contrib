interface BcpSendQueueForwarderIF{
  /**
   * Returns the total delay residing in the
   *  forwarding queue.  This includes all packet
   *  delay and the amount of Orphaned delay
   *  residing in the forwarding queue.
   *
   * @return the total delay in the forwarding queue
   */  
  command uint32_t getTotalDelay();
    
  /**
   * Removes up to MAX_FWD_DLY units of delay from the
   *  delay queue and returns it to caller, to be placed
   *  within the delayTransfer field of a packet header.
   */
  command uint32_t delayQueueService(uint8_t count_p);

  /**
   * Adds delay to the delay queue, arrived via a data
   *  packet or a delay packet.  Returns current total delay.
   */
  command uint32_t delayQueueArrival(uint32_t arrivalDelay_p);
}
