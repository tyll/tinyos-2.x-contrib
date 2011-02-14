interface OneWireDeviceInstanceManager{
  command uint8_t numDevices();
  command error_t setDevice(onewire_t id);
  command onewire_t currentDevice();

  command error_t refresh();
  event void refreshDone(error_t result)'
}
