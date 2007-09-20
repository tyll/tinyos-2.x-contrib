

#include "Blaze.h"

/**
 * Active Message Layer
 * @author David Moss
 */
 
configuration BlazeActiveMessageC {
  provides {
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];
    interface AMPacket;
    interface Packet;
  }
  
  uses {
    interface Send as SubSend;
    interface Receive as SubReceive;
  }
}

implementation {

  components BlazeActiveMessageP;
  AMSend = BlazeActiveMessageP.AMSend;
  Receive = BlazeActiveMessageP.Receive;
  Snoop = BlazeActiveMessageP.Snoop;
  AMPacket = BlazeActiveMessageP.AMPacket;
  Packet = BlazeActiveMessageP.Packet;
    
  SubSend = BlazeActiveMessageP.SubSend;
  SubReceive = BlazeActiveMessageP.SubReceive;
  
  components BlazePacketC;
  BlazeActiveMessageP.BlazePacket -> BlazePacketC;
  BlazeActiveMessageP.BlazePacketBody -> BlazePacketC;
  
  components RadioSelectC;
  BlazeActiveMessageP.RadioSelect -> RadioSelectC;
  
  components ActiveMessageAddressC;
  BlazeActiveMessageP.ActiveMessageAddress -> ActiveMessageAddressC;
  
}
