module OneWireDeviceInstanceManagerP{
  uses{
    interface OneWireDeviceType;
    interface OneWireDeviceMapper;
  }
} implementation{
  //state: count/list of devices associated with this type. currently set device.
  //if not initialized and numDevices called, refresh with mapper.
  //mapper.refreshDone: if devices changed, iterate over them and test to see which ones match device type. update list accordingly.
}
