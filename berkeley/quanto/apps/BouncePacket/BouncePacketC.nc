#include <AM.h>
#include <Timer.h>
#include <UserButton.h>
#include "activity.h"

module BouncePacketC {
    uses {
        interface Boot;
        interface Random;
        interface Timer<TMilli> as Timer0;
        interface Timer<TMilli> as Timer1;
        interface Timer<TMilli> as StopTimer;
        interface Notify<button_state_t> as UserButtonNotify;
        interface AMSend;
        interface Receive;
        interface SplitControl as AMControl;
        interface Packet;
        interface Leds;
        interface SingleContext as CPUContext;
        interface RadioBackoff;

        interface LowPowerListening;
    }
}
implementation {

    enum {
        ACT_BOUNCE = 0x10,
        S_STARTED = 1, 
        S_IDLE,
        STOP_TIMER = 12000,
    };

    typedef nx_struct bounce_msg {
        nx_am_addr_t origin;
        nx_uint8_t ttl;
        //nx_uint8_t filler[8];
    } bounce_msg;

    /* This program will only work between the nodes
     * with _ID_1 and _ID_2 */
    enum {
        _ID_1 = 1,
        _ID_2 = 4,
    };

    enum {
        N = 2
    };
    message_t msg_buf[N];
    message_t* buffer[N];
    bool busy[N];

    am_addr_t peer;

    uint8_t state;
    bool stopped[N];
    
    /* Get a free buffer from the buffer pool
     * Return the buffer index, or N if not available */
    uint8_t getFreeBuffer() {
        uint8_t i;
        for (i = 0; i< N; i++)
            if (!busy[i])
                break;
        return i;
    }
    
    void setBusy(uint8_t i) {
        busy[i] = TRUE;
        if (i == 0)
            call Leds.led1On();
        else if (i == 1)
            call Leds.led0On();
    }
    
    void clearBusy(uint8_t i) {
        busy[i] = FALSE;
        if (i == 0)
            call Leds.led1Off();
        else if (i == 1)
            call Leds.led0Off();
    }

    uint8_t getNodeIndex(am_addr_t addr) {
        if (addr == _ID_1)
            return 0;
        if (addr == _ID_2)
            return 1;
        return 2;
    }

    uint8_t getBufferIndex(message_t* msg) {
        uint8_t i;
        for (i = 0; i < N; i++) 
            if (msg == buffer[i])
                break;
        return i;
    }


    uint16_t getTime () {
        return 512;
        //return (call Random.rand16() % 512);
    }

    void initState() {
        uint8_t i;
        state = S_IDLE;
        for (i = 0; i < N; i++) {
            clearBusy(i);
            stopped[i] = FALSE;
        }
    } 
    
    event void Boot.booted() {
        int i;
        peer = (TOS_NODE_ID == _ID_1)?_ID_2:_ID_1;
        call AMControl.start();
        for (i = 0; i < N; i++) 
            buffer[i] = &msg_buf[i];
        state = S_IDLE;
    }

    event void AMControl.startDone(error_t err) {
        if (err == SUCCESS) {
            initState();
#ifdef BOUNCE_LPL_INTERVAL
            call LowPowerListening.setLocalSleepInterval(BOUNCE_LPL_INTERVAL);
#endif
            call UserButtonNotify.enable();
        } else {
            call AMControl.start();
        }
    }

    event void AMControl.stopDone(error_t err) {
    }

    void scheduleSend(uint8_t i, uint16_t time) {
        if (i >= N)
            return;
        if (i == 0)
            call Timer0.startOneShot( time );
        else 
            call Timer1.startOneShot( time );
    }

    void send(uint8_t i) {
#ifdef BOUNCE_LPL_INTERVAL
        call LowPowerListening.setRxSleepInterval(buffer[i], BOUNCE_LPL_INTERVAL);
#endif
        if (call AMSend.send(peer, 
            buffer[i], sizeof(bounce_msg)) != SUCCESS) {
            scheduleSend(i, getTime());
        } 
    }

    event void Timer0.fired() {
        send(0);
    } 
    
    event void Timer1.fired() {
        send(1);
    }

    void start() {

        bounce_msg* bm;
        uint8_t i;
        act_t c;

        if (state != S_IDLE)
            return;

        c = call CPUContext.get();
        call CPUContext.set(mk_act_local(ACT_BOUNCE));

        state = S_STARTED;

        //scheduleSend for the first packet
        i = getFreeBuffer();
        if (!busy[i]) {
            setBusy(i);
            bm = call Packet.getPayload(buffer[i], sizeof(bounce_msg)); 
            bm->ttl = 10;
            bm->origin = TOS_NODE_ID;
            scheduleSend(i, getTime() >> 1);
        } 
        call StopTimer.startOneShot( STOP_TIMER );
        //restore the CPU Context
        call CPUContext.set(c);
    }

    event void StopTimer.fired() {
        call Timer0.stop();
        call Timer1.stop();
        initState();
    }

    void stop(am_addr_t addr) {
        uint8_t idx = getNodeIndex(addr);
        static uint8_t count_done = 0;
        if (idx >= N)
            return;
        if (!stopped[idx]) {
            stopped[idx] = TRUE;
            count_done++;
        }
        if (count_done == N) {
            //stop logging
            call StopTimer.stop();
            initState();
        }
    }
 
    event void UserButtonNotify.notify(button_state_t buttonState) {
        if (buttonState == BUTTON_PRESSED) {
            if (state == S_IDLE) {
                start();
            }
        }
    }


    event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
        message_t* rcv_buf;
        bounce_msg* bm = (bounce_msg*)payload;
        uint8_t i;
        if (state == S_IDLE) { 
            start();
        }
        if ((i = getFreeBuffer()) == N) {
            return msg;
        } else {
            //Bounce!
            //assert !busy[i] 
            rcv_buf = buffer[i];
            buffer[i] = msg;
            if (bm->ttl > 0) {
                setBusy(i);
                bm->ttl--;
                scheduleSend(i, getTime());
            } 
            if (bm->ttl == 0)
                stop(bm->origin);
            return rcv_buf;
        }
    } 

   
    event void AMSend.sendDone(message_t* msg, error_t err) {
        uint8_t i = getBufferIndex(msg);
        if (i >= N) 
            return;
        //assert busy[i]
        if (err == SUCCESS) {
            clearBusy(i);
        } else {
            scheduleSend(i, getTime());
        }
    }

    async event void RadioBackoff.requestInitialBackoff(message_t *msg) {
#ifdef NO_INITIAL_BACKOFF
        call RadioBackoff.setInitialBackoff(0);
#endif
    }

    async event void RadioBackoff.requestCongestionBackoff(message_t *msg) {
    }

    async event void RadioBackoff.requestCca(message_t *msg) {
    }

       
}
