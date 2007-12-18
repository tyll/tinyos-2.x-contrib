/**
 * Adapted for nxtmote.
 * @author Rasmus Ulslev Pedersen
 */
configuration HplAT91OSTimerC {

  provides {
    interface Init;
    interface HplAT91OSTimer as OST0;
  }

}

implementation {
  components HplAT91OSTimerM;
  components HplAT91InterruptM;

  Init = HplAT91OSTimerM;

  OST0 = HplAT91OSTimerM.AT91OST[0];
  
  HplAT91OSTimerM.OST0Irq -> HplAT91InterruptM.AT91Irq[AT91C_ID_TC0];
}
