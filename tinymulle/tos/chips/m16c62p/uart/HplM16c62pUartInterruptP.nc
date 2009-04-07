/**
 * All uart interrupt vector handlers.
 * These are wired in HplM16c62pUartC.
 *
 * @author Henrik Makitaavola
 */

module HplM16c62pUartInterruptP @safe()
{
  provides interface HplM16c62pUartInterrupt as Uart0;
  provides interface HplM16c62pUartInterrupt as Uart1;
  provides interface HplM16c62pUartInterrupt as Uart2;
}
implementation
{
  default async event void Uart0.tx() { } 
  M16C_INTERRUPT_HANDLER(M16C_UART0_NACK)
  {
    signal Uart0.tx();
  }

  default async event void Uart0.rx() { } 
  M16C_INTERRUPT_HANDLER(M16C_UART0_ACK)
  {
    signal Uart0.rx();
  }


  default async event void Uart1.tx() { } 
  M16C_INTERRUPT_HANDLER(M16C_UART1_NACK)
  {
    signal Uart1.tx();
  }

  default async event void Uart1.rx() { } 
  M16C_INTERRUPT_HANDLER(M16C_UART1_ACK)
  {
    signal Uart1.rx();
  }


  default async event void Uart2.tx() { } 
  M16C_INTERRUPT_HANDLER(M16C_UART2_NACK)
  {
    signal Uart2.tx();
  }

  default async event void Uart2.rx() { } 
  M16C_INTERRUPT_HANDLER(M16C_UART2_ACK)
  {
    signal Uart2.rx();
  }
}
