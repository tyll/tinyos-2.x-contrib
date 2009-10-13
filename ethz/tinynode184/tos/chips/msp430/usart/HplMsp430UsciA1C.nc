/**
 * An HPL abstraction of USART1 on the MSP430.
 *
 * @author Jonathan Hui <jhui@archedrock.com>
 * @author Joe Polastre
 * @version $Revision$ $Date$
 */

#include "msp430usart.h"

configuration HplMsp430UsciA1C {

  provides interface AsyncStdControl;
  provides interface HplMsp430UsciSpi;
  provides interface HplMsp430UsciUart;
  provides interface HplMsp430UsartInterrupts;

}

implementation {

  components HplMsp430UsciA1P as HplUsciAP;
  components HplMsp430GeneralIOC as GIO;
  components HplMsp430Usart1InterruptsP as IRQ;

  AsyncStdControl = HplUsciAP;
  HplMsp430UsciUart = HplUsciAP;
  HplMsp430UsciSpi = HplUsciAP;
  HplMsp430UsartInterrupts = IRQ.InterruptsA;

  HplUsciAP.SIMOTX -> GIO.UTXD1;
  HplUsciAP.SOMIRX -> GIO.URXD1;
  HplUsciAP.UCLK -> GIO.STE1;

}
