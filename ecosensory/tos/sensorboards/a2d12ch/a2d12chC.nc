/* 
 * Copyright (c) 2007, Ecosensory All rights reserved.
 *
 * -- Use per TOS Alliance license. If not found in your distribution 
 *     see http://tinyos.net/licenses/toslicense.txt --
 * $Revision$
 * $Date: 2sep2007
 * @author: John Griessen <john@ecosensory.com>
 * ========================================================================
 * Reuses HAL of ADC12 on msp430 in banks of 6 with resource wait
 * of 10 msec for cap. moisture sensors to reach equilibrium.. 
 * the two data buffers are returned with the multichannel.getData 
 * interface as one shorter buffer with the samplesperbank buffer entries
 * all averaged together.
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
  a2d12chP. Leds -> LedsC;
  a2d12ch = a2d12chP;
  Resource = a2d12chP;
}

