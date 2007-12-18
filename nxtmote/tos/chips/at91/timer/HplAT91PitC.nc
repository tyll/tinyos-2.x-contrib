/**
 * Periodic Interval Timer. 
 * Adapted for nxtmote.
 * @author Rasmus Ulslev Pedersen
 */
configuration HplAT91PitC {

  provides {
    interface Init;
    interface HplAT91Pit;
  }
  
  //uses {
  //  interface HplAT91Interrupt;
  //}

}

implementation {
  components HplAT91PitM, HplAT91InterruptM;

  Init = HplAT91PitM;

  HplAT91Pit = HplAT91PitM;

  HplAT91PitM.SysIrq -> HplAT91InterruptM.AT91Irq[AT91C_ID_SYS];
}
