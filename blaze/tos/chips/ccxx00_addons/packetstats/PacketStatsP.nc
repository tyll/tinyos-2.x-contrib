
module PacketStatsP {
  provides {
    /** Stats: Total number of packets transmitted by this node */
    interface PacketCount as TransmittedPacketCount;
    
    /** Stats: Total number of packets received by this node */
    interface PacketCount as ReceivedPacketCount;
    
    /** Stats: Total number of packets overheard by this node */
    interface PacketCount as OverheardPacketCount;
    
  }
  
  uses {
    interface AMSend[am_id_t amId];
    interface Receive[am_id_t amId];
    interface Receive as Snoop[am_id_t amId];
  }
}

implementation {

  uint32_t transmittedPackets;
  uint32_t receivedPackets;
  uint32_t overheardPackets;
  
  
  /***************** PacketCount Commands **************/
  command uint32_t TransmittedPacketCount.getTotal() {
    return transmittedPackets;
  }
  
  command uint32_t ReceivedPacketCount.getTotal() {
    return receivedPackets;
  }
  
  command uint32_t OverheardPacketCount.getTotal() {
    return overheardPackets;
  }
  
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive[am_id_t amId](message_t *msg, void *payload, uint8_t len) {
    receivedPackets++;
    return msg;
  }

  event message_t *Snoop.receive[am_id_t amId](message_t *msg, void *payload, uint8_t len) {
    overheardPackets++;
    return msg;
  }
  

  /***************** AMSend Events ****************/
  event void AMSend.sendDone[am_id_t amId](message_t *msg, error_t error) {
    transmittedPackets++;
  }  
  
}

