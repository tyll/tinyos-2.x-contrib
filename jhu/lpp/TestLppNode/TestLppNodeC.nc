configuration TestLppNodeC { }

implementation
{
  components MainC, NoLedsC, LedsC,
    new TimerMilliC() as Timer,
    ActiveMessageC as Radio,
    SerialActiveMessageC as Serial,
    new SerialAMSenderC(0),
    KeepAliveC,
    TestLppNodeP;

  TestLppNodeP.Boot -> MainC.Boot;
  TestLppNodeP.Leds -> LedsC;
  TestLppNodeP.RadioSplitControl -> Radio;
  TestLppNodeP.Lpp -> Radio;
  TestLppNodeP.KeepAlive -> KeepAliveC;
  TestLppNodeP.SerialSplitControl -> Serial;
  TestLppNodeP.AMSend -> SerialAMSenderC;
}
