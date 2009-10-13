/**
 * An HPL abstraction of USART1 on the MSP430.
 *
 * @author Jonathan Hui <jhui@archedrock.com>
 * @author Joe Polastre
 * @version $Revision$ $Date$
 */

#include "msp430usart.h"

configuration HplMsp430UsciB1C {

  provides interface AsyncStdControl;
  provides interface HplMsp430UsciSpi;
  provides interface HplMsp430UsartInterrupts;

}

implementation {

  components HplMsp430UsciB1P as HplUsciBP;
  components HplMsp430GeneralIOC as GIO;
  components HplMsp430Usart1InterruptsP as IRQ;

  AsyncStdControl = HplUsciBP;
  HplMsp430UsciSpi = HplUsciBP;
  HplMsp430UsartInterrupts = IRQ.InterruptsB;

  HplUsciBP.SIMO -> GIO.SIMO1;
  HplUsciBP.SOMI -> GIO.SOMI1;
  HplUsciBP.UCLK -> GIO.UCLK1;

}
