configuration HplSCCBC
{
  provides {
	interface HplSCCB[uint8_t IdentAddr];
  }
}
implementation {
  components HplSCCBM, LedsC, GeneralIOC;

  // Interface wiring
  HplSCCB	= HplSCCBM; 

  // Component wiring
  HplSCCBM.Leds -> LedsC.Leds;
  HplSCCBM.SIOD -> GeneralIOC.GeneralIO[56];	//A40-3 
  HplSCCBM.SIOC -> GeneralIOC.GeneralIO[57];	//A40-4 
}
