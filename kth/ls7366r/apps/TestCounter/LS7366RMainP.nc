/**
 * LS7366RMainP.nc
 * 
 * KTH | Royal Institute of Technology
 * Automatic Control
 *
 * 		  	 Project: se.kth.tinyos2x.mac.tkn154
 *  	  Created on: 2010/06/09  
 * Last modification:  
 \*     		  Author: Aitor Hernandez <aitorhh@kth.se>
 *     
 */

#include "LS7366R.h"
#include "printf.h"

module LS7366RMainP @ safe() {

	uses {
	    interface Boot;

		interface LS7366RConfig as EncConfig;
		interface LS7366RReceive as EncReceive;
		interface Resource as EncResource;
		interface Leds;
		
		interface Timer<TMilli> as TimerSamples;
	}
}
implementation {
	
	uint8_t count[4];
	
	event void Boot.booted() {
		  call TimerSamples.startPeriodic(50);
	  }
	  
	/****************** EncReceive Events ****************/
	event void TimerSamples.fired(){
		  call EncResource.request();
	  }

	/****************** EncReceive Events ****************/
	event void EncReceive.receiveDone( uint8_t* data ) {
		printf("Received data %u \n", data[0]);
		printfflush();
	}
	
	/***************** Resource event  ****************/
	event void EncResource.granted() {
		call EncReceive.receive(count);
	}

	/****************** EncConfig Events ****************/
	event void EncConfig.syncDone( error_t error ) {}
		

}
