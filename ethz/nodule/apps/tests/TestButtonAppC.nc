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

  components
    HplAt32uc3bGeneralIOC as IO,
    HplAt32uc3bGpioInterruptC as Interrupt;

  components new At32uc3bGpioC() as GpioImpl1;
  GpioImpl1.HplGeneralIO -> IO.Gpio34;
  TestButtonC.Button1 -> GpioImpl1;
  TestButtonC.InterruptButton1 -> Interrupt.Gpio34;

  components new At32uc3bGpioC() as GpioImpl2;
  GpioImpl2.HplGeneralIO -> IO.Gpio35;
  TestButtonC.Button2 -> GpioImpl2;
  TestButtonC.InterruptButton2 -> Interrupt.Gpio35;
}
