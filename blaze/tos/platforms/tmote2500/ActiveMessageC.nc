
/**
 * This is a naming wrapper around the Blaze Radio Stack.
 * It also defines at least one default radio this platform uses by
 * including CC2500ControlC and/or CC1100ControlC
 *
 * @author Philip Levis
 * @author David Moss
 */

#include "CC2500.h"
#include "Blaze.h"

configuration ActiveMessageC {
  provides {
    interface SplitControl;
    interface SplitControl as BlazeSplitControl[radio_id_t id];

    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];

    interface Packet;
    interface AMPacket;
    interface PacketAcknowledgements;
    
    interface RadioSelect;
    interface PacketLink;
    interface BlazePacket;
    interface Csma[am_id_t id];
  }
}

implementation {

  components BlazeC;
  components CC2500ControlC;

  SplitControl = BlazeC.SplitControl;
  BlazeSplitControl = BlazeC.BlazeSplitControl;
  AMSend = BlazeC;
  Receive = BlazeC.Receive;
  Snoop = BlazeC.Snoop;
  Packet = BlazeC;
  AMPacket = BlazeC;
  PacketAcknowledgements = BlazeC;
  RadioSelect = BlazeC;
  PacketLink = BlazeC;
  BlazePacket = BlazeC;
  Csma = BlazeC;
  
}
