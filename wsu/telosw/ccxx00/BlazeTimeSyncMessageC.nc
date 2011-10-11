/*
 * Copyright (c) 2007, Vanderbilt University
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the copyright holders nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * The Active Message layer for the CC2420 radio with timesync support. This
 * configuration is just layer above CC2420ActiveMessageC that supports
 * TimeSyncPacket and TimeSyncAMSend interfaces (TEP 133)
 *
 * @author: Miklos Maroti
 * @author: Brano Kusy (CC2420 port)
 * @author: Mingsen Xu
 */

#include <Timer.h>
#include <AM.h>
#include "BlazeTimeSyncMessage.h"

configuration BlazeTimeSyncMessageC
{
    provides
    {
        interface SplitControl;
        interface Receive[am_id_t id];
        interface Receive as Snoop[am_id_t id];
        interface Packet;
        interface AMPacket;
        interface PacketAcknowledgements;
        //interface LowPowerListening;
	interface PacketFooter;
    
        interface TimeSyncAMSend<T32khz, uint32_t> as TimeSyncAMSend32khz[am_id_t id];
        interface TimeSyncPacket<T32khz, uint32_t> as TimeSyncPacket32khz;

        interface TimeSyncAMSend<TMilli, uint32_t> as TimeSyncAMSendMilli[am_id_t id];
        interface TimeSyncPacket<TMilli, uint32_t> as TimeSyncPacketMilli;
    }
}

implementation
{
        components BlazeTimeSyncMessageP, BlazeActiveMessageC, BlazePacketC, LedsC;

        TimeSyncAMSend32khz = BlazeTimeSyncMessageP;
        TimeSyncPacket32khz = BlazeTimeSyncMessageP;

        TimeSyncAMSendMilli = BlazeTimeSyncMessageP;
        TimeSyncPacketMilli = BlazeTimeSyncMessageP;
	PacketFooter = BlazeTimeSyncMessageP;
        Packet = BlazeTimeSyncMessageP;
        // use the AMSenderC infrastructure to avoid concurrent send clashes
        components new AMSenderC(AM_TIMESYNCMSG);
        BlazeTimeSyncMessageP.SubSend -> AMSenderC;
      	BlazeTimeSyncMessageP.SubAMPacket -> AMSenderC;
        BlazeTimeSyncMessageP.SubPacket -> AMSenderC;

        BlazeTimeSyncMessageP.PacketTimeStamp32khz -> BlazePacketC;
        BlazeTimeSyncMessageP.PacketTimeStampMilli -> BlazePacketC;
        BlazeTimeSyncMessageP.PacketTimeSyncOffset -> BlazePacketC;
	
        components Counter32khz32C, new CounterToLocalTimeC(T32khz) as LocalTime32khzC, LocalTimeMilliC;
        LocalTime32khzC.Counter -> Counter32khz32C;
        BlazeTimeSyncMessageP.LocalTime32khz -> LocalTime32khzC;
        BlazeTimeSyncMessageP.LocalTimeMilli -> LocalTimeMilliC;
        BlazeTimeSyncMessageP.Leds -> LedsC;

        components ActiveMessageC;
        SplitControl = ActiveMessageC;
        PacketAcknowledgements = ActiveMessageC;
//         LowPowerListening = BlazeActiveMessageC;
        
        Receive = BlazeTimeSyncMessageP.Receive;
        Snoop = BlazeTimeSyncMessageP.Snoop;
        AMPacket = BlazeTimeSyncMessageP;
        BlazeTimeSyncMessageP.SubReceive -> ActiveMessageC.Receive[AM_TIMESYNCMSG];
        BlazeTimeSyncMessageP.SubSnoop -> ActiveMessageC.Snoop[AM_TIMESYNCMSG];
}
