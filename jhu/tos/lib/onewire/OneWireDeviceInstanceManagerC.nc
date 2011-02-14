generic configuration OneWireDeviceInstanceManagerC(){
  provides{
    interface OneWireDeviceInstanceManager;
  }
  uses{
    interface OneWireDeviceMapper;
    interface OneWireDeviceType;
  }
} implementation {
  //TODO: might be a little funny re: generics here
  components OneWireDeviceInstanceManagerP;
  OneWireDeviceInstanceManager = OneWireDeviceInstanceManagerP;
  
  OneWireDeviceInstanceManagerP.OneWireDeviceMapper = OneWireDeviceMapper;
  OneWireDeviceInstanceManagerP.OneWireDeviceType = OneWireDeviceType;  
}
