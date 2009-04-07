/**
 * Interface for interrupt signal from a timer.
 *
 * @author Henrik Makitaavola
 */
interface HplM16c62pTimerInterrupt
{
  /** 
   * Signal when an overflow/underflow interrupt occurs on a timer.
   */  
  async event void fired();
}

