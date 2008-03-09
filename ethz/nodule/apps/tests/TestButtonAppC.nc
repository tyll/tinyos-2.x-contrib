/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */  

configuration TestButtonAppC
{
}
implementation
{
  components MainC, TestButtonC;
  TestButtonC -> MainC.Boot;

  components LedsC;
  TestButtonC.Leds -> LedsC;

  components SystemLedC;
  TestButtonC.SystemLed -> SystemLedC;

  components ButtonC;
  TestButtonC.Button1 -> ButtonC.Button1;
  TestButtonC.Button2 -> ButtonC.Button2;
}
