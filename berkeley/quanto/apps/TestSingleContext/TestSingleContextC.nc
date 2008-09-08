#include <Timer.h>
#include <UserButton.h>

/* Test App 1 for Context across task invocations
 * Tests the Context module and the CtxBasicSchedulerP module
 * Two tasks are attributed different contexts A and B, and 
 * alternate rescheduling themselves.
 * The context of a task is preserved and propagated to any task that
 * it posts. 
 */

module TestSingleContextC
{
  uses interface Leds;
  uses interface Boot;
  uses interface Random;
  uses interface SingleContext as CPUContext;
  uses interface QuantoLog;
  uses interface Notify<button_state_t> as UserButtonNotify;
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

  void initState() {
    remaining = N;
  }

  task void taskA(); 
  task void taskB();

  void start() {
    act_t old_ctx = call CPUContext.get();
    call QuantoLog.record();
    call CPUContext.set(mk_act_local(ACT_A));
    if (remaining--)
        post taskA();
    call CPUContext.set(mk_act_local(ACT_B));
    if (remaining--)
        post taskB();
    call CPUContext.set(old_ctx);
  }

  event void Boot.booted()
  {
    call UserButtonNotify.enable();
  }

  event void UserButtonNotify.notify(button_state_t buttonState) {
    if (buttonState == BUTTON_PRESSED) {
        call Leds.led1Toggle();
        initState();
        call CPUContext.set(mk_act_local(ACT_MAIN));
        start();
    }
  }

  //do some variable amount of blocking work
  void doWork() {
    uint32_t i;
    uint32_t lim;
    int a = 0;
    act_t c = call CPUContext.get();
    if (c == mk_act_local(ACT_A)) 
        call Leds.led0Toggle();
    else if (c == mk_act_local(ACT_B))
        call Leds.led2Toggle();
    //lim = 50000;
    lim = call Random.rand32() % 100000u;
    for (i = 0; i < lim; i++) 
        a++;
  }

  void done() {
     call CPUContext.set(mk_act_local(ACT_MAIN));
     call QuantoLog.flush();
  }

  event void QuantoLog.full() {
  }

  task void taskA() {
    doWork();
    if (remaining) {
        post taskA();
        if (! (--remaining))
            done();
    }
  }

  task void taskB() {
    doWork();
    if (remaining) {
        post taskB();
        if (! (--remaining))
            done();
    }
  }
}

