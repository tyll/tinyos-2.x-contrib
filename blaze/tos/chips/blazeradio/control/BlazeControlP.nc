

#include "Blaze.h"
#include "BlazeControl.h"

/**
 * This module assumes it already owns the SPI bus
 * @author Jared Hill 
 */
module BlazeControlP {

  provides {
    interface SplitControl[ radio_id_t id ];
    interface BlazeRegister as Rssi[ radio_id_t id ];
  }
  
  uses {
    interface GeneralIO as Csn[ radio_id_t id ];

    interface SplitControl as SubControl[ radio_id_t id ];
    interface State[uint8_t id];
    
    interface BlazeStrobe as Idle;
    interface BlazeStrobe as SRX;
    interface BlazeStrobe as SFRX;
    interface BlazeStrobe as SRES;
    interface BlazeStrobe as SXOFF;
  
    interface BlazeRegister as RssiReg;
  
    interface CheckRadio;
    interface RadioStatus;
    
    interface Leds;
  }
}

implementation {
  
  /***************** Prototypes ****************/

  /***************** SplitControl Commands ****************/
  /**
   * Make the radio ready to use
   */
  command error_t SplitControl.start[ radio_id_t id ](){
  
    if(call State.isState[id](S_RADIO_OFF)) {
      call State.forceState[ id ](S_RADIO_INIT);
      return call SubControl.start[ id ]();
      
    } else if(call State.isState[id](S_RADIO_INIT)) {
      return SUCCESS;
    
    } else if(call State.isState[id](S_RADIO_ON)) { 
      return EALREADY;
    }
    
    return EBUSY;
  }
  
  command error_t SplitControl.stop[ radio_id_t id ]() {
    if(call State.isState[id](S_RADIO_ON)) {
      call State.forceState[id](S_RADIO_STOPPING);
      return call SubControl.stop[ id ]();
    
    } else if(call State.isState[id](S_RADIO_STOPPING)) {
      return SUCCESS;

    } else if(call State.isState[id](S_RADIO_OFF)) {
      return EALREADY;
    }
    
    return EBUSY;
  }
  
  /***************** SubControl Events ****************/
  event void SubControl.startDone[ radio_id_t id ](error_t error) {
    uint8_t status;
        
    call State.forceState[ id ](S_RADIO_ON);
    
    signal SplitControl.startDone[ id ](error);
    
  }
  
  event void SubControl.stopDone[ radio_id_t id ](error_t error) {
    call State.forceState[ id ](S_RADIO_OFF);
    signal SplitControl.stopDone[ id ]( error );
  }
  
  /************* Rssi Commands *********************/
  async command blaze_status_t Rssi.read[ radio_id_t id ](uint8_t* data) {
    blaze_status_t status;
    call Csn.clr[ id ]();
    call CheckRadio.waitForWakeup();
    status = call RssiReg.read(data);
    call Csn.set[ id ]();
    return status;
  }

  async command blaze_status_t Rssi.write[ radio_id_t ](uint8_t data) {
    // Cannot write to this register 
    return 0;
  }
  
  /***************** Functions ******************/

  
  /***************** Defaults ****************/
  default event void SplitControl.startDone[ radio_id_t id ](error_t error) {}
  default event void SplitControl.stopDone[ radio_id_t id ](error_t error) {}
  
  default async command void State.toIdle[ radio_id_t id ](){}
  default async command error_t State.requestState[ radio_id_t id ](uint8_t state) { return FAIL; }
  default async command void State.forceState[ radio_id_t id ](uint8_t state) { }
  default async command uint8_t State.getState[ radio_id_t id ](){ return 0; }
  default async command bool State.isIdle[ radio_id_t id ](){ return FALSE; }
  default async command bool State.isState[ radio_id_t id ](uint8_t myState) { return FALSE; }
  
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command bool Csn.get[ radio_id_t id ](){return FALSE;}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command bool Csn.isInput[ radio_id_t id ](){return FALSE;}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  default async command bool Csn.isOutput[ radio_id_t id ](){return FALSE;}
  
  default command error_t SubControl.start[ radio_id_t id ]() { return FAIL; }
  default command error_t SubControl.stop[ radio_id_t id ]() { return FAIL; } 
  
}
