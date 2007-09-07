
configuration BlazePacketC {
  provides {
    interface BlazePacket;
    interface BlazePacketBody;
    interface PacketAcknowledgements;
  }
}

implementation {
  components BlazePacketP;
  BlazePacket = BlazePacketP;
  PacketAcknowledgements = BlazePacketP;
  BlazePacketBody = BlazePacketP;
}

