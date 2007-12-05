/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

configuration PlatformLedsC {
  provides interface GeneralIO as Led0; // 0
  provides interface GeneralIO as Led1; // 1
  provides interface GeneralIO as Led2; // 2
  uses interface Init;
}
implementation
{
  components PlatformP;
  Init = PlatformP.LedsInit;

  components
    HplAt32uc3bGeneralIOC as Gpio,
    new At32uc3bGpioC() as Led0Impl,
    new At32uc3bGpioC() as Led1Impl,
    new At32uc3bGpioC() as Led2Impl
    ;

  Led0 = Led0Impl;
  Led0Impl -> Gpio.Gpio7;
  Led1 = Led1Impl;
  Led1Impl -> Gpio.Gpio8;
  Led2 = Led2Impl;
  Led2Impl -> Gpio.Gpio21;
}
