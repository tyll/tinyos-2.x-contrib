/*
 * Copyright (c) 2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 * MultihopOscilloscope demo application using the collection layer. 
 * See README.txt file in this directory and TEP 119: Collection.
 *
 * @author David Gay
 * @author Kyle Jamieson
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
  	
  LplCommand.DSN->DSNC;
  HarvesterP.DSN -> DSNC;
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
  
  components CC2420DutyCycleC;
  HarvesterP.CC2420DutyCycle->CC2420DutyCycleC;

}
