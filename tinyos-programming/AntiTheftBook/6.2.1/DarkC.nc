/*
 * Copyright (c) 2007-2009 Intel Corporation
 * All rights reserved.

 * This file is distributed under the terms in the attached INTEL-LICENS
 * file. If you do not find this file, a copy can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
module DarkC {
  uses {
    interface Boot;
    interface Leds;
    interface Timer<TMilli> as TheftTimer;
    interface Read<uint16_t> as Light;
  }
}
implementation {
  enum { DARK_INTERVAL = 256, DARK_THRESHOLD = 200 };

  event void Boot.booted() {
    call TheftTimer.startPeriodic(DARK_INTERVAL);
  }

  event void TheftTimer.fired() {
    call Light.read(); // Initiate split-phase light sampling
  }

  /* Light sample completed. Check if it indicates theft */
  event void Light.readDone(error_t ok, uint16_t val) {
    if (ok == SUCCESS && val < DARK_THRESHOLD)
      call Leds.led2On(); /* ALERT! ALERT! */
    else
      call Leds.led2Off(); /* Don't leave LED permanently on */
  }
}
