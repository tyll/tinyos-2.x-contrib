
#include "Blaze.h"
#include "BlazeControl.h"
#include "IEEE802154.h"

/**
 * @author Jared Hill
 * @author David Moss
 */

configuration BlazeControlC {

  provides {
    interface SplitControl[ radio_id_t id ];
    //interface BlazeControl;  // TODO add in
    interface BlazeRegister as Rssi[uint8_t id];
    interface BlazePower[ radio_id_t id ];
  }
  
  uses {
    interface GeneralIO as Csn[ radio_id_t id ];
    interface State[uint8_t id];
  }
  
}

implementation {

  components BlazeControlP;
  SplitControl = BlazeControlP;
  Rssi = BlazeControlP;
  Csn = BlazeControlP;
  State = BlazeControlP;
  
  //BlazeControl = BlazeControlP;  // TODO add in

  components BlazeSpiC;
  BlazeControlP.CheckRadio -> BlazeSpiC.CheckRadio; 
  BlazeControlP.Idle -> BlazeSpiC.SIDLE;
  BlazeControlP.SRX -> BlazeSpiC.SRX;
  BlazeControlP.SFRX -> BlazeSpiC.SFRX;
  BlazeControlP.SRES -> BlazeSpiC.SRES;
  BlazeControlP.SXOFF -> BlazeSpiC.SXOFF;
  BlazeControlP.RadioStatus -> BlazeSpiC.RadioStatus;
  BlazeControlP.RssiReg -> BlazeSpiC.RSSI;
  
  components BlazeInitC;
  BlazePower = BlazeInitC;
  BlazeControlP.SubControl -> BlazeInitC;
  
  components LedsC;
  BlazeControlP.Leds -> LedsC;
  
  
}

