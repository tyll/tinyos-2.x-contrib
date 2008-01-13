/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 *  This code funded by TX State San Marcos University. BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * by John Griessen <john@ecosensory.com>
 * Rev 1.0 14 Dec 2007
 *
 * Reuses HAL of ADC12 on msp430 in banks of 6 with resource wait
 * of 10 msec.
 */
#include "Msp430Adc12.h"
configuration a2d12chC {
  provides interface Msp430Adc12MultiChannel as a2d12ch;
  provides interface Resource;
}
implementation
{
  components a2d12chP, LedsC;
  components new Msp430Adc12ClientAutoRVGC() as a2d12chRVG;
  a2d12chP.ResourceRVG -> a2d12chRVG;
  a2d12chP.multichannel -> a2d12chRVG.Msp430Adc12MultiChannel;
  a2d12chRVG.AdcConfigure -> a2d12chP.AdcConfigure;
  a2d12chP.Leds -> LedsC;

  a2d12ch = a2d12chP;
  Resource = a2d12chP;
}

