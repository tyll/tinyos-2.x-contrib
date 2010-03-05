interface BcpDebugIF{
  /**
   * Notifies upper layer of a change to the local
   *  backpressure level.
   */
  command void reportBackpressure(uint32_t dataQueueSize_p, uint32_t virtualQueueSize_p, uint16_t localTXCount_p, uint8_t origin_p, uint8_t originSeqNo_p, uint8_t reportSource_p);

  /**
   * Notifies the application layer of an error
   */
  command void reportError( uint8_t type_p );

  /**
   * Notifies upper layer of an update to the estimated link transmission time
   */
  command void reportLinkRate(uint8_t neighbor_p, uint16_t previousLinkPacketTxTime_p, 
                              uint16_t updateLinkPacketTxTime_p, uint16_t newLinkPacketTxTime,
                              uint16_t latestLinkPacktLossEst);

  /**
   * Used to debug
   */
  command void reportValues(uint32_t field1_p, uint32_t field2_p, uint32_t field3_p, uint16_t field4_p, 
                              uint16_t field5_p, uint16_t field6_p, uint8_t field7_p, uint8_t field8_p);
}
