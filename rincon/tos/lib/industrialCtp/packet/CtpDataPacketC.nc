
/**
 * @author Philip Levis
 * @author Kyle Jamieson
 * @author David Moss
 */
 
configuration CtpDataPacketC {
  provides {
    interface CtpPacket;
    interface Packet;
  }
}

implementation {

  components CtpDataPacketP;
  CtpPacket = CtpDataPacketP;
  Packet = CtpDataPacketP.Packet;
  
  components ActiveMessageC;
  CtpDataPacketP.SubPacket -> ActiveMessageC.Packet;
  
}

