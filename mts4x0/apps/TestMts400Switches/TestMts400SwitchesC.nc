
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
#include "printf.h"

/**
 * This module tests the power Switch on mda4X0 board
 * On success red led is blinking and green and yellow leds are constantly on
 */


module TestMts400SwitchesC
{
	uses
	{
		interface Leds;

		interface Timer<TMilli> as Timer0;
		interface Timer<TMilli> as TimerStop;
		interface SplitControl as SplitInit;
		interface SplitControl as GPSPower;
		interface SplitControl as GPSConnect;

		interface Timer<TMilli> as FlushTimer;
		interface SplitControl as PrintfControl;
    interface PrintfFlush;

		interface Boot;
	}
}

implementation
{

	enum{
		INITSTART_FAILED=1,
		INITSTARTDONE_FAILED=4,    // Led 2 blinks
 		GPSPowerstopDoneFAILED=1,  //Led 0 blinkls
		GPSPowerstartDoneFAILED=2, // Led 1 blinks
		GPSPowerstartFAILED=5,     // led 0 and 2 blinks
		GPSPowerstopFAILED=6,      // led 1 and 2 blinks
		XXDONEALERT=7,
	};

	uint8_t cpt;
	bool waitImBUSY=FALSE;
	char tmp_string[100];
  error_t postedError;
  bool Flushing=FALSE;

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
      sprintf(tmp_string, "Unkown error status %d ",error);
      return tmp_string;// tmp_string;
      //return "UNKNOWN";

		}

	}

	void alert(error_t error, uint8_t okLed, uint8_t failLed ){
		switch(error){
		case SUCCESS:
			//call Leds.set(okLed);
			// expect a startDone event
			break;
		case EALREADY:
			//call Leds.set(okLed);
			// expect a startDone event
			break;
		case EBUSY:
			//call Leds.set(0);

		case FAIL:
			{
				uint8_t i=0;
				while(TRUE) {
					// delay
					volatile uint16_t j=0;
					for(j=0;j<10000; j++){};
					call Leds.set(i++&failLed);
				}
			}
			break;
		}
	}
	task void startTimer() {
		call Timer0.startOneShot(10000);
	}



  event void PrintfControl.startDone(error_t error) {
		error_t err;

    printf("%s <-PrintfControl.startDone() \n",errorString(error));
		call FlushTimer.startPeriodic(500);

    atomic printf("SplitInit.start() ->\n");
		err=call SplitInit.start();
		atomic printf("%s <-SplitInit.start() \n",errorString(err));
  }

	event void SplitInit.startDone(error_t error ) {
    printf("%s <-SplitInit.startDone() \n",errorString(error));
    if(error==SUCCESS){
			post startTimer();
    }
	}


	event void Boot.booted()
	{
		cpt = 0;
		call PrintfControl.start();
	}

	event void FlushTimer.fired(){
    call PrintfFlush.flush();
	}

	event void Timer0.fired()
	{
		error_t err;

    printf("GPSPower.start -> \n");
		err=call GPSPower.start();
    printf("%s <-()GPSPower.start \n",errorString(err));
	}


	event void GPSPower.startDone(error_t error)
	{
		error_t err;

    printf("%s (%d) <- GPSPower.startDone \n",errorString(error),error);
		if(error == SUCCESS) {
			err=call GPSConnect.start();
      printf("%s <- GPSConnect.start  \n",errorString(err));

		}

	}

	event void GPSConnect.startDone(error_t error) {
    printf("%s <-GPSConnect.startDone() \n",errorString(error));
    if(error==SUCCESS){
      printf("GPS Properly sarted, will stop it in 5seconds \n");
      call TimerStop.startOneShot(5000);
    }
  }


  // starting stop
  event void TimerStop.fired(){
      error_t err;
      printf("GPSConnect.stop -> \n");
      err=call GPSConnect.stop();
      printf("%s <-GPSConnect.stop() \n",errorString(err));
  }

  event void GPSConnect.stopDone(error_t error){

    printf("%s <-GPSConnect.stopDone() \n",errorString(error));
    if (error==SUCCESS) {
      error_t err;
      printf("GPSPower.stop ->  \n");
			err=call GPSPower.stop();
      printf("%s <- GPSPower.stop  \n",errorString(err));
    }
  }


	event void GPSPower.stopDone(error_t error) {

    printf("%s GPSPower.stopDone  \n",errorString(error));
    //    post startTimer();
    if(error==SUCCESS){
      error_t err;
      printf("SplitInit.stop -> \n");
      err=call SplitInit.stop();
      printf("%s <- SplitInit.stop  \n",errorString(err));
    }
	};

	event void SplitInit.stopDone(error_t error){

    printf("%s <- SplitInit.stopDone  \n",errorString(error));
    //  restart the test cycle
    //    post startTimer();
    if(error==SUCCESS){
      error_t err;
      printf("SplitInit.start->  \n");
      err=call SplitInit.start();
      atomic printf("%s <-SplitInit.start() \n",errorString(err));
    }

	}

	event void PrintfControl.stopDone(error_t error){};

  event void 	PrintfFlush.flushDone(error_t error){};

}
