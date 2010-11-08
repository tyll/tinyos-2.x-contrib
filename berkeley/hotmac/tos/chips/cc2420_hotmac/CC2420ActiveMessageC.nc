/**
 * AM layer on top of HotMAC
 *
 * Snooping is included for compatibility, but it is not supported.
 *
 * @author Stephen Dawson-Haggerty
 * @version $Revision$ $Date$
 */

#include "CC2420.h"
#include "AM.h"

configuration CC2420ActiveMessageC {
  provides {
    interface SplitControl;
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];

    interface AMPacket;
    interface Packet;
    interface CC2420Packet;
    interface PacketAcknowledgements;
    interface LinkPacketMetadata;
    interface PacketLink;
    interface SendNotifier[am_id_t id];

    /* dummy interface so we build against core */
    interface LowPowerListening;
  }
}
implementation {

  components CC2420ActiveMessageP as AM;
  components ActiveMessageAddressC;
  components CC2420PacketC;
  components CC2420ControlC;
  components HotmacC as Mac;
  
  Packet = AM;
  AMSend = AM;
  Receive = AM.Receive;
  Snoop = AM.Snoop;
  AMPacket = AM;
  PacketLink = Mac;
  CC2420Packet = CC2420PacketC;
  PacketAcknowledgements = CC2420PacketC;
  LinkPacketMetadata = CC2420PacketC;
  SendNotifier = AM;

  // SplitControl Layers
  SplitControl = Mac;
  
  // Send Layers
  AM.SubSend -> Mac;
  
  // Receive Layers
  AM.SubReceive -> Mac;

  AM.ActiveMessageAddress -> ActiveMessageAddressC;
  AM.CC2420Packet -> CC2420PacketC;
  AM.CC2420PacketBody -> CC2420PacketC;
  AM.CC2420Config -> CC2420ControlC;

  components DummyLplC;
  LowPowerListening = DummyLplC;
}
