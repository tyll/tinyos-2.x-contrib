/*
 * @author David Moss
 */

configuration BlazeCentralWiringC {
  provides {
    interface GeneralIO as Csn[radio_id_t radioId];
    interface GeneralIO as Power[radio_id_t radioId];
  }
}

implementation {

  components HplCC2500PinsC;
  
  Csn[0] = HplCC2500PinsC.Csn;
  Power[0] = HplCC2500PinsC.Power;
  
}

