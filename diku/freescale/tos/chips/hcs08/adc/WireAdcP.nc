/* $Id$
 * Copyright (c) 2005 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * Support component for AdcReadClientC and AdcReadNowClientC.
 * originally from atm128 adapted for Hcs08 by Tor Petterson
 *
 * @author David Gay
 * @author Tor Petterson <motor@diku.dk>
 */

configuration WireAdcP {
  provides {
    interface Read<uint16_t>[uint8_t client]; 
    interface ReadNow<uint16_t>[uint8_t client];
  }
  uses {
    interface Hcs08AdcConfig[uint8_t client];
    interface Resource[uint8_t client];
  }
}
implementation {
  components Hcs08AdcC, AdcP,
    new ArbitratedReadC(uint16_t) as ArbitrateRead;

  Read = ArbitrateRead;
  ReadNow = AdcP;
  Resource = ArbitrateRead.Resource;
  Hcs08AdcConfig = AdcP;

  ArbitrateRead.Service -> AdcP.Read;
  AdcP.Hcs08AdcSingle -> Hcs08AdcC;
}
