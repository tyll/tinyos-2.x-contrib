/**
  * 
  * Configuration file for Sensor
  *
  * @author Mingsen Xu		
  *
  */

#include "Msp430Adc12.h"
#include "PrintfUART.h"
#include "Accelerometer.h"

configuration SensorC {
  provides {
      interface Init;
      interface Read<uint16_t> as AdcRead[uint16_t id];
      interface SensorControl;
    }
  uses{
      interface Boot;

    }

  }
implementation {
  components SensorP;
  components LedsC;
  

  SensorControl=SensorP;
  AdcRead = SensorP;
  Init = SensorP;
  Boot = SensorP;
  SensorP.Leds -> LedsC;


  components AccelerometerC;
  SensorP.Accelerometer -> AccelerometerC;
  SensorP.AccelerometerRead -> AccelerometerC;

  components WakeupADCC;
  SensorP.LightRead -> WakeupADCC.ADC1Read;
  SensorP.WakeupLight -> WakeupADCC.ADC1;

  components EnergyMeterC;
  SensorP.EnergyMeter -> EnergyMeterC.EnergyMeter;

  components BatteryVoltageC;
  SensorP.BatteryRead -> BatteryVoltageC.BatteryRead;


}

