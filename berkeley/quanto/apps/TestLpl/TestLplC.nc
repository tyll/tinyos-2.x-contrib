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

    uint8_t started;
   
    event void Boot.booted() {
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
    }

    event void AMControl.stopDone(error_t err) {
    }

    void start() {
        started = 1;
        call Leds.led0On();
        call QuantoLog.record();
    }

    void stop() {
        call Leds.led0Off(); 
        call Leds.led1Off();
        call QuantoLog.flush();
        started = 0;
    }
 
    event void UserButtonNotify.notify(button_state_t buttonState) {
        if (buttonState == BUTTON_PRESSED) {
            if (!started)
              start();
            else
              stop();
        }
    }

    event void QuantoLog.full() {
        stop();
    }


    event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
        call Leds.led1On();
        return msg;
   } 
}
