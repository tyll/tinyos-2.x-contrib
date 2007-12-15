/* Copyright (c) 2005-2006 Arch Rock Corporation All rights reserved.
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * VoltageC is a common name for the Msp430InternalVoltageC voltage
 * sensor available on the telosb platform.
 *
 * To convert from ADC counts to actual voltage, divide by 4096 and
 * multiply by 3.
 *
 * @author Gilman Tolle <gtolle@archrock.com> Revision: 1.1  2007/12/14 19:57:23
 */

generic configuration VoltageC() {
  provides interface Read<uint16_t>;
}
implementation {
  components new Msp430InternalVoltageC();
  Read = Msp430InternalVoltageC.Read;
}

