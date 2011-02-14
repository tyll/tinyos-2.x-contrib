This directory contains HAL/HIL code for the DS1825 onewire
thermometer. You must include tos/lib/onewire and
tos/lib/onewire/interfaces to use it.

Ds1825C provides a Read and OneWireDeviceInstanceManager interface.  

* To discover Ds1825's on the onewire bus, use
  Ds1825C.OneWireDeviceInstanceManager.refresh/refreshDone.  

* To determine how many and which DS1825's are on the bus, use
  Ds1825C.OneWireDeviceInstanceManager.numDevices/getDevice.  

* To read the temperature from a specific DS1825, use
  Ds1825C.OneWireDeviceInstanceManager.setDevice then Ds1825C.Read. 

A normal usage of this would look something like this:

* call OneWireDeviceInstanceManager.refresh()
* (OneWireDeviceInstanceManager.refreshDone signalled)
* for i in 0...call OneWireDeviceInstanceManager.numDevices()
* * call OneWireDeviceInstanceManager.setDevice(call OneWireDeviceInstanceManager.getDevice(i))
* * call Read.read()
* * (readDone is signalled)
* * (store the value read + OneWireDeviceInstanceManager.currentDevice)

It's intended that future onewire device implementations have similar
wiring: A largely-standard wiring component connects the
OneWireDeviceType (specific to the device driver) to the
OneWireBusClientC, and connects the required interfaces from the
OneWireBusClientC to the driver implementation.  The driver
implementation may or may not need to be wired to the
OneWireDeviceInstanceManager exposed by OneWireBusClientC in order to
tell which device needs to be addressed.
