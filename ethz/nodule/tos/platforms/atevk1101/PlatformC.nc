/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

configuration PlatformC
{
  provides interface Init;
}
implementation
{
  components PlatformP, InterruptControllerC;
  Init = PlatformP;
  PlatformP.InterruptInit -> InterruptControllerC;

  // RS232 mapping
  components HplAt32uc3bGeneralIOC as Gpio;

  PlatformP.RS232_TX -> Gpio.Gpio24;
  PlatformP.RS232_RX -> Gpio.Gpio24;
  PlatformP.RS232_CTS -> Gpio.Gpio36;
  PlatformP.RS232_RTS -> Gpio.Gpio37;
}
