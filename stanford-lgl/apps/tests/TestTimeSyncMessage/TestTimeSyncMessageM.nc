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
 */ 

#include "TestTimeSyncMessage.h"

module TestTimeSyncMessageM
{
    uses 
    {
        interface Boot;
        interface Leds;

        interface SplitControl as RadioControl;
        interface AMSend as ReportSend;

        interface Receive as PollReceive;
        interface TimeSyncAMSend<TMilli, uint32_t> as PollSend;
        interface LocalTime<TMilli> as LocalTime;
        interface TimeSyncPacket<TMilli, uint32_t>;
        interface Packet as PollPacket;
        interface PacketTimeStamp<TMilli, uint32_t>;

        interface Timer<TMilli> as Timer1;
        interface Timer<TMilli> as Timer2;
    }
}

implementation
{
    message_t msg, msgReport;
    uint8_t last_id;
    uint32_t min,max;
        
//both of these conversions are approximate
    #define JIFFY2MS 5

    #ifndef TIMESYNC_POLLER_RATE
    #define TIMESYNC_POLLER_RATE 250
    #endif

    event void Boot.booted() {
      TimeSyncPoll *tsp = call PollSend.getPayload(&msg, sizeof(TimeSyncPoll)); 
      TimeSyncPollReport *tspr = 
        call ReportSend.getPayload(&msgReport, sizeof(TimeSyncPollReport)); 
      
      tsp->senderAddr = TOS_NODE_ID;
      tsp->msgID = 0;
      tsp->previous_tx_time = 0;
      tspr->localAddr = TOS_NODE_ID;

      call RadioControl.start();
      call Timer1.startPeriodic(TIMESYNC_POLLER_RATE);
      call Timer2.startPeriodic(30);//every 30ms, do some work
    }

    event void Timer1.fired(){
        TimeSyncPoll *tsp = call PollSend.getPayload(&msg, sizeof(TimeSyncPoll));
        ++(tsp->msgID);
        call PollSend.send(AM_BROADCAST_ADDR, &msg, sizeof(TimeSyncPoll),0);
        call Leds.led0Toggle();
    }

    task void foo(){
        uint32_t time = call LocalTime.get();
        while ((call LocalTime.get() - time) < (1<<JIFFY2MS));//keep CPU busy for 1ms
    }

    event void Timer2.fired(){
        post foo();
    }

    event message_t* PollReceive.receive(message_t* p, void* payload, uint8_t len){
        TimeSyncPoll *tsp = (TimeSyncPoll *)payload;
        TimeSyncPollReport *tspr = 
          call ReportSend.getPayload(&msgReport, sizeof(TimeSyncPollReport));
           
        call Leds.led1Toggle();
        tspr->senderAddr = tsp->senderAddr;
        tspr->msgID = tsp->msgID;
        tspr->receiveTime = call PacketTimeStamp.timestamp(p);
        tspr->eventTime = call TimeSyncPacket.eventTime(p);
        call ReportSend.send(AM_BROADCAST_ADDR, &msgReport, sizeof(TimeSyncPollReport));

        return p;
    }

    event void RadioControl.startDone(error_t error){};
    event void RadioControl.stopDone(error_t error){};
    event void PollSend.sendDone(message_t* p, error_t success){
        TimeSyncPoll *tsp = call PollSend.getPayload(p, sizeof(TimeSyncPoll));
        tsp->previous_tx_time = call PacketTimeStamp.timestamp(p);
    };
    event void ReportSend.sendDone(message_t* p, error_t success){};

}
