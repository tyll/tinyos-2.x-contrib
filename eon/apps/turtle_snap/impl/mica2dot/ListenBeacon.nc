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
  components ListenBeaconM, RadioComm, TimerC;

  StdControl = ListenBeaconM.StdControl;
  IListenBeacon = ListenBeaconM.IListenBeacon;
  
  StdControl = RadioComm;
  StdControl = TimerC;
  
  ListenBeaconM.Timer -> TimerC.Timer[unique("Timer")];
  ListenBeaconM.ReceiveMsg -> RadioComm.ReceiveMsg[AM_BEACONMSG];
  
  
}
