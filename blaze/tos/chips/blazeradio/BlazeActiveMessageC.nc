

#include "Blaze.h"

configuration BlazeActiveMessageC {
  provides {
    interface SplitControl;
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];
    interface AMPacket;
    interface Packet;
    interface BlazePacket;
    interface PacketAcknowledgements;
    
    //interface RadioSelect; ??
    //interface RadioBackoff[am_id_t amId];
    //interface LowPowerListening;
    //interface PacketLink;
  }
}

implementation {

  components BlazeActiveMessageP;
  Packet = BlazeActiveMessageP;
  AMSend = BlazeActiveMessageP;
  Receive = BlazeActiveMessageP.Receive;
  Snoop = BlazeActiveMessageP.Snoop;
  AMPacket = BlazeActiveMessageP;

  components BlazePacketC;
  BlazePacket = BlazePacketC;
  PacketAcknowledgements = BlazePacketC;
  BlazeActiveMessageP.BlazePacket -> BlazePacketC;
  BlazeActiveMessageP.BlazePacketBody -> BlazePacketC;
  
  components ActiveMessageAddressC;
  BlazeActiveMessageP.ActiveMessageAddress -> ActiveMessageAddressC;
  
  // SplitControl Layers
  components CC2500ControlC; // for now
  SplitControl = CC2500ControlC;  // for now
  
  // Send Layers
  components CsmaC;
  BlazeActiveMessageP.SubSend -> CsmaC.Send[ CC2500_RADIO_ID ];  // for now
  
  // Receive Layers
  components BlazeReceiveC;
  BlazeActiveMessageP.SubReceive -> BlazeReceiveC.Receive[ CC2500_RADIO_ID ]; // for now
  
  
}
