configuration BeaconTimer
{
  provides
  {
    interface StdControl;
    interface IBeaconTimer;
  }
}
implementation
{
  components BeaconTimerM, TimerC, RandomLFSR;

  StdControl = BeaconTimerM.StdControl;
  IBeaconTimer = BeaconTimerM.IBeaconTimer;
  BeaconTimerM.Timer->TimerC.Timer[unique ("Timer")];
  BeaconTimerM.Random -> RandomLFSR.Random;
}
