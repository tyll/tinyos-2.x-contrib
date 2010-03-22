#include "PrintfUART.h"
#include "Msp430Adc12.h"
#include "Accelerometer.h"
#include "Sensor.h"


#undef PXDBG
#ifdef PXDBG_TESTP
#define PXDBG(_x) _x
#else
#define PXDBG(_x)
#endif

module SensorP
{
  provides {
    interface Read<uint16_t> as AdcRead[uint16_t id];
    interface Init;
    interface SensorControl;
  }
  uses {
    interface Boot;
    interface Leds;
    interface Accelerometer;
    interface Read<acc_t> as AccelerometerRead;
    interface Read<uint16_t> as LightRead;
    interface Read<uint16_t> as BatteryRead;
    interface EnergyMeter;
    interface WakeupADC as WakeupLight;
  }
}

implementation
{  
  #define DATA_QUEUE_SIZE 40
  enum { 
    TOSH_ADC_PORTMAPSIZE = 12
  };
  norace uint8_t TOSH_adc_portmap[TOSH_ADC_PORTMAPSIZE];
  int accIsOn = FALSE;
  int lightInt = FALSE;

  uint32_t irregular_triangle();

 event void Boot.booted()
  {
    call Accelerometer.init();
    call EnergyMeter.init(); /** configure*/
    call EnergyMeter.reset();
    call EnergyMeter.start();
    call WakeupLight.init();
    call WakeupLight.setThreshold(LIGHT_WAKEUP_THRESHOLD, INST_BYTE_ADC1);
    return;
  }
  
  command error_t Init.init() { 
    printfUART_init();
    return SUCCESS;
   }

  command error_t SensorControl.bindPort(uint8_t client, uint8_t adcPort) 
  {  
    if (client < TOSH_ADC_PORTMAPSIZE){
      TOSH_adc_portmap[client] = adcPort;
      return SUCCESS;
    } else
      return FAIL;
  }

  command int SensorControl.getInterrupt(uint8_t client){

	if (client<3){return accIsOn;}
	else {return lightInt;}
	//if(accIsOn == TRUE || lightInt == TRUE){call Leds.led1Toggle();}
	//else{call Leds.led2Toggle();}
	//return (accIsOn||lightInt);
 }

 async event void Accelerometer.int1(){/*ACC stablize*/
	if(accIsOn == TRUE){
		accIsOn = FALSE;
		call Accelerometer.clearInt();
	}
 }

  async event void Accelerometer.int2(){/*ACC activate*/
	if(accIsOn == FALSE){
		accIsOn = TRUE;
		call Accelerometer.clearInt();
	}
  }

  async event void WakeupLight.adc_int(){
	if(lightInt == FALSE){
		lightInt = TRUE;
		//post energyMeterReadDone();
		//wakeupByLight();
		//call LightTimer.startPeriodic(DEFAULT_SAMPLING_PERIOD);
	}
   }


  command error_t AdcRead.read[uint16_t client](){
	uint32_t energy;
	static uint32_t energy_hist;
	uint16_t energy_temp;
	switch(TOSH_adc_portmap[client]) {
		case ACC_REQUEST1:
			call AccelerometerRead.read();
			break;
		case ACC_REQUEST2:
			call AccelerometerRead.read();
			break;	
		case ACC_REQUEST3:
			call AccelerometerRead.read();
			break;
		case LIGHT_REQUEST:
			call LightRead.read();
			break;
		case BATTERY_REQUEST:			
			call BatteryRead.read();
			break;
		case ENERGY_REQUEST:
			//irregular_triangle();
			energy = call EnergyMeter.read();
			energy_temp = (uint16_t)(energy - energy_hist);
			energy_hist = energy;

			/*energy_temp = energy;
			signal AdcRead.readDone[ENERGY_REQUEST](SUCCESS,(uint16_t)((energy_temp>>16)&0xffff));
			signal AdcRead.readDone[ENERGY_REQUEST](SUCCESS,(uint16_t)(energy&0xffff));
			energy_temp = (uint16_t)((energy >> 16)&&0xffff); /*Mingsen xu: scale the 32 bit reading to 16 bit for demo*/

			signal AdcRead.readDone[ENERGY_REQUEST](SUCCESS,energy_temp);
			break;
	}
	return SUCCESS;
  }



  event void AccelerometerRead.readDone(error_t err, acc_t val){
	uint16_t accx,accy,accz;

	if (err == SUCCESS ) {
		accx = val.x & 0x3FF;
		accy = val.y & 0x3FF;
		accz = val.z & 0x3FF;
		//PXDBG(printfUART("In AccelerometerRead.readDone with data %u %u %u \n",accx,accy,accz));
		//if(accIsOn == TRUE){
			signal AdcRead.readDone[ACC_REQUEST1](err,accx);
			signal AdcRead.readDone[ACC_REQUEST2](err,accy);
			signal AdcRead.readDone[ACC_REQUEST3](err,accz);
		//}
	}


  }

  event void LightRead.readDone(error_t err, uint16_t val){ 

	if (err == SUCCESS ) {
		//if(lightInt == TRUE){
			signal AdcRead.readDone[LIGHT_REQUEST](err,val);
		//}
		if(val > LIGHT_SLEEP_THRESHOLD ){ lightInt = FALSE;}
	}

  }

  event void BatteryRead.readDone(error_t err, uint16_t val) {
	if (err == SUCCESS ) 
		signal AdcRead.readDone[BATTERY_REQUEST](err,val);
  }



	uint32_t irregular_triangle(){
		static int amplify = 0x1;
		static int interval = 1;
		static uint16_t delta = 0;
		static int magnitude = 0x1ff;
		static int count = 0;
	
		count += interval;
		delta += amplify;

		if (delta > magnitude) {
			delta = 0;
			if (count >= 360*4) {
				magnitude += 0xff;
				count = 0;
				amplify += 5;
				if (magnitude > 0xfff) {
					magnitude = 0x1ff;
				}

				if (amplify > 0x20) {
					amplify = 0x1;
				}
			}
		}



		signal AdcRead.readDone[ENERGY_REQUEST](SUCCESS,delta);
	}
}

