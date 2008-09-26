configuration ConnMgrC
{
  provides
  {
    interface ConnMgr;
	interface ConnEnd;
	interface BeaconSig;
  }
}
implementation
{
  components Main, ConnMgrM, TimerC, XE1205RadioC as Radio, RadioComm as Comm, ObjLogC, NoLeds as Leds;

  Main.StdControl -> Comm.Control;
  Main.StdControl -> ConnMgrM.StdControl;
  Main.StdControl -> TimerC.StdControl;
  
  ConnMgr = ConnMgrM.ConnMgr;
  ConnEnd = ConnMgrM.ConnEnd;
  BeaconSig = ConnMgrM.BeaconSig;
  
  ConnMgrM.SampleTimer -> TimerC.Timer[unique("Timer")];
  ConnMgrM.DayTimer -> TimerC.Timer[unique("Timer")];
  ConnMgrM.RadioTimer -> TimerC.Timer[unique("Timer")];
  
  ConnMgrM.RadioControl -> Radio.StdControl;
  ConnMgrM.ObjLog -> ObjLogC.ObjLog[unique("ObjLog")];
  ConnMgrM.Leds -> Leds;
  ConnMgrM.XE1205Control -> Radio.XE1205Control;
  ConnMgrM.XE1205LPL -> Radio.XE1205LPL;
  ConnMgrM.CSMAControl ->   Radio.CSMAControl;
}
