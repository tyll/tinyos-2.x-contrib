configuration ListenBeaconBase
{
  provides
  {
    interface StdControl;
    interface IListenBeaconBase;
  }
}
implementation
{
  components ListenBeaconBaseM, RadioComm, ConnMgrC, NoLeds as Leds, TimerC;
  components RandomLFSR;
  
  StdControl = ListenBeaconBaseM.StdControl;
  IListenBeaconBase = ListenBeaconBaseM.IListenBeaconBase;
  StdControl = RadioComm;
  
  ListenBeaconBaseM.ReceiveMsg -> RadioComm.ReceiveMsg[AM_BEACONMSG];
  ListenBeaconBaseM.ReceiveActivateMsg -> RadioComm.ReceiveMsg[AM_ACTIVATEMSG];
  ListenBeaconBaseM.SendMsg -> RadioComm.SendMsg[AM_STATUSMSG];
  ListenBeaconBaseM.ConnMgr -> ConnMgrC.ConnMgr;
  ListenBeaconBaseM.Leds -> Leds;
  ListenBeaconBaseM.ActivateTimer -> TimerC.Timer[unique("Timer")];
  
  ListenBeaconBaseM.Random -> RandomLFSR.Random;
}
