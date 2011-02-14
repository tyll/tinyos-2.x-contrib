configuration DummyOWC {
  provides {
    interface OneWireDeviceInstanceManager;
    interface Read<int16_t>;
  } 
} 
implementation {
  components new TimerMilliC();

  //device-type specific code 
  components DummyOWP,
    DummyOWTypeP;

  //wire device-type specific code to bus interfaces for resource, master, and device instance manager.
  //this will be mainly boilerplate 
  components new OneWireBusClientC(1);
  DummyOWP.Resource -> OneWireBusClientC.Resource;
  DummyOWP.OneWireMaster -> OneWireBusClientC.OneWireMaster;
  DummyOWP.OneWireDeviceInstanceManager -> OneWireBusClientC.OneWireDeviceInstanceManager;

  OneWireDeviceInstanceManager = OneWireBusClientC.OneWireDeviceInstanceManager;
  Read = DummyOWP.Read;


  DummyOWP.Timer -> TimerMilliC;
 
  //wire device-type identifier into client
  OneWireBusClientC.OneWireDeviceType -> DummyOWTypeP;
}
