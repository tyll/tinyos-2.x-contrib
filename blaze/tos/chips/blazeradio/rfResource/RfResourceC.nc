
configuration RfResourceC {

  provides interface AMSend[ am_id_t amId ];
  provides interface ChipSpiResource as RadioResource[ am_id_t amId ];
  
}

implementation {

  components RfResourceP;
  AMSend = RfResourceP;
  RadioResource = RfResourceP;
  
  components new StateC();
  RfResourceP.State -> StateC;
  
  components MainC;
  RfResourceP.Boot -> MainC;
  
  components new TimerMilliC();
  RfResourceP.TimeoutTimer -> TimerMilliC;
  
  components BlazePacketC;
  RfResourceP.BlazePacket -> BlazePacketC;
  
  components ActiveMessageC;
  RfResourceP.SubSend -> ActiveMessageC;
  RfResourceP.SplitControl -> ActiveMessageC.BlazeSplitControl;
  
  components LedsC;
  RfResourceP.Leds -> LedsC;
  
  components DebugPinsC;
  RfResourceP.Pins -> DebugPinsC;

}


