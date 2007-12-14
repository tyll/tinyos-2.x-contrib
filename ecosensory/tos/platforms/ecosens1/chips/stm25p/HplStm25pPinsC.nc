/* Copyright (c) 2005-2006 Arch Rock Corporation All rights reserved.
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * HPL implementation of general-purpose I/O for a ST M25P chip
 * connected to a TI MSP430.
 *
 * @author Jonathan Hui <jhui@archrock.com>  Revision: 1.4  2006/12/12 18:23:45
 */

configuration HplStm25pPinsC {

  provides interface GeneralIO as CSN;
  provides interface GeneralIO as Hold;

}

implementation {

  components HplMsp430GeneralIOC as HplGeneralIOC;
  components new Msp430GpioC() as CSNM;
  components new Msp430GpioC() as HoldM;

  CSNM -> HplGeneralIOC.Port44;
  HoldM -> HplGeneralIOC.Port47;

  CSN = CSNM;
  Hold = HoldM;

}
