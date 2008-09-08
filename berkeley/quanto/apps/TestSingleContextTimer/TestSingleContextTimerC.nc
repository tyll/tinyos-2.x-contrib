#include <Timer.h>
#include <UserButton.h>

/* Test App 1 for Context across task invocations
 * Tests the Context module and the CtxBasicSchedulerP module
 * Two tasks are attributed different contexts A and B, and 
 * alternate rescheduling themselves.
 * The context of a task is preserved and propagated to any task that
 * it posts. 
 */

module TestSingleContextTimerC
{
  uses interface Leds;
  uses interface Boot;
  uses interface Random;
  uses interface QuantoLog;
  uses interface Notify<button_state_t> as UserButtonNotify;
  uses interface Timer<TMilli> as TimerA;   
  uses interface Timer<TMilli> as TimerB;   

  uses interface SingleContext as CPUContext;
  uses interface MultiContext as LED0Context;
  uses interface MultiContext as LED2Context;
}
implementation
{
  enum {
    ACT_MAIN = 1,
    ACT_A = 2,
    ACT_B = 3,
  };

  enum {
    N = 20,
  };


  uint8_t remaining = N;
  uint8_t outstanding = 0;

  void initState() {
    remaining = N;
    outstanding = 0;
  }

  inline void scheduleA() {
      call TimerA.startOneShot( call Random.rand16() % 512 );
      outstanding++;
      remaining--;
  }

  inline void scheduleB() {
      call TimerB.startOneShot( call Random.rand16() % 512 );
      outstanding++;
      remaining--;
  }


  void start() {
    act_t old_ctx = call CPUContext.get();
    call QuantoLog.record();
    call CPUContext.set(mk_act_local(ACT_A));
    if (remaining) 
        scheduleA();
    call CPUContext.set(mk_act_local(ACT_B));
    if (remaining)
        scheduleB();
    call CPUContext.set(old_ctx);
  }

  event void Boot.booted()
  {
    call UserButtonNotify.enable();
  }

  event void UserButtonNotify.notify(button_state_t buttonState) {
    if (buttonState == BUTTON_PRESSED) {
        initState();
        call CPUContext.set(mk_act_local(ACT_MAIN));
        start();
    }
  }
  
  void done() {
     call CPUContext.set(mk_act_local(ACT_MAIN));
     call QuantoLog.flush();
  }

  //play with LED0
  event void TimerA.fired() {
    bool ledOn = (call Leds.get() & LEDS_LED0);     
    outstanding--;
    if (!ledOn) {
        call Leds.led0On();
        call LED0Context.add(call CPUContext.get());
    } else {
        call Leds.led0Off();
        call LED0Context.remove(call CPUContext.get());
    }
    if (remaining)
        scheduleA();
    else if (!outstanding) 
        done();
  }

  //play with Led2
  event void TimerB.fired() {
    bool ledOn = (call Leds.get() & LEDS_LED2);     
    outstanding--;
    if (!ledOn) {
        call Leds.led2On();
        call LED2Context.add(call CPUContext.get());
    } else {
        call Leds.led2Off();
        call LED2Context.remove(call CPUContext.get());
    }
    if (remaining)
        scheduleB();
    else if (!outstanding) 
        done();
  }
}

