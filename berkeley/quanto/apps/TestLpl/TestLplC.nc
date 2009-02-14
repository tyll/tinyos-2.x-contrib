#include <AM.h>
#include <Timer.h>
#include <UserButton.h>
#include "activity.h"

// Minimalist program to listen for packets.
// when a packet is received, turn the LED on
// Used to test Quanto with LPL
// Bounce can be used to send packets upon pressing the button.

module TestLplC {
    uses {
        interface Boot;
        interface QuantoLog;
        interface Notify<button_state_t> as UserButtonNotify;
        interface Receive;
        interface SplitControl as AMControl;
        interface Leds;
        interface SingleContext as CPUContext;

        interface LowPowerListening;
    }
}
implementation {

    uint8_t state;
    enum {S_STARTED, S_FULL, S_FLUSHING, S_IDLE, ACT_MAIN=21};
    //0,1,2,3
   
    /* Entering different states */
    void start() {
        state = S_STARTED;
        call Leds.led0Off();
        call Leds.led1Off();
        call QuantoLog.record();
    }

    void stop() {
        state = S_FULL;
        call Leds.led0On(); 
        call Leds.led1Off();
    }

    void flush() { 
        state = S_FLUSHING;
        call Leds.led0Off(); 
        call Leds.led1On();
        call QuantoLog.flush();
    }
    
    void enterIdle() {
        call Leds.led0On();
        call Leds.led1On();

        call Leds.led2Off();

        state = S_IDLE;
    }
 

    event void Boot.booted() {
        call CPUContext.set(mk_act_local(ACT_MAIN));
        call AMControl.start();
    }

    event void AMControl.startDone(error_t err) {
        if (err == SUCCESS) {
#ifdef LPL_INTERVAL
            call LowPowerListening.setLocalSleepInterval(LPL_INTERVAL);
#endif
            call UserButtonNotify.enable();
        } else {
            call AMControl.start();
        }
        enterIdle();
    }

    event void AMControl.stopDone(error_t err) {
    }


    event void UserButtonNotify.notify(button_state_t buttonState) {
        if (buttonState == BUTTON_PRESSED) {
            switch (state) {
                case S_IDLE:    start(); break;
                case S_STARTED: stop(); flush(); break;  
                case S_FULL:    flush(); break;
            }
        }
    }

    event void QuantoLog.full() {
        stop();
    }
    
    event void QuantoLog.flushDone() {
        enterIdle();
    }


    event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
        call Leds.led2Toggle();
        return msg;
   } 
}
