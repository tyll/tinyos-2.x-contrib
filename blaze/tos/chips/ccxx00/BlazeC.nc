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
 
configuration BlazeC {

  provides {
    /** Turn the default radio on and off, backwards compatible */
    interface SplitControl;
    
    /** Turn a specific radio on and off, for use with dual radio platforms */
    interface SplitControl as BlazeSplitControl[ radio_id_t radioId ];
    
    /** Select the radio to use for sending a packet */
    interface RadioSelect;
    
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
    
    /** Configure low power listening for the default radio */
    interface LowPowerListening;
    
    /** Configure low power listening for any blaze radio */
    interface LowPowerListening as BlazeLowPowerListening[ radio_id_t radioId ];
    
    /** CTP Required Interface */
    interface LinkPacketMetadata;
    
    /** Stats: Find out how long any radio has been turned on in any state */
    interface RadioOnTime;
    
    /** Stats: Total number of packets transmitted by this node */
    interface PacketCount as TransmittedPacketCount;
    
    /** Stats: Total number of packets received by this node */
    interface PacketCount as ReceivedPacketCount;
    
    /** Stats: Total number of packets overheard by this node */
    interface PacketCount as OverheardPacketCount;
  }
}

implementation {
  
  components BlazeActiveMessageC;
  AMSend = BlazeActiveMessageC;
  Receive = BlazeActiveMessageC.Receive;
  Snoop = BlazeActiveMessageC.Snoop;
  AMPacket = BlazeActiveMessageC;
  Packet = BlazeActiveMessageC;
  SendNotifier = BlazeActiveMessageC;
  LinkPacketMetadata = BlazeActiveMessageC;
  
  components RadioSelectC;
  RadioSelect = RadioSelectC;
  
  components BlazePacketC;
  BlazePacket = BlazePacketC;
  
  components PacketLinkC;
  PacketLink = PacketLinkC;
  
  components LplC;
  LowPowerListening = LplC.LowPowerListening[0];
  BlazeLowPowerListening = LplC;
  
  components AcknowledgementsC;
  PacketAcknowledgements = AcknowledgementsC;
  
  components CsmaC;
  Csma = CsmaC;
  InitialBackoff = CsmaC.InitialBackoff;
  CongestionBackoff = CsmaC.CongestionBackoff;
  
  components SplitControlManagerC;
  components Ccxx00PowerManagerC;
  
  components UniqueSendC;
  components UniqueReceiveC;

  components BlazeReceiveC;
  components BlazeInitC;
  components BlazeTransmitC;
  
  /***************** Send Layers ****************/
  BlazeActiveMessageC.SubSend -> UniqueSendC.Send;
  UniqueSendC.SubSend -> PacketLinkC.Send;
  PacketLinkC.SubSend -> RadioSelectC.Send;
  
  /* Layers below this are parameterized by radio id */
  RadioSelectC.SubSend -> SplitControlManagerC.Send;
  SplitControlManagerC.SubSend -> LplC.Send;
  LplC.SubSend -> AcknowledgementsC.Send;
  AcknowledgementsC.SubSend -> CsmaC;
  
  /***************** Receive Layers ****************/
  BlazeActiveMessageC.SubReceive -> UniqueReceiveC.Receive;
  UniqueReceiveC.SubReceive -> RadioSelectC.Receive;
  
  /* Layers below this are parameterized by radio id */
  RadioSelectC.SubReceive -> LplC.Receive;
  LplC.SubReceive -> BlazeReceiveC.Receive;
    
  /***************** SplitControl Layers ****************/
  SplitControl = SplitControlManagerC.SplitControl[0];
  BlazeSplitControl = SplitControlManagerC.SplitControl;
  SplitControlManagerC.SubControl -> LplC.SplitControl;
  LplC.SubControl -> Ccxx00PowerManagerC.SplitControl;
  
  
  /***************** Radio Statistics and Usage Collection ****************/
  RadioOnTime = BlazeInitC;
  ReceivedPacketCount = BlazeReceiveC.ReceivedPacketCount;
  OverheardPacketCount = BlazeReceiveC.OverheardPacketCount;
  TransmittedPacketCount = BlazeTransmitC.TransmittedPacketCount;
  
}

