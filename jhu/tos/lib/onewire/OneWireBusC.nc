/*
 * OneWire Bus component
 * - In addition to the onewire communication primitives exposed by BasicOneWireBusC, this also includes the device mapper.
 * - Components using this SHOULD observe the same restrictions on resource/comm usage specified in BasicOneWireBusC.
 */

configuration OneWireBusC{
  provides{
    interface OneWireDeviceComm;
    interface Resource[uint8_t clientId];
    interface OneWireDeviceMapper;
  }
} implementation{
  components new OneWireDeviceMapperC(unique(ONEWIRE_CLIENT)),
    BasicOneWireBusC;
  
  OneWireDeviceComm = BasicOneWireBusC.OneWireDeviceComm;
  Resource = BasicOneWireBusC.Resource;
    
  OneWireDeviceMapper = OneWireDeviceMapperC;
}
