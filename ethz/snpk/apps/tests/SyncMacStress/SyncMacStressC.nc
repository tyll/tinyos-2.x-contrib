configuration SyncMacStressC { }
implementation {
  components 
  	MainC,
  	SyncMacStressP,
  	LedsC,
  	DSNC;

  SyncMacStressP.DSN -> DSNC;
  SyncMacStressP.Boot -> MainC;
  SyncMacStressP.Leds -> LedsC;

  components 
   ActiveMessageC,              
   new AMSenderC(AM_TEST) as AMSender;
  // lpl
  components CC2420ActiveMessageC as Lpl;
  SyncMacStressP.LowPowerListening->Lpl;

  SyncMacStressP.RadioControl -> ActiveMessageC;
  SyncMacStressP.AMPacket -> ActiveMessageC;
  SyncMacStressP.Packet -> ActiveMessageC;
  SyncMacStressP.PacketAcknowledgements -> ActiveMessageC;

  SyncMacStressP.Send -> AMSender;
  SyncMacStressP.Receive -> ActiveMessageC.Receive[AM_TEST];
  //Sensors
  components new SensirionSht11C() as InternalSensirion, new SensirionSht71C() as ExternalSensirion;
  SyncMacStressP.ReadExternalTemperature -> ExternalSensirion.Temperature;
  SyncMacStressP.ReadExternalHumidity -> ExternalSensirion.Humidity;
  SyncMacStressP.ReadInternalTemperature -> InternalSensirion.Temperature;
  SyncMacStressP.ReadInternalHumidity -> InternalSensirion.Humidity;

}

