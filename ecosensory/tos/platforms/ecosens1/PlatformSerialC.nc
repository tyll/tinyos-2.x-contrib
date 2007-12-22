/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
* BSD license full text at: 
* http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
* derived author unknown telosb  John Griessen 13 Dec 2007
 */
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
