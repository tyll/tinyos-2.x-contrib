// $Id$

/* "Copyright (c) 2000-2005 The Regents of the University of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * @author Joe Polastre
 * @version $Revision$ $Date$
 */
#include "hardware.h"

configuration PlatformLedsC {
  provides interface GeneralIO as Led0;
  provides interface GeneralIO as Led1;
  provides interface GeneralIO as Led2;
  provides interface GeneralIO as Led3;
  uses interface Init;
}
implementation
{
  components 
      HplMsp430GeneralIOC as GeneralIOC
    , new Msp430GpioC() as Led0Impl
    , new Msp430GpioC() as Led1Impl
    , new Msp430GpioC() as Led2Impl
    , new Msp430GpioC() as Led3Impl;
    
  components new Msp430GpioC() as UmphLed0C,
      new Msp430GpioC() as UmphLed1C,
      new Msp430GpioC() as UmphLed2C,
      new Msp430GpioC() as UmphLed3C;
   
  /*
  components DummyIoP;
    Init = PlatformP.LedsInit;
    Led0 = DummyIoP;
    Led1 = DummyIoP;
    Led2 = DummyIoP;
    Led3 = DummyIoP;
   */
   
  components PlatformP;
  Init = PlatformP.LedsInit;
  
  Led0 = Led0Impl;
  Led0 = UmphLed0C;
  Led0Impl -> GeneralIOC.Port67;
  UmphLed0C -> GeneralIOC.Port20;
  
  Led1 = Led1Impl;
  Led1 = UmphLed1C;
  Led1Impl -> GeneralIOC.Port66;
  UmphLed1C -> GeneralIOC.Port16; 
  
  Led2 = Led2Impl;
  Led2 = UmphLed2C;
  Led2Impl -> GeneralIOC.Port40;
  UmphLed2C -> GeneralIOC.Port61; 
  
  Led3 = Led3Impl;
  Led3 = UmphLed3C;
  Led3Impl -> GeneralIOC.Port65;
  UmphLed3C -> GeneralIOC.Port60; 
}

