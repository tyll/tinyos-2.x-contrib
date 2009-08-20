
configuration PacketStatsC {
  provides {
    /** Stats: Total number of packets transmitted by this node */
    interface PacketCount as TransmittedPacketCount;
    
    /** Stats: Total number of packets received by this node */
    interface PacketCount as ReceivedPacketCount;
    
    /** Stats: Total number of packets overheard by this node */
    interface PacketCount as OverheardPacketCount;
    
  }
}

implementation {

  components PacketStatsP;
  TransmittedPacketCount = PacketStatsP.TransmittedPacketCount;
  ReceivedPacketCount = PacketStatsP.ReceivedPacketCount;
  OverheardPacketCount = PacketStatsP.OverheardPacketCount;
  
  components BlazeActiveMessageP;
  PacketStatsP.AMSend -> BlazeActiveMessageP;
  PacketStatsP.Receive -> BlazeActiveMessageP.Receive;
  PacketStatsP.Snoop -> BlazeActiveMessageP.Snoop;
  
}
