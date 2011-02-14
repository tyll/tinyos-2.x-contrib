/*
 * Implementation of Onewire device discovery process
 * - Notifies subscribers of this interface when new devices are found.
 * - maintains master list of all devices on the bus.
 * - handles locking/unlocking the bus to prevent interference with other users.
 */ 
module OneWireDeviceMapperP{
  uses{
    interface OneWireLow;
    interface Resource;
  }
  provides{
    interface OneWireDeviceMapper;
  }
} implementation {
  //refresh: get resource
  //resource granted: go through identification process, release, then signal listeners
}
