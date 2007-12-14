/* Copyright (c)  2005-2006 Arch Rock Corporation All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * HPL implementation of general-purpose I/O for the ChipCon CC2420
 * radio connected to a TI MSP430 processor.
 *
 * @author Jonathan Hui <jhui@archrock.com>  Revision: 1.4 2006/12/12 18:23:44
 * revised John Griessen 13 Dec 2007
 */

configuration HplCC2420PinsC {

  provides interface GeneralIO as CCA;
  provides interface GeneralIO as CSN;
  provides interface GeneralIO as FIFO;
  provides interface GeneralIO as FIFOP;
  provides interface GeneralIO as RSTN;
  provides interface GeneralIO as SFD;
  provides interface GeneralIO as VREN;

}

implementation {

  components HplMsp430GeneralIOC as GeneralIOC;
  components new Msp430GpioC() as CCAM;
  components new Msp430GpioC() as CSNM;
  components new Msp430GpioC() as FIFOM;
  components new Msp430GpioC() as FIFOPM;
  components new Msp430GpioC() as RSTNM;
  components new Msp430GpioC() as SFDM;
  components new Msp430GpioC() as VRENM;

  CCAM -> GeneralIOC.Port14;
  CSNM -> GeneralIOC.Port42;
  FIFOM -> GeneralIOC.Port13;
  FIFOPM -> GeneralIOC.Port10;
  RSTNM -> GeneralIOC.Port46;
  SFDM -> GeneralIOC.Port41;
  VRENM -> GeneralIOC.Port45;

  CCA = CCAM;
  CSN = CSNM;
  FIFO = FIFOM;
  FIFOP = FIFOPM;
  RSTN = RSTNM;
  SFD = SFDM;
  VREN = VRENM;
  
}

