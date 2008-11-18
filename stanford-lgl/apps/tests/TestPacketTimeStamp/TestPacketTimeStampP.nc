/*
* Copyright (c) 2006 Stanford University.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/ 
/**
 * @author Brano Kusy (branislav.kusy@gmail.com)
 * - radio message timestamping test application
 * - tests both message reception and transmission timestamps
 * - each node periodically broadcasts TimeStampPoll messages which are
 *   timestamped at both sender and receiver. TimeStampPoll message includes
 *   previous timestamp of the sender. receiver reports both reception timestamp
 *   and the previous sender timestamp.
 * - BusyTimer fires periodically to simulate CPU load
 */

#include "TestPacketTimeStamp.h"
#include "Timer.h"

module TestPacketTimeStampP
{
    uses 
    {
        interface Boot;
        interface Leds;

        interface SplitControl as RadioControl;
        interface AMSend as ReportSend;
        interface AMSend as PollSend;
        interface Receive as PollReceive;
        interface PacketTimeStamp<T32khz, uint32_t>;

        interface Timer<TMilli> as BcastTimer;
        interface Timer<TMilli> as BusyTimer;
    }
}

implementation
{
    #ifndef TIMESYNC_POLLER_RATE
    #define TIMESYNC_POLLER_RATE 250
    #endif

    message_t msg, msgReport;

    event void Boot.booted() {
      TimeStampPoll *tsp = call PollSend.getPayload(&msg, sizeof(TimeStampPoll));
      TimeStampPollReport *tspr =
        call ReportSend.getPayload(&msgReport, sizeof(TimeStampPollReport));
      
      tsp->senderAddr = TOS_NODE_ID;
      tsp->msgID = 0;
      tsp->previousSendTime = 0;
      tspr->localAddr = TOS_NODE_ID;

      call RadioControl.start();
      call BcastTimer.startPeriodic(TIMESYNC_POLLER_RATE);
      call BusyTimer.startPeriodic(30);//every 30ms, do some work
    }

    event void BcastTimer.fired(){
        TimeStampPoll *tsp = call PollSend.getPayload(&msg, sizeof(TimeStampPoll));
        ++(tsp->msgID);
        call PollSend.send(AM_BROADCAST_ADDR, &msg, sizeof(TimeStampPoll));
        call Leds.led0Toggle();
    }

    task void foo(){
        uint32_t time = call BusyTimer.getNow();
        while ((call BusyTimer.getNow() - time) < 5);//keep CPU busy
    }

    event void BusyTimer.fired(){
        post foo();
    }

    event message_t* PollReceive.receive(message_t* p, void* payload, uint8_t len){
        TimeStampPoll *tsp = (TimeStampPoll *)payload;
        TimeStampPollReport *tspr =
            call ReportSend.getPayload(&msgReport, sizeof(TimeStampPollReport));
           
        call Leds.led1Toggle();
        tspr->senderAddr = tsp->senderAddr;
        tspr->msgID = tsp->msgID;
        tspr->previousSendTime = tsp->previousSendTime;

        if (tsp->previousSendTime!=0 && call PacketTimeStamp.isValid(p))
        {
            tspr->receiveTime = call PacketTimeStamp.timestamp(p);
            call ReportSend.send(AM_BROADCAST_ADDR, &msgReport, sizeof(TimeStampPollReport));
        }

        return p;
    }

    event void RadioControl.startDone(error_t error){};
    event void RadioControl.stopDone(error_t error){};
    event void PollSend.sendDone(message_t* p, error_t success){
        TimeStampPoll *tsp = call PollSend.getPayload(p, sizeof(TimeStampPoll));
        if (call PacketTimeStamp.isValid(p))
            tsp->previousSendTime = call PacketTimeStamp.timestamp(p);
        else
            tsp->previousSendTime = 0;
    };
    event void ReportSend.sendDone(message_t* p, error_t success){};

}
