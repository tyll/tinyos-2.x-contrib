
configuration PlatformSerialC {
  
  provides interface StdControl;
  provides interface UartStream;
  provides interface UartByte;
  
}

implementation {
  
  components TelosSerialP;
  StdControl = TelosSerialP;
  TelosSerialP.Resource -> UartC.Resource;
  
  components new Msp430Uart1C() as UartC;
  UartStream = UartC;  
  UartByte = UartC;
  UartC.Msp430UartConfigure -> TelosSerialP;
  
}
