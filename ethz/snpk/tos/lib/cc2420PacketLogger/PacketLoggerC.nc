/* Copyright (c) 2008 ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.btnode.ethz.ch/
* 
*  @author: Roman Lim <lim@tik.ee.ethz.ch>
*
*/
#include "StorageVolumes.h"
#include "packetlogger.h"
configuration PacketLoggerC {
}
implementation {
	components PacketLoggerP;
	components new LogStorageC(VOLUME_PACKETLOG, FALSE);
	components NeighbourSyncC;
	components DSNC;
	components Counter32khz32C;
	components new CounterToLocalTimeC(T32khz);
	components CC2420PacketC;
	components new DsnCommandC("packetlogger", uint16_t , 3) as PacketLoggerCommand;
	components CC2420CsmaC;
	components PowerCycleC;
	
	CounterToLocalTimeC.Counter->Counter32khz32C;
	PacketLoggerP.LogRead->LogStorageC;
	PacketLoggerP.LogWrite->LogStorageC;
	PacketLoggerP.PacketLogger->NeighbourSyncC;
	PacketLoggerP.LocalTime->CounterToLocalTimeC;
	PacketLoggerP.CC2420PacketBody->CC2420PacketC;
	PacketLoggerP.PacketLoggerCommand->PacketLoggerCommand;
	PacketLoggerP.DsnSend->DSNC;
	PacketLoggerP.RadioControl -> CC2420CsmaC;
	PacketLoggerP.PowerCycle->PowerCycleC;
	
	components
	  	new PoolC(packet_logger_event_t, 10),
	    new QueueC(packet_logger_event_t*, 10);

	PacketLoggerP.Pool -> PoolC;
	PacketLoggerP.Queue -> QueueC;
}
