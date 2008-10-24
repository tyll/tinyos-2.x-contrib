
#include "Blaze.h"

/**
 * @author David Moss
 */
 
module Ccxx00RssiP {
  provides {
    interface Read<int8_t>[radio_id_t radioId];
  }
  
  uses {
    interface BlazeRegister as RSSI;
    interface GeneralIO as Csn[radio_id_t radioId];
    interface Resource;
    interface SplitControlManager[radio_id_t radioId];
  }
}

implementation {

  uint8_t currentClient;
  
  /***************** Prototypes ****************/
  void readRssi();
  
  /***************** Read Commands ****************/
  command error_t Read.read[radio_id_t radioId]() {
    if(!call SplitControlManager.isOn[radioId]()) {
      return EOFF;
    }
    
    currentClient = radioId;
    
    if(call Resource.immediateRequest() == SUCCESS) {
      readRssi();
      return SUCCESS;
    }
  
    return call Resource.request();
  }
  
  /****************** Resource events ****************/
  event void Resource.granted() {
    readRssi();
  }

  /****************** SplitControlManager Events ****************/
  event void SplitControlManager.stateChange[radio_id_t radioId]() {
  }
  
  /****************** Functions ****************/
  void readRssi() {
    int8_t rssi;
    
    call Csn.clr[currentClient]();
    call RSSI.read(&rssi);
    call Csn.set[currentClient]();
    call Resource.release();
    
    signal Read.readDone[currentClient](SUCCESS, rssi);
  }
  
  
  /****************** Defaults ****************/
  default event void Read.readDone[radio_id_t radioId]( error_t result, int8_t val ) {}
  
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  
}
