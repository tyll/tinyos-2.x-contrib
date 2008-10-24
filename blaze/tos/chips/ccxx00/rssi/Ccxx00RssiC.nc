
#include "Blaze.h"

/**
 * This is not pulled into the radio stack by default because it is no part
 * of the radio stack is dependent upon this functionality. Therefore,
 * in order to use it, you have to tap directly into this configuration
 * from your application layer.
 * 
 * @author David Moss
 */
 
configuration Ccxx00RssiC {
  provides {
    interface Read<int8_t>[radio_id_t radioId];
  }
}

implementation {

  components Ccxx00RssiP;
  Read = Ccxx00RssiP;
  
  components SplitControlManagerC;
  Ccxx00RssiP.SplitControlManager -> SplitControlManagerC;
  
  components new BlazeSpiResourceC(),
      BlazeCentralWiringC,
      BlazeSpiC;
  Ccxx00RssiP.Resource -> BlazeSpiResourceC;
  Ccxx00RssiP.Csn -> BlazeCentralWiringC.Csn;
  Ccxx00RssiP.RSSI -> BlazeSpiC.RSSI;
  
}
