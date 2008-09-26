configuration UnitTestBeacon
{
  provides
  {
    interface StdControl;
    interface UnitTest;
  }
}
implementation
{
  components UnitTestBeaconM, BeaconM, TimerC, NoLeds as Leds;

  StdControl = UnitTestBeaconM.StdControl;
  StdControl = BeaconM.StdControl;
  StdControl = TimerC.StdControl;
  UnitTest = UnitTestBeaconM.UnitTest;
  
  UnitTestBeaconM.IBeacon -> BeaconM.IBeacon;

  BeaconM.Timer -> TimerC.Timer[unique("Timer")];
  UnitTestBeaconM.Timer -> TimerC.Timer[unique("Timer")];
  
  BeaconM.SendMsg -> UnitTestBeaconM.SendMsg;
  BeaconM.VersionStore -> UnitTestBeaconM.VersionStore;
  BeaconM.Leds -> Leds;
}
