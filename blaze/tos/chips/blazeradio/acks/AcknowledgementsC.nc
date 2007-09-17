
#include "Blaze.h"

/**
 * This layer combines the Send command with the AckReceive event
 * from the asynchronous portion of the receive stack.  It also provides
 * the PacketAcknowledgement interface
 *
 * Above this layer, nothing should be asynchronous context
 * 
 * @author David Moss
 */
configuration AcknowledgementsC {
  provides {
    interface Send[radio_id_t id];
    interface PacketAcknowledgements;
  }
}

implementation {

  components AcknowledgementsP;
  Send = AcknowledgementsP;
  PacketAcknowledgements = AcknowledgementsP;
 
  components CsmaC;
  AcknowledgementsP.SubSend -> CsmaC;
  
  components BlazeSpiC;
  AcknowledgementsP.ChipSpiResource -> BlazeSpiC;
  
  components BlazePacketC;
  AcknowledgementsP.BlazePacketBody -> BlazePacketC;
  
  components AlarmMultiplexC;
  AcknowledgementsP.AckWaitTimer -> AlarmMultiplexC;
  
  components BlazeReceiveC;
  AcknowledgementsP.AckReceive -> BlazeReceiveC;
  
  components LedsC;
  AcknowledgementsP.Leds -> LedsC;
  
}
