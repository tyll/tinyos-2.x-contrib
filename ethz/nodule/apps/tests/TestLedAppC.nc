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

// set LOCEN bit in the CPUCR system register to enable local bus
//  components HplAt32uc3bGeneralIOLocalBusC as Gpio, new At32uc3bGpioLocalBusC() as GpioImpl;
  components HplAt32uc3bGeneralIOC as Gpio, new At32uc3bGpioC() as GpioImpl;
  GpioImpl.HplGeneralIO -> Gpio.Gpio22;
  TestLedC.SystemLed -> GpioImpl;
}
