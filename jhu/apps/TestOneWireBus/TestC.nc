
configuration TestC {
}

implementation {

  components TestP,
      MainC,
      LedsC, NoLedsC,
      new TimerMilliC() as Ds1825RefreshTimer,
      new TimerMilliC() as Ds1825ReadTimer,
      new TimerMilliC() as DummyRefreshTimer,
      new TimerMilliC() as DummyReadTimer,
      new TimerMilliC() as StopTimer,
      RandomC;

  components Ds1825C, 
    DummyOWC;

  TestP.Boot -> MainC;
  TestP.Leds -> NoLedsC;
  TestP.Random -> RandomC;
  TestP.StopTimer -> StopTimer;

  TestP.Ds1825ReadTimer -> Ds1825ReadTimer;
  TestP.Ds1825RefreshTimer -> Ds1825RefreshTimer;
  TestP.Ds1825Read -> Ds1825C.Read;
  TestP.Ds1825Dim -> Ds1825C.OneWireDeviceInstanceManager;

  TestP.DummyReadTimer -> DummyReadTimer;
  TestP.DummyRefreshTimer -> DummyRefreshTimer;
  TestP.DummyRead -> DummyOWC.Read;
  TestP.DummyDim -> DummyOWC.OneWireDeviceInstanceManager;
}
