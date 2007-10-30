/*
 * Copyright (c) 2007, ETH Zuerich
 * All rights reserved.
 * Author: Min Guo
 */

#include "TimeSyncMsg.h"
#include "message.h"
configuration TimeSyncAppC
{
	provides interface GlobalTime;
}

implementation 
{       
        components CC2420TransmitC, CC2420PacketC;
        components new TimerMilliC() as Timer0;
        components Counter32khz32C;        
        components ActiveMessageC;
        components new AMSenderC(AM_TIMESYNCMSG);
        components new AMReceiverC(AM_TIMESYNCMSG);
        components TimeSyncC, LedsC, MainC;
        components new CounterToLocalTimeC(T32khz);
        GlobalTime = TimeSyncC;
        TimeSyncC.AMSend -> AMSenderC;
        TimeSyncC.Receive -> AMReceiverC;
        TimeSyncC.AMControl -> ActiveMessageC;
        TimeSyncC.Packet -> AMSenderC;
        TimeSyncC.AMPacket -> AMSenderC;
        TimeSyncC.Boot -> MainC;
        TimeSyncC.Timer0 -> Timer0;
        TimeSyncC.Leds -> LedsC;
        CounterToLocalTimeC.Counter -> Counter32khz32C;
        TimeSyncC.LocalTime -> CounterToLocalTimeC;
        TimeSyncC.RadioTimeStamping -> CC2420TransmitC;
        TimeSyncC.CC2420Transmit -> CC2420TransmitC;
        TimeSyncC.CC2420PacketBody -> CC2420PacketC;

        components DSNC;
        TimeSyncC.DsnSend->DSNC;
}
