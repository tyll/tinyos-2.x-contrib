/* Copyright (c) 2005-2006 Arch Rock Corporation All rights reserved.
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * Implementation of the user button for the telos platform
 *
 * @author Gilman Tolle <gtolle@archrock.com>
 *  revised John Griessen 13 Dec 2007
 */

configuration HplUserButtonC {
  provides interface GeneralIO;
  provides interface GpioInterrupt;
}
implementation {
  components HplMsp430GeneralIOC as GeneralIOC;
  components HplMsp430InterruptC as InterruptC;

  components new Msp430GpioC() as UserButtonC;
  UserButtonC -> GeneralIOC.Port27;
  GeneralIO = UserButtonC;

  components new Msp430InterruptC() as InterruptUserButtonC;
  InterruptUserButtonC.HplInterrupt -> InterruptC.Port27;
  GpioInterrupt = InterruptUserButtonC.Interrupt;
}
