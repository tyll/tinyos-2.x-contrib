/* Copyright (c)  2005-2006 Arch Rock Corporation All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * HPL implementation of the SPI bus for the ChipCon CC2420 radio
 * connected to a TI MSP430 processor.
 *
 * @author Jonathan Hui <jhui@archrock.com>  Revision: 1.4 2006/12/12 18:23:44  
 * revised John Griessen 13 Dec 2007
 */

generic configuration HplCC2420SpiC() {
  
  provides interface Resource;
  provides interface SpiByte;
  provides interface SpiPacket;
  
}

implementation {

  components new Msp430Spi0C() as SpiC;
  
  Resource = SpiC;
  SpiByte = SpiC;
  SpiPacket = SpiC;
  
}

