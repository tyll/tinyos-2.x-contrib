
#include "tinynodeSEB.h"

generic module ExTempAdcP() {
    provides {
 	interface AdcConfigure<const msp430adc12_channel_config_t*> as AdcConfigure;
    }
}

implementation {
    
    async command const msp430adc12_channel_config_t* AdcConfigure.getConfiguration() {
	return &exTempAdc; 
    }
}
