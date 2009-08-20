
module AvailableRadiosP {
  provides {
    interface AvailableRadios;
    interface Init as RadioPlatformInit;
  }
  
  uses {
    interface BlazeRegister as PARTNUM;
    interface BlazeRegister as VERSION;
  }
}

implementation {

  
  enum {
    CC1100_PARTNUM = 0x0,
    CC1100_VERSION = 0x3,
    
    CC1101_PARTNUM = 0x0,
    CC1101_VERSION = 0x4,
    
    CC2500_PARTNUM = 0x80,
    CC2500_VERSION = 0x3,
  };
  
  uint8_t radioPartnums[uniqueCount(UQ_BLAZE_RADIO)];
  
  uint8_t radioVersions[uniqueCount(UQ_BLAZE_RADIO)];
  
  /***************** RadioPlatformInit Commands ****************/
  command error_t RadioPlatformInit.init() {
    int id;
    for(id = 0; id < uniqueCount(UQ_BLAZE_RADIO); id++) {
      if(radioVersions[id] == 0) {
        break;
      }
    }
    
    // id contains the radio id that we are now filling in details for.
    call PARTNUM.read(&radioPartnums[id]);
    call VERSION.read(&radioVersions[id]);
    return SUCCESS;
  }
  
  /***************** AvailableRadios Commands ****************/
  command bool AvailableRadios.isCc1100(uint8_t radioId) {
    return (radioPartnums[radioId] == CC1100_PARTNUM 
        && radioVersions[radioId] == CC1100_VERSION); 
  }
  
  command bool AvailableRadios.isCc1101(uint8_t radioId) {
    return (radioPartnums[radioId] == CC1101_PARTNUM 
        && radioVersions[radioId] == CC1101_VERSION); 
  }
  
  command bool AvailableRadios.isCc2500(uint8_t radioId) {
    return (radioPartnums[radioId] == CC2500_PARTNUM 
        && radioVersions[radioId] == CC2500_VERSION); 
  }
  
  
}
