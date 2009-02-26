/*
 * Copyright (c) 2007-2009 Intel Corporation
 * All rights reserved.

 * This file is distributed under the terms in the attached INTEL-LICENS
 * file. If you do not find this file, a copy can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
module AntiTheftC {
  uses {
    interface Boot;
    interface Timer<TMilli> as WarningTimer;
    interface Leds;
  }
}
implementation {
  enum { WARN_INTERVAL = 4096, WARN_DURATION = 64 };

  event void WarningTimer.fired() {
    if (call Leds.get() & LEDS_LED0)
      { // Red LED is on. Turn it off, will switch on again in 4096-64ms.
        call Leds.led0Off();
        call WarningTimer.startOneShot(WARN_INTERVAL - WARN_DURATION);
      }
    else
      { // Red LED is off. Turn it on for 64ms.
        call Leds.led0On();
        call WarningTimer.startOneShot(WARN_DURATION);
      }
  }

  event void Boot.booted() {
    // We just booted. Perform first LED transition.
    signal WarningTimer.fired(); 
  }
}
