
/**
 * @author David Moss
 */
 
module BlazeCentralWiringP {
  provides {
    interface CentralWiring;
    interface GeneralIO as Csn;
    interface GeneralIO as Gdo0_io;
    interface GeneralIO as Gdo2_io;
    interface GpioInterrupt as Gdo0_int;
    interface GpioInterrupt as Gdo2_int;
    interface BlazeConfig;
    interface BlazeRegSettings;
  }
  
  uses {
    interface GeneralIO as ChipCsn[ radio_id_t id ];
    interface GeneralIO as ChipGdo0_io[ radio_id_t id ];
    interface GeneralIO as ChipGdo2_io[ radio_id_t id ];
    interface GpioInterrupt as ChipGdo0_int[ radio_id_t id ];
    interface GpioInterrupt as ChipGdo2_int[ radio_id_t id ];
    interface BlazeConfig as ChipConfig[ radio_id_t id ];
    interface BlazeRegSettings as ChipRegSettings[ radio_id_t id ];
  }
}

implementation {

  uint8_t id;
  
  /***************** CentralWiring Commands ****************/
  command void CentralWiring.switchTo(radio_id_t radioId) {
    id = radioId;
  }
  
  /***************** Csn ****************/
  async command void Csn.set() {
    call ChipCsn.set[id]();
  }
  
  async command void Csn.clr() {
    call ChipCsn.clr[id]();
  }
  
  async command void Csn.toggle() {
    call ChipCsn.toggle[id]();
  }
  
  async command bool Csn.get() {
    return call ChipCsn.get[id]();
  }
  
  async command void Csn.makeInput() {
    call ChipCsn.makeInput[id]();
  }
  
  async command bool Csn.isInput() {
    return call ChipCsn.isInput[id]();
  }
  
  async command void Csn.makeOutput() {
    call ChipCsn.makeOutput[id]();
  }
  
  async command bool Csn.isOutput() {
    return call ChipCsn.isOutput[id]();
  }
  
  
  /***************** Gdo0_io ****************/
  async command void Gdo0_io.set() {
    call ChipGdo0_io.set[id]();
  }
  
  async command void Gdo0_io.clr() {
    call ChipGdo0_io.clr[id]();
  }
  
  async command void Gdo0_io.toggle() {
    call ChipGdo0_io.toggle[id]();
  }
  
  async command bool Gdo0_io.get() {
    return call ChipGdo0_io.get[id]();
  }
  
  async command void Gdo0_io.makeInput() {
    call ChipGdo0_io.makeInput[id]();
  }
  
  async command bool Gdo0_io.isInput() {
    return call ChipGdo0_io.isInput[id]();
  }
  
  async command void Gdo0_io.makeOutput() {
    call ChipGdo0_io.makeOutput[id]();
  }
  
  async command bool Gdo0_io.isOutput() {
    return call ChipGdo0_io.isOutput[id]();
  }
  
  
  /***************** Gdo2_io ****************/
  async command void Gdo2_io.set() {
    call ChipGdo2_io.set[id]();
  }
  
  async command void Gdo2_io.clr() {
    call ChipGdo2_io.clr[id]();
  }
  
  async command void Gdo2_io.toggle() {
    call ChipGdo2_io.toggle[id]();
  }
  
  async command bool Gdo2_io.get() {
    return call ChipGdo2_io.get[id]();
  }
  
  async command void Gdo2_io.makeInput() {
    call ChipGdo2_io.makeInput[id]();
  }
  
  async command bool Gdo2_io.isInput() {
    return call ChipGdo2_io.isInput[id]();
  }
  
  async command void Gdo2_io.makeOutput() {
    call ChipGdo2_io.makeOutput[id]();
  }
  
  async command bool Gdo2_io.isOutput() {
    return call ChipGdo2_io.isOutput[id]();
  }
  
  /***************** Gdo0_int ****************/
  async command error_t Gdo0_int.enableRisingEdge() {
    return call ChipGdo0_int.enableRisingEdge[id]();
  }
  
  async command error_t Gdo0_int.enableFallingEdge() {
    return call ChipGdo0_int.enableFallingEdge[id]();
  }
  
  async command error_t Gdo0_int.disable() {
    return call ChipGdo0_int.disable[id]();
  }
  
  async event void ChipGdo0_int.fired[radio_id_t radioId]() {
    signal Gdo0_int.fired();
  }
  
  /***************** Gdo2_int ****************/
  async command error_t Gdo2_int.enableRisingEdge() {
    return call ChipGdo2_int.enableRisingEdge[id]();
  }
  
  async command error_t Gdo2_int.enableFallingEdge() {
    return call ChipGdo2_int.enableFallingEdge[id]();
  }
  
  async command error_t Gdo2_int.disable() {
    return call ChipGdo2_int.disable[id]();
  }
  
  async event void ChipGdo2_int.fired[radio_id_t radioId]() {
    signal Gdo2_int.fired();
  }
  
  /***************** BlazeConfig ****************/
  command error_t BlazeConfig.commit() { 
    return call ChipConfig.commit[id]();
  }
  
  event void ChipConfig.commitDone[radio_id_t radioId]() { 
    signal BlazeConfig.commitDone();
  }
  
  command void BlazeConfig.setAddressRecognition(bool on) { 
    call ChipConfig.setAddressRecognition[id](on);
  }
  
  async command bool BlazeConfig.isAddressRecognitionEnabled() { 
    return call ChipConfig.isAddressRecognitionEnabled[id]();
  }

  command void BlazeConfig.setPanRecognition(bool on) { 
    call ChipConfig.setPanRecognition[id](on);
  }

  async command bool BlazeConfig.isPanRecognitionEnabled() { 
    return call ChipConfig.isPanRecognitionEnabled[id]();
  }

  command void BlazeConfig.setAutoAck(bool enableAutoAck) { 
    call ChipConfig.setAutoAck[id](enableAutoAck);
  }
  
  async command bool BlazeConfig.isAutoAckEnabled() { 
    return call ChipConfig.isAutoAckEnabled[id]();
  }
   
  command error_t BlazeConfig.setBaseFrequency(uint32_t freq) { 
    return call ChipConfig.setBaseFrequency[id](freq);
  }
  
  command uint32_t BlazeConfig.getBaseFrequency() { 
    return call ChipConfig.getBaseFrequency[id]();
  }
  
  command error_t BlazeConfig.setChannelFrequencyKhz( uint32_t freqKhz ) { 
    return call ChipConfig.setChannelFrequencyKhz[id](freqKhz);
  }
  
  command uint32_t BlazeConfig.getChannelFrequencyKhz() { 
    return call ChipConfig.getChannelFrequencyKhz[id]();
  }
  
  command error_t BlazeConfig.setChannel( uint8_t chan ) {
    return call ChipConfig.setChannel[id](chan);
  }
  
  command uint8_t BlazeConfig.getChannel() { 
    return call ChipConfig.getChannel[id]();
  }
  
  /***************** BlazeRegSettings ****************/
  command uint8_t *BlazeRegSettings.getDefaultRegisters() {
    return call ChipRegSettings.getDefaultRegisters[id]();
  }
  
  command uint8_t BlazeRegSettings.getPa() {
    return call ChipRegSettings.getPa[id]();
  }
  
  /***************** Defaults ****************/
  default async command void ChipCsn.set[ radio_id_t radioId ](){}
  default async command void ChipCsn.clr[ radio_id_t radioId ](){}
  default async command void ChipCsn.toggle[ radio_id_t radioId ](){}
  default async command bool ChipCsn.get[ radio_id_t radioId ](){return FALSE;}
  default async command void ChipCsn.makeInput[ radio_id_t radioId ](){}
  default async command bool ChipCsn.isInput[ radio_id_t radioId ](){return FALSE;}
  default async command void ChipCsn.makeOutput[ radio_id_t radioId ](){}
  default async command bool ChipCsn.isOutput[ radio_id_t radioId ](){return FALSE;}
  
  default async command void ChipGdo0_io.set[ radio_id_t radioId ](){}
  default async command void ChipGdo0_io.clr[ radio_id_t radioId ](){}
  default async command void ChipGdo0_io.toggle[ radio_id_t radioId ](){}
  default async command bool ChipGdo0_io.get[ radio_id_t radioId ](){return FALSE;}
  default async command void ChipGdo0_io.makeInput[ radio_id_t radioId ](){}
  default async command bool ChipGdo0_io.isInput[ radio_id_t radioId ](){return FALSE;}
  default async command void ChipGdo0_io.makeOutput[ radio_id_t radioId ](){}
  default async command bool ChipGdo0_io.isOutput[ radio_id_t radioId ](){return FALSE;}
  
  default async command void ChipGdo2_io.set[ radio_id_t radioId ](){}
  default async command void ChipGdo2_io.clr[ radio_id_t radioId ](){}
  default async command void ChipGdo2_io.toggle[ radio_id_t radioId ](){}
  default async command bool ChipGdo2_io.get[ radio_id_t radioId ](){return FALSE;}
  default async command void ChipGdo2_io.makeInput[ radio_id_t radioId ](){}
  default async command bool ChipGdo2_io.isInput[ radio_id_t radioId ](){return FALSE;}
  default async command void ChipGdo2_io.makeOutput[ radio_id_t radioId ](){}
  default async command bool ChipGdo2_io.isOutput[ radio_id_t radioId ](){return FALSE;}
  
  default async command error_t ChipGdo0_int.enableRisingEdge[ radio_id_t radioId ]() {return FAIL;}
  default async command error_t ChipGdo0_int.enableFallingEdge[ radio_id_t radioId ]() {return FAIL;}
  default async command error_t ChipGdo0_int.disable[ radio_id_t radioId ]() {return FAIL;}
  
  default async command error_t ChipGdo2_int.enableRisingEdge[ radio_id_t radioId ]() {return FAIL;}
  default async command error_t ChipGdo2_int.enableFallingEdge[ radio_id_t radioId ]() {return FAIL;}
  default async command error_t ChipGdo2_int.disable[ radio_id_t radioId ]() {return FAIL;}
  
  default command uint8_t *ChipRegSettings.getDefaultRegisters[radio_id_t radioId]() {return NULL;}  
  default command uint8_t ChipRegSettings.getPa[radio_id_t radioId]() {return 0;}
  
  default command error_t ChipConfig.commit[radio_id_t radioId]() { return FAIL; }
  default command void ChipConfig.setAddressRecognition[radio_id_t radioId](bool on) { }
  default async command bool ChipConfig.isAddressRecognitionEnabled[radio_id_t radioId]() { return FALSE; }
  default command void ChipConfig.setPanRecognition[radio_id_t radioId](bool on) { }
  default async command bool ChipConfig.isPanRecognitionEnabled[radio_id_t radioId]() { return FALSE; }
  default command void ChipConfig.setAutoAck[radio_id_t radioId](bool enableAutoAck) { }
  default async command bool ChipConfig.isAutoAckEnabled[radio_id_t radioId]() { return FALSE; }
  default command error_t ChipConfig.setBaseFrequency[radio_id_t radioId](uint32_t freq) { return FAIL; }
  default command uint32_t ChipConfig.getBaseFrequency[radio_id_t radioId]() { return 0; }
  default command error_t ChipConfig.setChannelFrequencyKhz[radio_id_t radioId]( uint32_t freqKhz ) { return FAIL; }
  default command uint32_t ChipConfig.getChannelFrequencyKhz[radio_id_t radioId]() { return FAIL; }
  default command error_t ChipConfig.setChannel[radio_id_t radioId]( uint8_t chan ) { return FAIL; }
  default command uint8_t ChipConfig.getChannel[radio_id_t radioId]() { return 0; }
  
  default event void BlazeConfig.commitDone() {}


}

