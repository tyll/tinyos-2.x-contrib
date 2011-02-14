/*
 * OneWire Device Mapper component
 * - This wires a new client into the BasicOneWireBusC component which handles device discovery.
 * - Any device drivers which wish to be notified when new instances are plugged in SHOULD access this through OneWireBusC
 */
generic configuration OneWireDeviceMapperC(uint8_t clientId){
  provides{
    interface OneWireDeviceMapper;
  }
} implementation{
  components OneWireDeviceMapperP, 
    BasicOneWireBusC;
  
  OneWireDeviceMapperP.OneWireDeviceComm -> BasicOneWireBusC.OneWireDeviceComm;
  OneWireDeviceMapperP.Resource -> BasicOneWireBusC.Resource[clientId];
  
  OneWireDeviceMapper = OneWireDeviceMapperP;
}
