#include <stdio.h>

generic module SimxSensorP(typedef val_t @integer()) {
  provides interface Read<val_t>[uint16_t chan];
  uses interface Read<uint32_t> as SubRead[uint16_t chan];
  provides interface SensorControl;
}
implementation {

    
  #define DATA_QUEUE_SIZE 40
  enum { 
    TOSH_ADC_PORTMAPSIZE = 12
  };
  norace uint8_t TOSH_adc_portmap[TOSH_ADC_PORTMAPSIZE];


  command error_t Read.read[uint16_t channel]() {
    return call SubRead.read[channel]();
  }

  event void SubRead.readDone[uint16_t channel](error_t result, uint32_t val) {
    val_t con_val = val;
    if (val != con_val) {
      dbg("PS", "Read overflow\n");
    }
    signal Read.readDone[channel](result, con_val);
  }

  // Default provided so a parameterized readDone
  // does not need to be implemented.
 default event void Read.readDone[uint16_t channel](error_t result,
						   val_t val) {}


   
  command error_t SensorControl.bindPort(uint8_t client, uint8_t adcPort) 
  {  
    if (client < TOSH_ADC_PORTMAPSIZE){
      TOSH_adc_portmap[client] = adcPort;
      return SUCCESS;
    } else
      return FAIL;
  }

  command int SensorControl.getInterrupt(uint8_t client){

	return 0;
 }



}
