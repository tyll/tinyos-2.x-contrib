/* 
 * Copyright (c) 2007, Ecosensory
 * -- Use per TOS Alliance license. If not found in your distr. 
 *     see http://tinyos.net/licenses/toslicense.txt --
 * $Revision$
 * $Date: 2sep2007
 * @author: John Griessen <john@ecosensory.com>
 * ============================================================
 */
#include "Msp430Adc12.h"
configuration Testch12AdcC {
}
implementation
{

  components MainC, LedsC;
  Testch12AdcP.Leds -> LedsC;


  components Testch12AdcP, ch12AdcP, ch12AdcC;
  Testch12AdcP.Boot -> MainC;
  Testch12AdcP.ch12Adc -> ch12AdcP.ch12Adc;  //Msp430Adc12MultiChannel
  Testch12AdcP.Resource -> ch12AdcP.Resource;  //ResourceRVG
  
  Testch12AdcP.AdcConfigure -> ch12AdcP.AdcConfigure;  //Msp430Adc12MultiChannel
}

