/*
 * SenZip trial app configuration
 *
 * @ author        Sundeep Pattem
 * @ affiliation   Autonomous Networks Research Group
 * @ institution   University of Southern California
*/

configuration SenZipAppC {}
implementation {
  components SenZipC, MainC, LedsC, ActiveMessageC;
  components CollectionC as Collector;
  components new CollectionSenderC(0xee);
  components new TimerMilliC() as MeasurementTimer;
  
  SenZipC.Boot -> MainC;
  SenZipC.RadioControl -> ActiveMessageC;
  SenZipC.RoutingControl -> Collector;
  SenZipC.Leds -> LedsC;
  SenZipC.RootControl -> Collector;
  SenZipC.Send -> CollectionSenderC;
  SenZipC.MeasurementTimer -> MeasurementTimer;
  SenZipC.Measurements -> Collector;
  SenZipC.StartGathering -> Collector; 
  SenZipC.SubReceive -> Collector.Receive[0];

  components new SensirionSht11C() as Sensor;
  SenZipC.Temperature -> Sensor.Temperature;

  components new AMReceiverC(AM_BASE_MSG) as BaseRec;
  SenZipC.BaseReceive -> BaseRec;
  components new AMSenderC(AM_BASE_MSG) as BaseSender;
  SenZipC.BaseSend -> BaseSender;
  SenZipC.BasePacket -> BaseSender;

  components new PoolC(message_t, 30) as QEntryPoolP;
  SenZipC.QEntryPool -> QEntryPoolP;

  components new QueueC(message_t*, 30) as SendQueueP;
  SenZipC.SendQueue -> SendQueueP;
}
