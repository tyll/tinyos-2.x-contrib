
configuration PlatformSerialC {
  
  provides interface StdControl;
  provides interface UartStream;
  provides interface UartByte;
  
}

implementation {
  
  components new Msp430Uart1C() as UartC;
  UartStream = UartC;  
  UartByte = UartC;
  
  components Ecosens1SerialP;
  StdControl = Ecosens1SerialP;
  Ecosens1SerialP.Msp430UartConfigure <- UartC.Msp430UartConfigure;
  Ecosens1SerialP.Resource -> UartC.Resource;
  
}
