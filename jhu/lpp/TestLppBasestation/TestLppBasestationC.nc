configuration TestLppBasestationC { }

implementation
{
  components MainC, NoLedsC, LedsC,
    ActiveMessageC as Radio,
    KeepAliveC,
    TestLppBasestationP;

  TestLppBasestationP.Boot -> MainC.Boot;
  TestLppBasestationP.Leds -> LedsC;
  TestLppBasestationP.RadioSplitControl -> Radio;
  TestLppBasestationP.KeepAlive -> KeepAliveC;
}
