/* Copyright (c)  2005-2006 Arch Rock Corporation All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * HPL impl. 32khz alarms for CC2420 radio connected to a MSP430 microcontroller
 *
 * @author Jonathan Hui <jhui@archrock.com>  Revision: 1.4 $ $Date: 2006/12/12 18:23:44
 *  revised John Griessen 13 Dec 2007
 */

generic configuration HplCC2420AlarmC() {

  provides interface Init;
  provides interface Alarm<T32khz,uint32_t> as Alarm32khz32;

}

implementation {

  components new Alarm32khz32C();

  Init = Alarm32khz32C;
  Alarm32khz32 = Alarm32khz32C;
  
}
