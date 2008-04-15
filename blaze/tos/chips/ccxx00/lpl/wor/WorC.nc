
/** 
 * This is sort of the hardware implementation layer of Wake-on-Radio
 * @author David Moss
 */

#include "Blaze.h"
#include "Wor.h"

configuration WorC {
  provides {
    interface Wor[radio_id_t radioId];
  }
}

implementation {
  components MainC,
    WorP,
    new BlazeSpiResourceC(),
    BlazeSpiC, 
    BlazeCentralWiringC;
  
  MainC.SoftwareInit -> WorP;
  
  Wor = WorP;
  
  WorP.Resource -> BlazeSpiResourceC;
  WorP.MCSM2 -> BlazeSpiC.MCSM2;
  WorP.WOREVT1 -> BlazeSpiC.WOREVT1;
  WorP.WOREVT0 -> BlazeSpiC.WOREVT0;
  WorP.WORCTRL -> BlazeSpiC.WORCTRL;
  WorP.SWOR -> BlazeSpiC.SWOR;
  WorP.SIDLE -> BlazeSpiC.SIDLE;
  WorP.SRX -> BlazeSpiC.SRX;
  WorP.SFRX -> BlazeSpiC.SFRX;
  WorP.SFTX -> BlazeSpiC.SFTX;
  WorP.RadioStatus -> BlazeSpiC;
  WorP.ChipRdy -> BlazeCentralWiringC.Gdo2_io;
  WorP.Csn -> BlazeCentralWiringC.Csn;
  WorP.RxInterrupt -> BlazeCentralWiringC.Gdo0_int;
  
  components LedsC;
  WorP.Leds -> LedsC;
  
  components new TimerMilliC() as KickTimerC;
  WorP.KickTimer -> KickTimerC;
  
}

