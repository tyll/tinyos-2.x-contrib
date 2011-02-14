/*
 * Allocate a new client ID for the DS 1825 digital thermometer
 */
configuration Ds1825C{
  provides{
    interface Read<int16_t>;
    interface DeviceInstanceManager;
  }
}implementation{
  components new Ds1825P(unique(ONEWIRE_CLIENT));
  
  Read = Ds1825P.Read;
  DeviceInstanceManager = Ds1825P.DeviceInstanceManger;
}
