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

  components HplAt32uc3bGeneralIOC as Gpio;

  components new At32uc3bGpioC() as GpioImpl1;
  GpioImpl1.HplGeneralIO -> Gpio.Gpio34;
  TestButtonC.Button1 -> GpioImpl1;

  components new At32uc3bGpioC() as GpioImpl2;
  GpioImpl2.HplGeneralIO -> Gpio.Gpio35;
  TestButtonC.Button2 -> GpioImpl2;
}
