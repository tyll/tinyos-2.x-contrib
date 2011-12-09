/* $Id$
 * Copyright (c) 2006 ETH Zurich.
 * Copyright (c) 2005 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * The porttion of a mica-family initialisation that is btnode3-specific.
 * 
 * @author David Gay
 * @author Jan Beutel
 */
module MotePlatformP
{
  provides {
    interface Init as PlatformInit;
  } 
  uses {
    //interface GeneralIO as SerialIdPin;
    interface Init as SubInit;
  }
}
implementation {
  void enable_external_ram() __attribute__ ((naked)) __attribute__ ((section (".init1"))) {

  }
  command error_t PlatformInit.init() {
    // Pull C I/O port pins low to initialize LED's to off
    // Turn in cc1000 and IO power
    MCUCR |= _BV(SRE);      // Internal RAM, IDLE, rupt vector at 0x0002,
	XMCRB  = _BV(XMBK);
	MCUCR |= _BV(SRW10);
	XMCRA &= ~(_BV(SRW11));
    return call SubInit.init();
  }

  default command error_t SubInit.init() {
    return SUCCESS;
  }
}
