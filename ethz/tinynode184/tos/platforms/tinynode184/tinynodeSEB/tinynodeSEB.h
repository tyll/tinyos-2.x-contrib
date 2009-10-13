#ifndef TINYNODESEB_H
#define TINYNODESEB_H

#define UQ_TEMPDEVICE "TempDeviceP.Resource"
#define UQ_TEMPDEVICE_STREAM "TempDeviceStreamP.Resource"

#define UQ_PHOTODEVICE "PhotoDeviceP.Resource"
#define UQ_PHOTODEVICE_STREAM "PhotoDeviceStreamP.Resource"


#define UQ_BATTDEVICE "ExBattDeviceP.Resource"
#define UQ_BATTDEVICE_STREAM "ExBattDeviceStreamP.Resource"

#include <Msp430Adc12.h>


const msp430adc12_channel_config_t photoAdc = {
      INPUT_CHANNEL_A4,
      REFERENCE_VREFplus_AVss,
      REFVOLT_LEVEL_1_5,
      SHT_SOURCE_ACLK,
      SHT_CLOCK_DIV_1,
      SAMPLE_HOLD_4_CYCLES,
      SAMPCON_SOURCE_SMCLK,
      SAMPCON_CLOCK_DIV_1
    };

const msp430adc12_channel_config_t exBattAdc = {
    
    EXTERNAL_REF_VOLTAGE_CHANNEL,
    REFERENCE_AVcc_AVss,
    REFVOLT_LEVEL_NONE,
    SHT_SOURCE_ACLK,
    SHT_CLOCK_DIV_1,
    SAMPLE_HOLD_4_CYCLES,
    SAMPCON_SOURCE_SMCLK,
    SAMPCON_CLOCK_DIV_1
};

const msp430adc12_channel_config_t exTempAdc = {
    INPUT_CHANNEL_A5,
    REFERENCE_VREFplus_AVss,
    REFVOLT_LEVEL_1_5,
    SHT_SOURCE_ACLK,
    SHT_CLOCK_DIV_1,
    SAMPLE_HOLD_4_CYCLES,
    SAMPCON_SOURCE_SMCLK,
    SAMPCON_CLOCK_DIV_1
};





#endif
