
configuration PlatformSerialC {
  
  provides interface StdControl;
  provides interface UartStream;
  
}

implementation {
  
  components new Msp430Uart0C() as UartC;
  UartStream = UartC;  
  
  components TelosSerialP;
  StdControl = TelosSerialP;
  TelosSerialP.Msp430UartConfigure <- UartC.Msp430UartConfigure;
  TelosSerialP.Resource -> UartC.Resource;
  
}
