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
 * Provide, as per TEP101, arbitrated access via a Read interface to the
 * Hcs08 ADC.  Users of this component must link it to an
 * implementation of Atm128AdcConfig which provides the ADC parameters
 * (channel, etc).
 * originally from atm128 adapted for Hcs08 by Tor Petterson
 * 
 * @author David Gay
 * @author Tor Petterson <motor@diku.dk>
 */

#include "Adc.h"

generic configuration AdcReadClientC() {
  provides interface Read<uint16_t>;
  uses {
    interface Hcs08AdcConfig;
    interface ResourceConfigure;
  }
}
implementation {
  components WireAdcP, Hcs08AdcC;

  enum {
    ID = unique(UQ_ADC_READ),
    HAL_ID = unique(UQ_HCS08ADC_RESOURCE)
  };

  Read = WireAdcP.Read[ID];
  Hcs08AdcConfig = WireAdcP.Hcs08AdcConfig[ID];
  WireAdcP.Resource[ID] -> Hcs08AdcC.Resource[HAL_ID];
  ResourceConfigure = Hcs08AdcC.ResourceConfigure[HAL_ID];
}
