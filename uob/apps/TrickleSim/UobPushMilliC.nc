configuration UobPushMilliC {
  provides interface UobTrickleTimer as TrickleTimer;
}
implementation {
  components UobPushMilliP as TrickleP;
  components MainC;
  components new TimerMilliC() as PeriodicIntervalTimer;
  components LedsC;
  TrickleTimer = TrickleP;

  TrickleP.PeriodicIntervalTimer -> PeriodicIntervalTimer;

  TrickleP.Leds -> LedsC;
  MainC.SoftwareInit -> TrickleP;
}
