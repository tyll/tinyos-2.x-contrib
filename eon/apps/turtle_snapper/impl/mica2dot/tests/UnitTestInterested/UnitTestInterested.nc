configuration UnitTestInterested
{
  provides
  {
    interface StdControl;
    interface UnitTest;
  }
}
implementation
{
  components UnitTestInterestedM, InterestedM, TimerC;

  
  StdControl = UnitTestInterestedM.StdControl;
  StdControl = InterestedM.StdControl;
  StdControl = TimerC.StdControl;
  
  UnitTest = UnitTestInterestedM.UnitTest;
  
  UnitTestInterestedM.IInterested -> InterestedM.IInterested;

  InterestedM.SendMsg -> UnitTestInterestedM.SendMsg;
  InterestedM.VersionStore -> UnitTestInterestedM.VersionStore;
  UnitTestInterestedM.Timer -> TimerC.Timer[unique("Timer")];
}
