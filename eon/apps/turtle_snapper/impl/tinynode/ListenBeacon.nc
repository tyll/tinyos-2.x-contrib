configuration ListenBeacon
{
  provides
  {
    interface StdControl;
    interface IListenBeacon;
  }
}
implementation
{
  components ListenBeaconM, RadioComm, ConnMgrC, NoLeds as Leds, TimerC;
  components GoodMorning, RandomLFSR;
  
  StdControl = ListenBeaconM.StdControl;
  IListenBeacon = ListenBeaconM.IListenBeacon;
  StdControl = RadioComm;
  
  ListenBeaconM.ReceiveMsg -> RadioComm.ReceiveMsg[AM_BEACONMSG];
  ListenBeaconM.ReceiveActivateMsg -> RadioComm.ReceiveMsg[AM_ACTIVATEMSG];
  ListenBeaconM.SendMsg -> RadioComm.SendMsg[AM_STATUSMSG];
  ListenBeaconM.ConnMgr -> ConnMgrC.ConnMgr;
  ListenBeaconM.Leds -> Leds;
  ListenBeaconM.ActivateTimer -> TimerC.Timer[unique("Timer")];
  
  ListenBeaconM.Calib -> GoodMorning.Calib;
  ListenBeaconM.Random -> RandomLFSR.Random;
}
