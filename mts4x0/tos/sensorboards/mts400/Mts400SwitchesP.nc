
/***********************************************************************/
/* This program is free software; you can redistribute it and/or       */
/* modify it under the terms of the GNU General Public License as      */
/* published by the Free Software Foundation; either version 2 of the  */
/* License, or (at your option) any later version.                     */
/*                                                                     */
/* This program is distributed in the hope that it will be useful, but */
/* WITHOUT ANY WARRANTY; without even the implied warranty of          */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU   */
/* General Public License for more details.                            */
/*                                                                     */
/* Written and (c) by INRIA, Christophe Braillon                       */
/*                           Aurelien Francillon                       */
/* Contact <aurelien.francillon@inrialpes.fr> for comment, bug reports */
/* and possible alternative licensing of this program                  */
/***********************************************************************/

#include "mts400.h"

//#define MTS400SWITCHESP_DEBUG

#ifdef MTS400SWITCHESP_DEBUG
#include "printf.h"
#endif

module Mts400SwitchesP
{
  provides
  {
    interface SplitControl as SplitInit;
    interface SplitControl as GPSPower;
    interface SplitControl as AccelPower;
    interface SplitControl as EEPROMPower;
    interface SplitControl as HumidityPower;
    interface SplitControl as PressurePower;
    interface SplitControl as LightPower;

    interface SplitControl as HumidityConnect;
    interface SplitControl as PressureConnect;
    interface SplitControl as GPSConnect;
  }
  uses{
    interface Switch as PowerSwitch;
    interface Switch as DataSwitch;
  }
}

implementation
{

#ifdef MTS400SWITCHESP_DEBUG
#define  DBGPrintf(fmt,...) printf(fmt,__VA_ARGS__)
#else
#define  DBGPrintf(fmt,arg...) do { } while(0);
#endif



  uint8_t tmp_string[100];

  enum {
    IDLE,
    INIT_PENDING,
    STOP_PENDING,
    OFF,
  };
  // main module state
  uint8_t sensorBoardState=OFF;



  enum {
    GPS_CONNECTED,
    GPS_CONNECT,
    GPS_DISCONNECT,
    GPS_DISCONNECTED,
  };
  uint8_t ConnectionSwitchState=GPS_DISCONNECTED;

  enum{
    GPS_POWER_ON,
    GPS_POWER_OFF,
    GPS_TURN_POWER_ON,
    GPS_TURN_POWER_OFF,
    ACCEL_POWER_ON,
    ACCEL_POWER_OFF,    
    ACCEL_TURN_POWER_ON,
    ACCEL_TURN_POWER_OFF,    

  };
  // power/data switches state
  uint8_t PowerSwitchState=GPS_POWER_OFF;


  command error_t SplitInit.start(){
    //  at init we ensure everything is off
    switch(sensorBoardState){

    case OFF:
      sensorBoardState=INIT_PENDING;
      call PowerSwitch.setAll(ALLOFF);

    case INIT_PENDING:
      // calling start when initialisation is ongoing must return
      // success
      return SUCCESS;

    case STOP_PENDING:
      return EBUSY;

    case IDLE:
      return EALREADY;

    default:
      return FAIL;
    }
  }

  command error_t SplitInit.stop(){
    switch(sensorBoardState){

    case OFF:
      return EALREADY;

    case IDLE:
      //  stop all switches  off
      sensorBoardState=STOP_PENDING;
      call PowerSwitch.setAll(ALLOFF);
    case STOP_PENDING:
      return SUCCESS;

    case INIT_PENDING:
      return EBUSY;

    default :
      return FAIL;
    }
  }
	const char* errorString(error_t error){

		switch(error){
		case SUCCESS:
			return "SUCCESS";
		case EALREADY:
			return "EALREADY";
		case EBUSY:
			return "EBUSY";
		case FAIL:
			return "FAIL";
		default :
 			//sprintf(tmp_string, "Unkown error status %d ",error);
			//return tmp_string;// tmp_string;
			return "UNKNOWN";
		}

	}

  event void PowerSwitch.setAllDone(error_t error){

    switch(sensorBoardState){
    case INIT_PENDING:
      if(error==SUCCESS)
        //state=IDLE;
        // now initialize the data switch
        call DataSwitch.setAll(ALLOFF);
      else{
        sensorBoardState=OFF;
        signal SplitInit.startDone(error);
			 DBGPrintf("%s <-() PowerSwitch.setAllDone\n",errorString(error));
      }
      break;

    case STOP_PENDING:
      if(error==SUCCESS)
        //state=OFF;
        call DataSwitch.setAll(ALLOFF);
      else{
        // stopping the device failed
        // return to the idle state
        sensorBoardState=IDLE;
        signal SplitInit.stopDone(error);
      }
      break;
    default:
      // BUGME ?
      signal SplitInit.stopDone(FAIL);

    }
  }


  event void DataSwitch.setAllDone(error_t error){

    switch(sensorBoardState){

    case INIT_PENDING:
      if(error==SUCCESS)
        sensorBoardState=IDLE;
      else
        sensorBoardState=OFF;
      DBGPrintf("%s DataSwitch.setAllDone INIT_PENDING\n",errorString(error));
      signal SplitInit.startDone(error);
      break;

    case STOP_PENDING:
      if(error==SUCCESS)
        sensorBoardState=OFF;
      else
        // stopping the device failed
        // return to the idle state
        sensorBoardState=IDLE;
      DBGPrintf("%s DataSwitch.setAllDone STOP_PENDING\n",errorString(error));
      signal SplitInit.stopDone(error);

      break;
    default:
      // BUGME ?
      signal SplitInit.stopDone(FAIL);
    }
  }

  void printState(){
    switch(sensorBoardState){
    case IDLE:
      DBGPrintf("GPSPower.start sensorBoardState==IDLE   %s\n"," ");
      break;
    case INIT_PENDING:
      DBGPrintf("GPSPower.start sensorBoardState==INIT_PENDING   %s\n"," ");
      break;
    case STOP_PENDING:
      DBGPrintf("GPSPower.start sensorBoardState==STOP_PENDING   %s\n"," ");
      break;
    case OFF:
      DBGPrintf("GPSPower.start sensorBoardState==OFF   %s\n"," ");
      break;
    default :
      DBGPrintf("GPSPower.start sensorBoardState==CORUPTED   %s\n"," ");
      break;
    }
  }

 default event void SplitInit.startDone(error_t error) {};
 default event void SplitInit.stopDone(error_t error) {};

  command error_t GPSPower.start(){

    printState();
		if(sensorBoardState!= IDLE )
      return FAIL;

		// Only possible if no operation is ongoing
		switch (PowerSwitchState){
		case  GPS_POWER_OFF:
      {
        error_t err;
        // PWR_GPS_PWR is active down
        PowerSwitchState=GPS_TURN_POWER_ON;
        err=call PowerSwitch.mask(PWR_GPS_ENA,PWR_GPS_PWR);
        DBGPrintf("%s (GPSPower.start) PowerSwitch.mask \n",errorString(err));
        return err;
      }
		case GPS_TURN_POWER_ON:
			return SUCCESS;
		case GPS_POWER_ON:
			return EALREADY;
		case GPS_TURN_POWER_OFF:
      DBGPrintf("GPSPower.start during GPS_TURN_POWER_OFF %s\n"," ");
      return EBUSY;

			// shouild not happen right?
		default:
			return FAIL;
		}
  }

  command error_t GPSPower.stop() {
    // only possible if gps poser is on and global state is initialized
		if(sensorBoardState!= IDLE ){
			DBGPrintf("Mts400SwitchesP calling GPSPower.stop while sensorBoardState!= IDLE%s\n"," ");
			return FAIL;
		}

		switch(PowerSwitchState){
		case GPS_POWER_ON:
			// PWR_GPS_PWR is active down
			PowerSwitchState=GPS_TURN_POWER_OFF;
			DBGPrintf("Mts400SwitchesP calling GPSPower.stop PowerSwitchState==GPS_POWER_ON now GPS_TURN_POWER_OFF%s\n"," ");

			return call PowerSwitch.mask(PWR_GPS_PWR,PWR_GPS_ENA);
		case GPS_TURN_POWER_OFF:
			DBGPrintf("Mts400SwitchesP GPSPower.stop Already turning off%s\n"," ");
			return SUCCESS;
		case GPS_TURN_POWER_ON:
			DBGPrintf("Mts400SwitchesP GPSPower.stop Fail EBUSY%s\n"," ");
			return EBUSY;
		case GPS_POWER_OFF:
			DBGPrintf("Mts400SwitchesP GPSPower.stop Fail EALREADY %s\n"," ");
			return EALREADY;
		default:
			DBGPrintf("Mts400SwitchesP GPSPower.stop unkonw faliure %s\n"," ");
			return FAIL;
		}

  }

  event void PowerSwitch.maskDone(error_t error ){

    switch(PowerSwitchState){
    case GPS_TURN_POWER_ON:
      DBGPrintf("%s maskdone case GPS_TURN_POWER_ON\n", errorString(error));
      if (error==SUCCESS){
        PowerSwitchState=GPS_POWER_ON;
				DBGPrintf("Mts400SwitchesP GPS_TURN_POWER_ON: PowerSwitchState=GPS_POWER_ON%s\n"," ");
			}else {
				DBGPrintf("Mts400SwitchesP GPS_TURN_POWER_ON: PowerSwitchState=GPS_POWER_OFF%s\n"," ");
				PowerSwitchState=GPS_POWER_OFF;
			}
			DBGPrintf("%s <-(%d) Mts400SwitchesP  PowerSwitch.maskDone GPS_TURN_POWER_ON\n",
						 errorString(error),error);
			signal GPSPower.startDone(error);
      break;

    case GPS_TURN_POWER_OFF:
      DBGPrintf("%s maskdone case GPS_TURN_POWER_OFF\n", errorString(error));
      if (error==SUCCESS)
        PowerSwitchState=GPS_POWER_OFF;
      else
        PowerSwitchState=GPS_POWER_ON;
			DBGPrintf("%s <-(%d) Mts400SwitchesP  PowerSwitch.maskDone GPS_TURN_POWER_OFF\n",
						 errorString(error),error);
			signal GPSPower.stopDone(error);
      break;

    default:
      DBGPrintf("XX FAIL Mts400SwitchesP  PowerSwitchState corrupted %s\n"," ");
      // BUGG?
    }
  }


	// default event void  GPSPower.startDone(error_t error) {};
 default event void  GPSPower.stopDone(error_t error) {};


  command error_t GPSConnect.start(){
		if (sensorBoardState != IDLE )
			return FAIL;

    if(ConnectionSwitchState == GPS_DISCONNECTED){
      ConnectionSwitchState=GPS_CONNECT;
      // ensure that Pressure is disconnected
      // TODO : share a ressource ?
      return call DataSwitch.mask(GPS_RX|GPS_TX, PRESSURE_DOUT|PRESSURE_DIN|PRESSURE_SCLK);
    }
    else
      return FAIL;
  }

  event void DataSwitch.maskDone(error_t error){

    switch(ConnectionSwitchState){
    case GPS_CONNECT :
      if (error==SUCCESS)
        ConnectionSwitchState=GPS_CONNECTED;
      else
        ConnectionSwitchState=GPS_DISCONNECTED;
			DBGPrintf("%s <-(%d) Mts400SwitchesP DataSwitch.maskDone GPS_CONNECT\n",errorString(error),error);

      signal GPSConnect.startDone(error);
      break;

    case GPS_DISCONNECT:
      if (error==SUCCESS)
        ConnectionSwitchState=GPS_DISCONNECTED;
      else
        ConnectionSwitchState=GPS_CONNECTED;
			DBGPrintf("%s <-(%d) Mts400SwitchesP DataSwitch.maskDone GPS_DISCONNECT\n",errorString(error),error);
      signal GPSConnect.stopDone(error);
      break;

    default :
      // BUG?
    }
  }

  command error_t GPSConnect.stop(){

		if (sensorBoardState != IDLE )
			return FAIL;

		if(ConnectionSwitchState == GPS_CONNECTED ){
      ConnectionSwitchState=GPS_DISCONNECT;
      return call DataSwitch.mask(0,GPS_RX|GPS_TX);
    }
    else
      return FAIL;
  }

 default event void GPSConnect.startDone(error_t error){};
 default event void GPSConnect.stopDone(error_t error){};



  // get and set are unused so nothing to do in getDone and SetDone ...
  event void DataSwitch.setDone(error_t error){};
  event void DataSwitch.getDone(error_t error,uint8_t value){};
  event void PowerSwitch.getDone(error_t error,uint8_t value){};


  // TODO : code not tested please report success/failure 

  command error_t AccelPower.start(){
    
    printState();
		if(sensorBoardState!= IDLE )
      return FAIL;
   
 
		// Only possible if no operation is ongoing
		switch (PowerSwitchState){
		case  ACCEL_POWER_OFF:
      {
        error_t err;
        // PWR_GPS_PWR is active down
        PowerSwitchState=ACCEL_TURN_POWER_ON;
        err=call PowerSwitch.set(PWR_ACCEL,1);
        return err;
      }
		case ACCEL_TURN_POWER_ON:
			return SUCCESS;
		case ACCEL_POWER_ON:
			return EALREADY;
		case ACCEL_TURN_POWER_OFF:
      return EBUSY;
		default:
			return FAIL;
		}


  }
  command error_t AccelPower.stop(){

		if(sensorBoardState!= IDLE ){
      return FAIL;
		}
    
		switch(PowerSwitchState){
		case ACCEL_POWER_ON:
			PowerSwitchState=ACCEL_TURN_POWER_OFF;
      return call PowerSwitch.set(PWR_ACCEL,0);
		case ACCEL_TURN_POWER_OFF:
			return SUCCESS;
		case ACCEL_TURN_POWER_ON:
			return EBUSY;
		case ACCEL_POWER_OFF:
			return EALREADY;
		default:
			return FAIL;
		}
    

  }

  event void PowerSwitch.setDone(error_t error){

    switch(PowerSwitchState){
    case ACCEL_TURN_POWER_ON:
      if (error==SUCCESS){
        PowerSwitchState=ACCEL_POWER_ON;
			}else {
        PowerSwitchState=ACCEL_POWER_OFF;
			}
      signal AccelPower.startDone(error);
      break;

    case ACCEL_TURN_POWER_OFF:
      if (error==SUCCESS)
        PowerSwitchState=ACCEL_POWER_OFF;
      else
        PowerSwitchState=ACCEL_POWER_ON;
      signal AccelPower.stopDone(error);
      break;

    default:
      // BUGG?
    }
    
  };

 default event void  AccelPower.startDone(error_t error) {};
 default event void  AccelPower.stopDone(error_t error) {};

  // TODO : 
  command error_t EEPROMPower.start(){
  }
  command error_t EEPROMPower.stop(){
  }
 default event void  EEPROMPower.startDone(error_t error) {};
 default event void  EEPROMPower.stopDone(error_t error) {};


  command error_t HumidityPower.start(){
  }
  command error_t HumidityPower.stop(){
  }
 default event void  HumidityPower.startDone(error_t error) {};
 default event void  HumidityPower.stopDone(error_t error) {};

  command error_t HumidityConnect.start(){};
  command error_t HumidityConnect.stop(){};
 default event  void HumidityConnect.startDone(error_t error){};
 default event  void HumidityConnect.stopDone(error_t error){};


  // when implementing the ressource mind the fact taht it share the
  // serial port with the GPS device
  command error_t  PressurePower.start(){
  }
  command error_t PressurePower.stop(){
  }
 default event void  PressurePower.startDone(error_t error) {};
 default event void  PressurePower.stopDone(error_t error) {};

  command error_t PressureConnect.start() {};
  command error_t PressureConnect.stop() {};
 default event  void PressureConnect.startDone(error_t error) {};
 default event  void PressureConnect.stopDone(error_t error) {};


  command error_t LightPower.start(){
  }
  command error_t LightPower.stop(){
  }
 default event void LightPower.startDone(error_t error){};
 default event void LightPower.stopDone(error_t error){};


}
