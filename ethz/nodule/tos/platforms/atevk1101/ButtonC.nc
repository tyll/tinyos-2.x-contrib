/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

configuration ButtonC
{
  provides interface Button as Button1;
  provides interface Button as Button2;
}
implementation
{
  components new ButtonP() as ButtonImpl1;
  Button1 = ButtonImpl1;
  components new ButtonP() as ButtonImpl2;
  Button2 = ButtonImpl2;
 
  components PlatformButtonC;
  ButtonImpl1.Gpio -> PlatformButtonC.Gpio1;
  ButtonImpl1.Interrupt -> PlatformButtonC.Interrupt1;
  ButtonImpl2.Gpio -> PlatformButtonC.Gpio2;
  ButtonImpl2.Interrupt -> PlatformButtonC.Interrupt2;
}
