
/**
 * This is a naming wrapper around the Blaze Radio Stack.
 * It also defines at least one default radio this platform uses by
 * including CC2500ControlC and/or CC1100ControlC
 *
 * @author Philip Levis
 * @author David Moss
 */

#include "CC1100.h"
#include "Blaze.h"

configuration ActiveMessageC {
  provides {
    interface SplitControl;

    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];
    interface SendNotifier[am_id_t amId];
    
    interface Packet;
    interface AMPacket;
    interface PacketAcknowledgements;
    
    interface BlazePacket;
    
    interface PacketLink;
    interface LowPowerListening;
    interface Csma[am_id_t id];
    
    /***************** Add-ons ****************
    interface AvailableRadios;
    interface RadioOnTime;
    interface PendingBit;
    interface PacketCount as TransmittedPacketCount;
    interface PacketCount as ReceivedPacketCount;
    interface PacketCount as OverheardPacketCount;
    */
    
  }
}

implementation {

  components BlazeC;
  components CC1100ControlC;
  components Ccxx00PlatformInitC;  
  
  SplitControl = BlazeC.SplitControl;
  AMSend = BlazeC;
  Receive = BlazeC.Receive;
  Snoop = BlazeC.Snoop;
  Packet = BlazeC;
  AMPacket = BlazeC;
  PacketAcknowledgements = BlazeC;
  PacketLink = BlazeC;
  BlazePacket = BlazeC;
  Csma = BlazeC;
  LowPowerListening = BlazeC;
  SendNotifier = BlazeC;
  
  /*
  components AvailableRadiosC;
  AvailableRadios = AvailableRadiosC;
  
  components RadioOnTimeC;
  RadioOnTime = RadioOnTimeC;
  
  components PacketStatsC;
  TransmittedPacketCount = PacketStatsC.TransmittedPacketCount;
  ReceivedPacketCount = PacketStatsC.ReceivedPacketCount;
  OverheardPacketCount = PacketStatsC.OverheardPacketCount;
  
  components PendingBitC;
  PendingBit = PendingBitC;
  */
  
}
