
configuration CtpRoutingPacketC {
  provides {
    interface CtpRoutingPacket;
  }
}

implementation {
  
  components CtpRoutingPacketP;
  CtpRoutingPacket = CtpRoutingPacketP;
  
  components ActiveMessageC;
  CtpRoutingPacketP.Packet -> ActiveMessageC;
  
}
