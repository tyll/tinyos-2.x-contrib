/* $Id$ */

/**
 * This component provides 3 leds as I/O pins. The leds are
 * initialized through the componts LedsC/LedsP. The leds on the
 * atevk1101 are active low which is the assumption made by
 * LedsC/LedsP.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 */

configuration PlatformLedsC
{
  provides interface GeneralIO as Led0; // LED 0
  provides interface GeneralIO as Led1; // LED 1
  provides interface GeneralIO as Led2; // LED 2
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
