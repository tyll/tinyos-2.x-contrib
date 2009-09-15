#include "Arbutus.h"



configuration CollectionC {
  provides {
    interface StdControl;
    interface Send[uint8_t client];
    interface Receive[collection_id_t id];
    interface Intercept[collection_id_t id];

    interface Packet;
    interface controlToData;
    interface dataToControl;

    interface RootControl;    
  }

  uses {
    interface CollectionId[uint8_t client];
    
  }
}

implementation {
  components ArbutusP;

  StdControl = ArbutusP;
  Send = ArbutusP;
  Receive = ArbutusP.Receive;
  Intercept = ArbutusP;

  Packet = ArbutusP;
  controlToData = ArbutusP;
  dataToControl = ArbutusP;


  RootControl = ArbutusP;

  CollectionId = ArbutusP;


}

