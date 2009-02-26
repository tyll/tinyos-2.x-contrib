configuration AntiTheftRootAppC { }
implementation {
  components AntiTheftRootC;

  components SerialActiveMessageC,
    new SerialAMReceiverC(AM_SETTINGS) as PCSettings,
    new SerialAMSenderC(AM_THEFT) as PCTheft;

  AntiTheftRootC.SerialControl -> SerialActiveMessageC;
  AntiTheftRootC.RSettings -> PCSettings;
  AntiTheftRootC.STheft -> PCTheft;

  components MainC, ActiveMessageC, LedsC;
  AntiTheftRootC.Boot -> MainC;
  AntiTheftRootC.Leds -> LedsC;
  AntiTheftRootC.CommControl -> ActiveMessageC;

  components DisseminationC, new DisseminatorC(settings_t, DIS_THEFT);
  AntiTheftRootC.DisseminationControl -> DisseminationC;
  AntiTheftRootC.USettings -> DisseminatorC;

  components CollectionC;
  AntiTheftRootC.CollectionControl -> CollectionC;
  AntiTheftRootC.RootControl -> CollectionC;
  AntiTheftRootC.RTheft -> CollectionC.Receive[COL_THEFT];
}  
