
/**
 * Get access to internals of a packet used in the Blaze radio stack
 * @author David Moss
 */
 
configuration BlazePacketC {
  provides {
    interface BlazePacket;
    interface BlazePacketBody;
  }
}

implementation {

  components BlazePacketP;
  BlazePacket = BlazePacketP;
  BlazePacketBody = BlazePacketP;
  
}

