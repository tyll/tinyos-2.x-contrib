interface PacketQuality
{
  /**
   * Get rssi value for a given packet. For received packets, it is
   * the received signal strength when receiving that packet. For sent
   * packets, it is the received signal strength of the ack if an ack
   * was received.
   */
  async command int8_t getRssi( message_t* p_msg );
}
