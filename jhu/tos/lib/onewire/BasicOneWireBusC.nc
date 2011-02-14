/*
 * Basic OneWire Bus component
 * - Clients SHOULD obtain the resource before issuing any commands to OneWireDeviceComm.
 * - This only exposes the basic onewire communication protocols and a shared resource representing the bus.
 */

configuration BasicOneWireBusC{
  provides{
    interface OneWireDeviceComm;
    interface Resource[uint8_t clientId];
  }
} implementation{
  components OneWireLowC,
    BasicOneWireBusP;

  //TODO: some kind of arbiter, up to count(ONEWIRE_CLIENT)
  //TODO: expose arbiter's resource

  OneWireDeviceComm = BasicOneWireBusP.OneWireDeviceComm;

  BasicOneWireBusP.OneWireLow -> OneWireLowC;
}
