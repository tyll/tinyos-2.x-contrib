//#include "OV7649.h"
configuration HplOV7649C
{
  provides interface HplOV7649;
  provides interface HplOV7649Advanced;
}
implementation {
  components HplOV7649M, LedsC, HplSCCBC, GeneralIOC;

  // Interface wiring
  HplOV7649	= HplOV7649M; 
  HplOV7649Advanced	= HplOV7649M; 

  // Component wiring
  HplOV7649M.Leds -> LedsC.Leds;
  HplOV7649M.Sccb_OVWRITE -> HplSCCBC.HplSCCB[0x42];//OVWRITE

  HplOV7649M.RESET -> GeneralIOC.GeneralIO[83];	//A40-5 
  HplOV7649M.PWDN -> GeneralIOC.GeneralIO[82];	//A40-1 
  HplOV7649M.LED -> GeneralIOC.GeneralIO[106];	//A40-29 

  HplOV7649M.SIOD -> GeneralIOC.GeneralIO[56];	//A40-3 
  HplOV7649M.SIOC -> GeneralIOC.GeneralIO[57];	//A40-4 

}
