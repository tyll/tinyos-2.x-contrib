/* Copyright (c) 2007 ETH Zurich.
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
*  $Id$
* 
*/

/**
 * @author Roman Lim
 */

configuration HarvesterC { }
implementation {
  components 
  	MainC,
  	HarvesterP,
  	LedsC,
  	new TimerMilliC(), 
  	new TimerMilliC() as TreeInfoTimer,
    //new DemoSensorC() as Sensor,
    //new SensirionSht11C() as Sensor,
    new SensirionSht71C() as Sensor,
  	DSNC,
  	new DsnCommandC("set lpl", uint16_t , 1) as LplCommand;
  	
//  HarvesterP.DSN -> DSNC;
  HarvesterP.LplCommand->LplCommand;

  
  HarvesterP.Boot -> MainC;
  HarvesterP.Timer -> TimerMilliC;
  HarvesterP.TreeInfoTimer -> TreeInfoTimer;
  HarvesterP.Read -> Sensor.Temperature;
  HarvesterP.Leds -> LedsC;

  //
  // Communication components.  These are documented in TEP 113:
  // Serial Communication, and TEP 119: Collection.
  //
  components CollectionC as Collector,   // Collection layer
    ActiveMessageC,                      // AM layer
    new CollectionSenderC(AM_HARVESTER), // Sends multihop RF
    SerialActiveMessageC;                // Serial messaging
    
 // lpl
   components CC2420ActiveMessageC as Lpl;
   HarvesterP.LowPowerListening->Lpl;
   //HarvesterP.CollectionLowPowerListening->Collector;

  HarvesterP.RadioControl -> ActiveMessageC;
  HarvesterP.AMPacket -> ActiveMessageC;
  HarvesterP.Packet -> ActiveMessageC;
  HarvesterP.PacketAcknowledgements -> ActiveMessageC;
  HarvesterP.SerialControl -> SerialActiveMessageC;
  HarvesterP.RoutingControl -> Collector;

  HarvesterP.Send -> CollectionSenderC;
  HarvesterP.SerialSend -> SerialActiveMessageC.AMSend;
  HarvesterP.SerialAMPacket -> SerialActiveMessageC;
  HarvesterP.SerialPacket -> SerialActiveMessageC;
  HarvesterP.Snoop -> Collector.Snoop[AM_HARVESTER];
  HarvesterP.Receive -> Collector.Receive[AM_HARVESTER];
  HarvesterP.RootControl -> Collector;
  
  // communication TreeInfo
  components	
  	new CollectionSenderC(AM_TREEINFO) as TreeCollectionSender;
  HarvesterP.TreeInfoReceive -> Collector.Receive[AM_TREEINFO];
  HarvesterP.TreeInfoSend -> TreeCollectionSender;
  
  HarvesterP.CtpInfo-> Collector;

  components
  	new PoolC(message_t, 10) as UARTMessagePoolP,
    new QueueC(message_t*, 10) as UARTQueueP;

  HarvesterP.UARTMessagePool -> UARTMessagePoolP;
  HarvesterP.UARTQueue -> UARTQueueP;
  
  components
  	CC2420TransmitP,
  	Counter32khz32C;
  //HarvesterP.AsyncNotify->CC2420TransmitP;
  HarvesterP.Counter->Counter32khz32C;

  components
  	TraceSchedulerC,
  	new TimerMilliC() as LoadTimer;
  HarvesterP.ReadCpuLoad->TraceSchedulerC;
  HarvesterP.LoadTimer->LoadTimer;
  
}
