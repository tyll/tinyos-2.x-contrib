
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
    
  }
}

implementation {
  
  components BlazeActiveMessageC;
  AMSend = BlazeActiveMessageC;
  Receive = BlazeActiveMessageC.Receive;
  Snoop = BlazeActiveMessageC.Snoop;
  AMPacket = BlazeActiveMessageC;
  Packet = BlazeActiveMessageC;
  
  components RadioSelectC;
  RadioSelect = RadioSelectC;
  
  components BlazePacketC;
  BlazePacket = BlazePacketC;
  
  components PacketLinkC;
  PacketLink = PacketLinkC;
  
  components AcknowledgementsC;
  PacketAcknowledgements = AcknowledgementsC;
  
  components CsmaC;
  Csma = CsmaC;
  
  components BlazeInitC;
  SplitControl = BlazeInitC.SplitControl[0];
  BlazeSplitControl = BlazeInitC.SplitControl;
  
  components UniqueSendC;
  components UniqueReceiveC;
  components BlazeReceiveC;
  
  /***************** Send Layers ****************/
  BlazeActiveMessageC.SubSend -> UniqueSendC.Send;
  UniqueSendC.SubSend -> PacketLinkC.Send;
  PacketLinkC.SubSend -> RadioSelectC;
  /* Layers below this are parameterized by radio id */
  RadioSelectC.SubSend -> AcknowledgementsC.Send;
  AcknowledgementsC.SubSend -> CsmaC;
  
  /***************** Receive Layers ****************/
  BlazeActiveMessageC.SubReceive -> UniqueReceiveC.Receive;
  UniqueReceiveC.SubReceive -> RadioSelectC.Receive;
  /* Layers below this are parameterized by radio id */
  RadioSelectC.SubReceive -> BlazeReceiveC.Receive;
    
}

