/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * derived from UserButton by  Gilman Tolle
 * John Griessen  Rev 1.0 25jul07
 * revised John Griessen 13 Dec 2007
*/
configuration HplUserSwitchC {
  provides interface GeneralIO;
  provides interface GpioInterrupt;
}
implementation {
  components HplMsp430GeneralIOC as GeneralIOC;
  components HplMsp430InterruptC as InterruptC;

  components new Msp430GpioC() as ecosens1UserSwitch;
  ecosens1UserSwitch -> GeneralIOC.Port27;
  ecosens1UserSwitch =  GeneralIO;

  components new Msp430InterruptC() as InterruptFromSwitch;
  InterruptFromSwitch.HplInterrupt -> InterruptC.Port27;
  InterruptFromSwitch.Interrupt = GpioInterrupt;
}
