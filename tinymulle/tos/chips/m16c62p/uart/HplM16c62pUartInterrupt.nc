/**
 * Interface for interrupt signals from a uart.
 *
 * @author Henrik Makitaavola
 */
interface HplM16c62pUartInterrupt
{
  /** 
   * Signal when an tx interrupt occurs.
   */  
  async event void tx();

  /** 
   * Signal when an rx interrupt occurs.
   */  
  async event void rx();
}

