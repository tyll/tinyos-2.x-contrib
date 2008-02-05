
/** 
 * Wake-on-Radio
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
  components WorP,
    new BlazeSpiResourceC(),
    BlazeSpiC, 
    BlazeCentralWiringC,
    new StateC();
  
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
  WorP.Csn -> BlazeCentralWiringC.Csn;
  WorP.State -> StateC;
}

