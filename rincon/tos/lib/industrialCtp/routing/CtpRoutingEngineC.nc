
configuration CtpRoutingEngineC {
  provides {
    interface StdControl;
    interface UnicastNameFreeRouting;
    interface RootControl;
    interface CtpInfo;
    interface CtpRoutingPacket;
    interface CompareBit;
  }
}

implementation {

  components CtpRoutingEngineP;
  StdControl = CtpRoutingEngineP;
  UnicastNameFreeRouting = CtpRoutingEngineP;
  RootControl = CtpRoutingEngineP;
  CtpInfo = CtpRoutingEngineP;
  CompareBit = CtpRoutingEngineP;
  
  components CtpRoutingPacketC;
  CtpRoutingPacket = CtpRoutingPacketC;
  CtpRoutingEngineP.CtpRoutingPacket -> CtpRoutingPacketC;
  
  components MainC;
  MainC.SoftwareInit -> CtpRoutingEngineP;
  
  components LinkEstimatorC;
  CtpRoutingEngineP.BeaconSend -> LinkEstimatorC;
  CtpRoutingEngineP.BeaconReceive -> LinkEstimatorC;
  CtpRoutingEngineP.LinkEstimator -> LinkEstimatorC;
  
  components CtpForwardingEngineC;
  CtpRoutingEngineP.CtpCongestion -> CtpForwardingEngineC;
  
  components ActiveMessageC;
  CtpRoutingEngineP.AMPacket -> ActiveMessageC;
  CtpRoutingEngineP.RadioSplitControl -> ActiveMessageC;
  
  components new TimerMilliC() as RoutingBeaconTimerC;
  CtpRoutingEngineP.BeaconTimer -> RoutingBeaconTimerC;
  
  components new TimerMilliC() as RouteUpdateTimerC;
  CtpRoutingEngineP.RouteTimer -> RouteUpdateTimerC;
  
  components RandomC;
  CtpRoutingEngineP.Random -> RandomC;
    
}
