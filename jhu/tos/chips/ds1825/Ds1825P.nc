/*
 * Wiring for DS 1825 driver
 * - This wires together:
 * -- Ds1825ImplP: the actual driver code
 * -- Ds1825TypeP: code to identify instances of DS1825's on the bus by ID
 * -- a new DeviceInstanceManager: to keep track of the DS1825 instances on the bus
 * -- OneWireBusC: notification of new instances, access to onewire comm primitives, locking
 */
generic Configuration Ds1825P(uint8_t clientId){
  provides{
    interface DeviceInstanceManager;
    interface Read<int16_t>;
  } 
}implementation{
  components Ds1825ImplP,
    Ds1825TypeP;
  components OneWireBusC, 
    new DeviceInstanceManagerC();
  
  DeviceInstanceManager = DeviceInstanceManagerC;
  Read = Ds1825ImplP.Read;
  
  Ds1825ImplP.Resource -> OneWireBusC.Resource[clientId];
  Ds1825ImplP.OneWireDeviceComm -> OneWireBusC.OneWireDeviceComm;
  Ds1825ImplP.DeviceInstanceManager -> DeviceInstanceManagerC;
  
  DeviceInstanceManagerC.OneWireDeviceType -> Ds1825TypeP;
  DeviceInstanceManagerC.OneWireDeviceMapper -> OneWireBusC.OneWireDeviceMapper;
}
