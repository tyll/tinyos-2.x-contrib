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

#include "TestTimeStamping.h"

module TestTimeStampingM
{
    uses 
    {
        interface Boot;
        interface Leds;
        interface SplitControl as RadioControl;

        interface AMSend as PollSend;
        interface AMSend as ReportSend;
        interface Receive as PollReceive;

        interface Timer<TMilli> as Timer1;
        interface Timer<TMilli> as Timer2;
        
#ifdef TS_MICRO
        interface LocalTime<TMicro> as LocalTime;
        interface TimeStamping<TMicro,uint32_t> as TimeStamping;
#else
        interface LocalTime<T32khz> as LocalTime;
        interface TimeStamping<T32khz,uint32_t> as TimeStamping;
#endif
    }
}

implementation
{
    message_t msg, msgReport;
    uint8_t last_id;
    uint32_t min,max;
        
//both of these conversions are approximate
#ifdef TS_MICRO
		#define JIFFY2MS 10
#else
		#define JIFFY2MS 5
#endif

		#ifndef TIMESYNC_POLLER_RATE
    #define TIMESYNC_POLLER_RATE 20
    #endif

    event void Boot.booted() {
			TimeSyncPoll *tsp = call PollSend.getPayload(&msg, sizeof(TimeSyncPoll)); 
			TimeSyncPollReport *tspr = 
				call ReportSend.getPayload(&msgReport, sizeof(TimeSyncPollReport)); 
			
			tsp->senderAddr = TOS_NODE_ID;
			tsp->msgID = 0;
			tspr->localAddr = TOS_NODE_ID;

    	call RadioControl.start();
			call Timer1.startPeriodic(TIMESYNC_POLLER_RATE);
			call Timer2.startPeriodic(30);//every 30ms, do some work
    }

    event void Timer1.fired(){
				TimeSyncPoll *tsp = call PollSend.getPayload(&msg, sizeof(TimeSyncPoll)); 
        call Leds.led0Toggle();
        tsp->sendingTime = 0;
        if (call PollSend.send(AM_BROADCAST_ADDR, &msg, sizeof(TimeSyncPoll))==SUCCESS)
            call TimeStamping.addStamp(&msg, offsetof(TimeSyncPoll,sendingTime));

        ++(tsp->msgID);
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
        tspr->receiveTime = call TimeStamping.getStamp();
        if (tspr->receiveTime != 0)
            call ReportSend.send(AM_BROADCAST_ADDR, &msgReport, sizeof(TimeSyncPollReport));
        
        return p;
    }

    event void RadioControl.startDone(error_t error){};
    event void RadioControl.stopDone(error_t error){};
    event void PollSend.sendDone(message_t* p, error_t success){};
    event void ReportSend.sendDone(message_t* p, error_t success){};

}
