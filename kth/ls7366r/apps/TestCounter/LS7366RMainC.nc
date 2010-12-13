/**
 * LS7366RMainC.nc
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

configuration LS7366RMainC {
}
implementation {

	components MainC;

	components new TimerMilliC() as Timer;
	components LS7366RMainP as Enc;
	Enc.TimerSamples -> Timer;
	Enc.Boot -> MainC.Boot;
	
	components LS7366RControlC;

	Enc.EncConfig -> LS7366RControlC;
	Enc.EncReceive -> LS7366RControlC;
	Enc.EncResource -> LS7366RControlC.Resource;

	components LedsC;
	Enc.Leds -> LedsC;
}
