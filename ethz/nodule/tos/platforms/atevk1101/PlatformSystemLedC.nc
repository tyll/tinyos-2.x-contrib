/* $Id$ */

/**
 * This component provides a led as I/O pin. This led is reserved 
 * for system components (no calls from application). The led is
 * initialized through the components LedsC/LedsP. The led on the
 * atevk1101 is active low which is the assumption made by
 * LedsC/LedsP.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 */

configuration PlatformSystemLedC
{
  provides interface GeneralIO as Led; // LED 3
  uses interface Init;
}
implementation
{
  components PlatformP;
  Init = PlatformP.LedsInit;

  components
    HplAt32uc3bGeneralIOC as Gpio,
    new At32uc3bGpioC() as LedImpl;

  Led = LedImpl;
  LedImpl -> Gpio.Gpio22;
}
