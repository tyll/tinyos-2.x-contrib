/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */  

configuration TestLedAppC
{
}
implementation
{
  components MainC, TestLedC;
  TestLedC -> MainC.Boot;

  components LedsC;
  TestLedC.Leds -> LedsC;

  components SystemLedC;
  TestLedC.SystemLed -> SystemLedC;
}
