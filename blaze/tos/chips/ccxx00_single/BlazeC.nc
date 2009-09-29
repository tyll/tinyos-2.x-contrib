/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * Main entry point and wiring of all layers for the Blaze Radio.
 * The platform's ActiveMessageC.nc should define at least one primary radio the 
 * platform contains.  Radios can be added in by including either
 * CC1100ControlC or CC2500ControlC in any configuration file included
 * at compile time.
 * @author David Moss
 */
 
#include "Blaze.h"
#include "message.h"
#include "RadioStackPacket.h"


configuration BlazeC {

  provides {
    /** Turn the default radio on and off, backwards compatible */
    interface SplitControl;
    
    /** Send a packet */
    interface AMSend[am_id_t amId];
    
    /** Notification that a packet is about to be transmitted */
    interface SendNotifier[am_id_t amId];
    
    /** Receive a packet */
    interface Receive[am_id_t amId];
    
    /** Sniff packets that don't belong to our node */
    interface Receive as Snoop[am_id_t amId];
    
    /** Get source / destination / etc. properties for a packet */
    interface AMPacket;
    
    /** Get payload information about a packet */
    interface Packet;

    /** Access internal Blaze-specific properties of a packet */
    interface BlazePacket;
    
    /** Layer 2 packet link functionality, more reliable transmissions */
    interface PacketLink;
    
    /** Request and check acknowledgements */
    interface PacketAcknowledgements;
    
    /** Configure CSMA properties, like backoff and clear channel assessments */
    interface Csma[am_id_t amId];
    
    /** Configure the initial backoff for CSMA */
    interface Backoff as InitialBackoff[am_id_t amId];
    
    /** Configure the congestion backoff for CSMA */
    interface Backoff as CongestionBackoff[am_id_t amId];
    
    /** Configure low power listening settings */
    interface LowPowerListening;
    
    /** Configure the system-wide low power listening settings */
    interface SystemLowPowerListening;
    
    /** Traffic Control to avoid network congestion */
    interface TrafficControl;
    
    /** Traffic Priority to give some packets faster access to the channel */
    interface TrafficPriority[am_id_t amId];
    
    /** CTP Required Interface */
    interface LinkPacketMetadata;
    
    /** AckSendNotifier Interface to change the ack being sent */
    interface AckSendNotifier[am_addr_t destination];
    
    
    /***************** Multiple Radio Options ****************/
    /** Multiple Radio Split Control */
    interface SplitControl as BlazeSplitControl[radio_id_t radioId];
    
    /** Radio Select, used for a multiple radio CCxx00 driver option */
    interface RadioSelect;
  }
}

implementation {
  
  components BlazeActiveMessageC;
  AMPacket = BlazeActiveMessageC;
  Packet = BlazeActiveMessageC;
  SendNotifier = BlazeActiveMessageC;
  LinkPacketMetadata = BlazeActiveMessageC;
  
  components RadioSelectC;
  BlazeSplitControl = RadioSelectC;
  RadioSelect = RadioSelectC;
  
  components BlazePacketC;
  BlazePacket = BlazePacketC;
  
  components PacketLinkC;
  PacketLink = PacketLinkC;
  
  components LplC;
  LowPowerListening = LplC;
  SystemLowPowerListening = LplC;
  
  components AcknowledgementsC;
  PacketAcknowledgements = AcknowledgementsC;
  
  components CsmaC;
  Csma = CsmaC;
  InitialBackoff = CsmaC.InitialBackoff;
  CongestionBackoff = CsmaC.CongestionBackoff;
  
  components BlazeReceiveC;
  AckSendNotifier = BlazeReceiveC.AckSendNotifier;
  
  components TrafficControlC;
  TrafficControl = TrafficControlC;
  TrafficPriority = TrafficControlC;
  
  components SplitControlManagerC;
  components Ccxx00PowerManagerC;
  components UniqueReceiveC;
  components BlazeInitC;
  components BlazeTransmitC;
  components Ccxx00PlatformInitC;
  
  /***************** Send Layers ****************/
  AMSend = BlazeActiveMessageC;
  BlazeActiveMessageC.SubSend -> TrafficControlC.Send;
  TrafficControlC.SubSend -> RadioSelectC.Send;
  RadioSelectC.SubSend -> SplitControlManagerC.Send;
  SplitControlManagerC.SubSend -> PacketLinkC.Send;
  PacketLinkC.SubSend -> LplC.Send;
  LplC.SubSend -> AcknowledgementsC.Send;
  AcknowledgementsC.SubSend -> CsmaC;
  
  /***************** Receive Layers ****************/
  Receive = BlazeActiveMessageC.Receive;
  Snoop = BlazeActiveMessageC.Snoop;
  BlazeActiveMessageC.SubReceive -> RadioSelectC.Receive;
  RadioSelectC.SubReceive -> UniqueReceiveC.Receive;
  UniqueReceiveC.SubReceive -> LplC.Receive;
  LplC.SubReceive -> BlazeReceiveC.Receive;
    
  /***************** SplitControl Layers ****************/
  SplitControl = RadioSelectC.SplitControl;
  RadioSelectC.SubControl -> SplitControlManagerC.SplitControl;
  SplitControlManagerC.SubControl -> LplC.SplitControl;
  LplC.SubControl -> Ccxx00PowerManagerC.SplitControl;
  
}
