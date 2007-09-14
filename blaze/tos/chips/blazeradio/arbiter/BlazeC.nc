configuration BlazeC {

  provides interface RadioSelect;
  provides interface Send;
  provides interface Receive;
  
}

implementation {
  
  components BlazeP;
  RadioSelect = BlazeP;
  Send = BlazeP;
  Receive = BlazeP;
  
  components MainC;
  MainC.SoftwareInit -> BlazeP.InitModule;
  
  //components RadioStubC;
  //BlazeP.CC2500Control -> RadioStubC;
  //BlazeP.CC2500ReceiveInterrupt -> RadioStubC.Interrupt;
  //BlazeP.CC2500Receive -> RadioStubC;
  //BlazeP.CC2500Send -> RadioStubC;
  
  components CC1100ControlC;
  BlazeP.CC1100Control -> CC1100ControlC;
  BlazeP.CC1100State -> CC1100ControlC;
  
  components CC2500ControlC;
  BlazeP.CC2500Control -> CC2500ControlC;
  BlazeP.CC2500State -> CC2500ControlC;
  
  components HplCC1100PinsC as Pins;
  
  components new BlazeTransmitC() as CC1100Transmit;
  BlazeP.CC1100Send -> CC1100Transmit;
  CC1100Transmit.Csn -> Pins.Csn;
  
  components new BlazeTransmitC() as CC2500Transmit;
  BlazeP.CC2500Send -> CC2500Transmit;  
  CC2500Transmit.Csn -> Pins.Csn;
  
  components new BlazeReceiveC() as CC1100Receive;
  BlazeP.CC1100Receive -> CC1100Receive;
  BlazeP.CC1100ReceiveInterrupt -> Pins.Gdo2_int;
  CC1100Receive.Csn -> Pins.Csn;
  
  components new BlazeReceiveC() as CC2500Receive;
  BlazeP.CC2500Receive -> CC2500Receive;
  BlazeP.CC2500ReceiveInterrupt -> Pins.Gdo2_int;
  CC2500Receive.Csn -> Pins.Csn;
  
  components BlazePacketC;
  BlazeP.BlazePacket -> BlazePacketC;
  
  components BlazeSpiC;
  BlazeP.Resource -> BlazeSpiC;
  
  components new StateC();
  BlazeP.State -> StateC;
  
  components new TimerMilliC();
  BlazeP.TimeoutTimer -> TimerMilliC;
  
  components LedsC;
  BlazeP.Leds -> LedsC;
    
}

