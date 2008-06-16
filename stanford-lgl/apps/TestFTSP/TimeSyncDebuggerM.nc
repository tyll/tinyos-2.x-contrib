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

module TimeSyncDebuggerM
{
    provides
    {
        interface StdControl;
        interface Init;
    }
    uses
    {
        interface GlobalTime<TMilli>;
        interface TimeSyncInfo;
        interface Receive;
        interface AMSend;
        interface Timer<TMilli>;
        interface Leds;
        interface PacketTimeStamp<TMilli,uint32_t>;
        interface Boot;
        interface SplitControl as RadioControl;
    }
}

implementation
{
    message_t msg;
    bool reporting;

    command error_t Init.init() {
        reporting = FALSE;
        return SUCCESS;
    }

    event void Boot.booted() {
        call RadioControl.start();
        call StdControl.start();
    }

    event void RadioControl.startDone(error_t error){}
    event void RadioControl.stopDone(error_t error){}

    command error_t StdControl.start() {
        call Timer.startPeriodic(3000); //report msg is sent at most 3 sec after polled
        return SUCCESS;
    }

    command error_t StdControl.stop() {
        call Timer.stop();
        return SUCCESS;
    }

    task void report() {
        if( reporting )
        {
            call Leds.led2Toggle();
            if (call AMSend.send(AM_BROADCAST_ADDR, &msg, sizeof(TimeSyncPollReply)) != SUCCESS){
                if(post report()!=SUCCESS)
                    reporting = FALSE;
            }
        }
    }

    event void AMSend.sendDone(message_t* ptr, error_t success){
        reporting = FALSE;
        return;
    }

    event void Timer.fired() {
        if( reporting )
            post report();
    }

    event message_t* Receive.receive(message_t* p, void* payload, uint8_t len)
    {
        uint32_t localTime;
        TimeSyncPollReply* pPollReply = (TimeSyncPollReply*)(msg.data);
        if( !reporting && call PacketTimeStamp.isValid(p))
        {
            localTime = call PacketTimeStamp.timestamp(p);

            pPollReply->nodeID = TOS_NODE_ID;
            pPollReply->msgID = ((TimeSyncPoll*)(p->data))->msgID;
            pPollReply->localClock = localTime;
            pPollReply->is_synced = call GlobalTime.local2Global(&localTime);
            pPollReply->globalClock = localTime;
            pPollReply->skew = (uint32_t)call TimeSyncInfo.getSkew()*1000000UL;
            pPollReply->rootID = call TimeSyncInfo.getRootID();
            pPollReply->seqNum = call TimeSyncInfo.getSeqNum();
            pPollReply->numEntries = call TimeSyncInfo.getNumEntries();

            reporting = TRUE;
        }

        return p;
    }
}
