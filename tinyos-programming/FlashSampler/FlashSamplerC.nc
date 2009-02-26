/*
 * Copyright (c) 2007-2009 Intel Corporation
 * All rights reserved.

 * This file is distributed under the terms in the attached INTEL-LICENS
 * file. If you do not find this file, a copy can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
#include "flashsampler.h"

module FlashSamplerC 
{
  uses {
    interface Boot;
    interface Timer<TMilli>;
    interface Sample;
    interface Summary;
    interface Leds;
  }
}
implementation 
{
  event void Boot.booted() {
    signal Timer.fired();
  }

  event void Timer.fired() {
    call Leds.led0On();
    call Sample.sample();
  }

  event void Sample.sampled(error_t error) {
    call Leds.led0Off();
    call Leds.led1On();
    call Summary.summarize();
  }

  event void Summary.summarized(error_t ok) {
    call Leds.led1Off();
    call Timer.startOneShot(SAMPLE_INTERVAL);
  }
}
