/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

configuration PlatformButtonC
{
  provides interface GeneralIO as Gpio1;
  provides interface GpioInterrupt as Interrupt1;
  provides interface GeneralIO as Gpio2;
  provides interface GpioInterrupt as Interrupt2;
}
implementation
{
  components
    HplAt32uc3bGeneralIOC as IO,
    HplAt32uc3bGpioInterruptC as Interrupt,
    ButtonC;

  components new At32uc3bGpioC() as GpioImpl1;
  GpioImpl1.HplGeneralIO -> IO.Gpio34;
  GpioImpl1.HplGpioInterrupt -> Interrupt.Gpio34;
  Gpio1 = GpioImpl1;
  Interrupt1 = GpioImpl1;

  components new At32uc3bGpioC() as GpioImpl2;
  GpioImpl2.HplGeneralIO -> IO.Gpio35;
  GpioImpl2.HplGpioInterrupt -> Interrupt.Gpio35;
  Gpio2 = GpioImpl2;
  Interrupt2 = GpioImpl2;
}
