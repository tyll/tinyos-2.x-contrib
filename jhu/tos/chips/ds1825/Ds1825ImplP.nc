/*
 * DS 1825 Driver implementation
 * - Exposes the functionality of a DS 1825 device on a onewire bus with the Read interface.
 * - Hides the low-level details
 * - Hides locking the bus with split-phase read
 */
module Ds1825ImplP{
  uses{
    interface OneWireDeviceComm;
    interface Resource;
    interface DeviceInstanceManager;
  }
  provides{
    interface Read<int16_t>;
  }
  //Read: request resource if DIM.currentDevice is legit
  //resource granted: address selectedDevice, go through read commands, release resource, signal readDone

  //read logic can be made more complex, if, for instance, we want to send CONVERT to all devices on the first read, then respond to subsequent reads (within some time window) by just reading the scratchpad of those devices.
}
