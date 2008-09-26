

configuration Beacon
{
	provides
	{
		interface StdControl;
		interface IBeacon;
	}
}
implementation
{
	components BeaconM, RadioComm, TimerC, ConnMgrC, NoLeds as Leds, RandomLFSR;
  StdControl = TimerC.StdControl;
  StdControl = BeaconM.StdControl;
  
  
  
  IBeacon = BeaconM.IBeacon;
  
  BeaconM.Timer -> TimerC.Timer[unique("Timer")];
  BeaconM.LockTimer -> TimerC.Timer[unique("Timer")];
  BeaconM.SendMsg -> RadioComm.SendMsg[AM_BEACONMSG];
  BeaconM.ReceiveMsg -> RadioComm.ReceiveMsg[AM_OFFERMSG];
  BeaconM.PreSendMsg -> RadioComm.SendMsg[AM_PREDATA];
  BeaconM.ConnMgr -> ConnMgrC.ConnMgr;
  BeaconM.Leds -> Leds;
  BeaconM.Random -> RandomLFSR.Random;
  
}
