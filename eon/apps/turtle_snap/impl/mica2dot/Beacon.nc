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
	components BeaconM, RadioComm, TimerC, CC1000RadioIntM as Radio;
	//InfoStoreC, 
#ifdef TEST_BEACON
	components LedsC as Leds;
#else
	components NoLeds as Leds;
#endif

  StdControl = TimerC.StdControl;
  StdControl = BeaconM.StdControl;
  StdControl = RadioComm.Control;
  
  //StdControl = InfoStoreC;
  
  IBeacon = BeaconM.IBeacon;
  

  BeaconM.Timer -> TimerC.Timer[unique("Timer")];
  BeaconM.SendMsg -> RadioComm.SendMsg[AM_BEACONMSG];
  BeaconM.Leds -> Leds;
  BeaconM.SetListeningMode -> Radio.SetListeningMode;
  BeaconM.GetListeningMode -> Radio.GetListeningMode;
  //BeaconM.InfoStore -> InfoStoreC;
}
