interface OneWireDeviceComm{
  command error_t writeByte(uint8_t b);
  command error_t readByte(uint8_t* buf);
  command error_t addressDevice(onewire_t id);
}
