#include "activity.h"
#include <UserButton.h>

module BurstC {
    uses interface SingleContext as CPUContext;
    uses interface Boot;
    uses interface Notify<button_state_t> as UserButtonNotify;
    uses interface QuantoLog;
    uses interface Leds;

    uses interface Timer<TMilli> as Timer0;
    uses interface HplMsp430GeneralIO as A0;
    uses interface HplMsp430GeneralIO as A1;
}

implementation {
  int ctx_idx;
  act_t cv[2];

  enum {
    TIMER_PERIOD_MILLI = 1024,
  };

  event void Boot.booted()
  {
    call UserButtonNotify.enable();
    call A0.clr();
    call A0.makeOutput();
    call A1.clr();
    call A1.makeOutput();
 
    cv[0] = mk_act_local(1);
    cv[1] = mk_act_local(2);
    ctx_idx = 0;
  }

  event void Timer0.fired() {
    act_t c = cv[1-ctx_idx]; 
    call Leds.led0Toggle();
    atomic {
      int i = 10;
      call A0.set(); // U2.3
      call CPUContext.set(c);
      call A1.set(); // U2.5
      while (i--); // Spin for a bit
      call A0.clr();
      call A1.clr();
    }
  }


  void start() {
    call Leds.led1On();
    call QuantoLog.record();
    call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
  }

  event void QuantoLog.full() {
    call Leds.led1Off();
    call QuantoLog.flush();
  }

  event void UserButtonNotify.notify(button_state_t buttonState) {
    if (buttonState == BUTTON_PRESSED) {
        start();
    }
  }

}
