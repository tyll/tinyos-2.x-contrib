interface BcpRouterSendQueueIF{
  /**
   * In order for the routing engine to compute differential backlog,
   *  access is provided to the local backpressure value.
   *
   * @return local backpressure value.
   */
  event uint32_t getBackpressure();
  
  /**
   * Change in local queue size, may need to update routing decisions.
   */
  command void updateLocalBackpressure( uint32_t backpressure_p );  
}
