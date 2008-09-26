configuration UnitTestGPS
{
  provides
  {
    interface StdControl;
    interface UnitTest;
  }
}
implementation
{
  components UnitTestGPSM, GetGPSM, TimerC;

  StdControl = UnitTestGPSM.StdControl;
  StdControl = GetGPSM.StdControl;
  StdControl = TimerC.StdControl;
  UnitTest = UnitTestGPSM.UnitTest;
  
  UnitTestGPSM.IGetGPS -> GetGPSM.IGetGPS;

  UnitTestGPSM.FixTimer -> TimerC.Timer[unique("Timer")];
  UnitTestGPSM.FixMsgTimer -> TimerC.Timer[unique("Timer")];
  UnitTestGPSM.DTTimer -> TimerC.Timer[unique("Timer")];
  GetGPSM.Timer -> TimerC.Timer[unique("Timer")];
  UnitTestGPSM.Timer -> TimerC.Timer[unique("Timer")];
  
  GetGPSM.GpsFix -> UnitTestGPSM.GpsFix;
  GetGPSM.GpsControl -> UnitTestGPSM.GpsControl;
  
  //BeaconM.SendMsg -> UnitTestBeaconM.SendMsg;
}
