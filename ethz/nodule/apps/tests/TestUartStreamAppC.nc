/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */  

configuration TestUartStreamAppC
{
}
implementation
{
  components MainC, TestUartStreamC;
  TestUartStreamC -> MainC.Boot;

  components LedsC;
  TestUartStreamC.Leds -> LedsC;

  components SystemLedC;
  TestUartStreamC.SystemLed -> SystemLedC;

  components ButtonC;
  TestUartStreamC.Button1 -> ButtonC.Button1;
  TestUartStreamC.Button2 -> ButtonC.Button2;

//  components HplAt32uc3bUartStreamNoReceiveNoDmaC;
//  TestUartStreamC.UartStreamInit -> HplAt32uc3bUartStreamNoReceiveNoDmaC.Uart1Init;
//  TestUartStreamC.UartStream -> HplAt32uc3bUartStreamNoReceiveNoDmaC.Uart1;

  components HplAt32uc3bUartStreamNoReceiveC;
  TestUartStreamC.UartStreamInit -> HplAt32uc3bUartStreamNoReceiveC.Uart1Init;
  TestUartStreamC.UartStream -> HplAt32uc3bUartStreamNoReceiveC.Uart1;

  components PeripheralDmaControllerC;
  HplAt32uc3bUartStreamNoReceiveC.Uart1DmaTx -> PeripheralDmaControllerC.Usart1Tx[unique("Dma")];
}
