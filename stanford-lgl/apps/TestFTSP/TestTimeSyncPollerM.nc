/*
 * Copyright (c) 2002, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * @author: Miklos Maroti, Brano Kusy (kusy@isis.vanderbilt.edu)
 * Ported to T2: 3/17/08 by Brano Kusy (branislav.kusy@gmail.com)
 */

includes Timer;
includes TestTimeSyncPollerMsg;

module TestTimeSyncPollerM
{
    provides 
    {
        interface StdControl;
        interface Init;
    }
    uses 
    {
        interface AMSend;
        interface Leds;
        interface Boot;
        interface Timer<TMilli>;
        interface SplitControl as RadioControl;
    }
}

implementation
{
    message_t msg;
    uint8_t last_id;
    uint32_t min,max;
        
    #define TimeSyncPollMsg ((TimeSyncPoll *)(msg.data))

    #ifndef TIMESYNC_POLLER_RATE
    #define TIMESYNC_POLLER_RATE 30
    #endif

    //command result_t StdControl.init(){
    command error_t Init.init(){
        TimeSyncPollMsg->senderAddr = TOS_NODE_ID;
        TimeSyncPollMsg->msgID = 0;
        return SUCCESS;
    }

    event void Boot.booted() {
	call RadioControl.start();
        call StdControl.start();
    }

    event void RadioControl.startDone(error_t error){};
    event void RadioControl.stopDone(error_t error){};

    command error_t StdControl.start(){
        call Timer.startPeriodic((uint32_t)1000 * TIMESYNC_POLLER_RATE);
        return SUCCESS;
    }

    command error_t StdControl.stop(){
        return SUCCESS;
    }
    
    event void AMSend.sendDone(message_t* pMsg, error_t error){
    }

    event void Timer.fired(){
        call Leds.led0Toggle();
        call AMSend.send(AM_BROADCAST_ADDR, &msg, TIMESYNCPOLL_LEN);
        ++(TimeSyncPollMsg->msgID);
    }
}
