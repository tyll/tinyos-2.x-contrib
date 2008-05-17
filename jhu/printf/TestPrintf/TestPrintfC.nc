configuration TestPrintfC { }

implementation
{
  components MainC, NoLedsC, LedsC;
  components new TimerMilliC() as Timer;
  components TestPrintfP;

  TestPrintfP.Boot -> MainC.Boot;
  TestPrintfP.Leds -> NoLedsC;
  TestPrintfP.Timer -> Timer;

  components PrintfC;
}
