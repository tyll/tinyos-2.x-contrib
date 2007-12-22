/* Copyright (c) 2007, University of California All rights reserved. 
* BSD license full text at: 
* http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * @author Joe Polastre
 * @version $Revision$ $Date$
 */
#include "hardware.h"

configuration PlatformLedsC {
  provides interface GeneralIO as Led0;
  provides interface GeneralIO as Led1;
  provides interface GeneralIO as Led2;
  uses interface Init;
}
implementation
{
  components 
      HplMsp430GeneralIOC as GeneralIOC
    , new Msp430GpioC() as Led0Impl
    , new Msp430GpioC() as Led1Impl
    , new Msp430GpioC() as Led2Impl
    ;
  components PlatformP;

  Init = PlatformP.LedsInit;

  Led0 = Led0Impl;
  Led0Impl -> GeneralIOC.Port54;

  Led1 = Led1Impl;
  Led1Impl -> GeneralIOC.Port55;

  Led2 = Led2Impl;
  Led2Impl -> GeneralIOC.Port56;

}

