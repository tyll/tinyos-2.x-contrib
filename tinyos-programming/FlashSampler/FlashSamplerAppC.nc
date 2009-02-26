/*
 * Copyright (c) 2007-2009 Intel Corporation
 * All rights reserved.

 * This file is distributed under the terms in the attached INTEL-LICENS
 * file. If you do not find this file, a copy can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
#include "StorageVolumes.h"

configuration FlashSamplerAppC { }
implementation
{
  components FlashSamplerC, SummarizerC, AccelSamplerC;
  components MainC, LedsC, new TimerMilliC(), 
    new LogStorageC(VOLUME_SAMPLELOG, TRUE),
    new BlockStorageC(VOLUME_SAMPLES),
    new AccelXStreamC();

  FlashSamplerC.Boot -> MainC;
  FlashSamplerC.Leds -> LedsC;
  FlashSamplerC.Timer -> TimerMilliC;
  FlashSamplerC.Summary -> SummarizerC;
  FlashSamplerC.Sample -> AccelSamplerC;

  AccelSamplerC.Accel -> AccelXStreamC;
  AccelSamplerC.BlockWrite -> BlockStorageC;
  AccelSamplerC.Leds -> LedsC;

  SummarizerC.BlockRead -> BlockStorageC;
  SummarizerC.LogWrite -> LogStorageC;
}
