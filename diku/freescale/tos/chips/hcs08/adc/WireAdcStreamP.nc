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
 * Support component for AdcReadStreamClientC.
 * originally from atm128 adapted for Hcs08 by Tor Petterson
 *
 * @author David Gay
 * @author Tor Petterson <motor@diku.dk>
 */

#include "Adc.h"

configuration WireAdcStreamP {
  provides interface ReadStream<uint16_t>[uint8_t client];
  uses {
    interface Hcs08AdcConfig[uint8_t client];
    interface Resource[uint8_t client];
  }
}
implementation {
  components Hcs08AdcC, AdcStreamP, PlatformC, MainC,
    new AlarmMicro32C(), 
    new ArbitratedReadStreamC(uniqueCount(UQ_ADC_READSTREAM), uint16_t) as ArbitrateReadStream;

  Resource = ArbitrateReadStream;
  ReadStream = ArbitrateReadStream;
  Hcs08AdcConfig = AdcStreamP;

  ArbitrateReadStream.Service -> AdcStreamP;

  AdcStreamP.Init <- MainC;
  AdcStreamP.Hcs08AdcSingle -> Hcs08AdcC;
  AdcStreamP.Alarm -> AlarmMicro32C;
  
  AlarmMicro32C.Init <- MainC.SoftwareInit;
}
