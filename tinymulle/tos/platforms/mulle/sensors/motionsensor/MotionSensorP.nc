/**
* File: MotionSensorP.nc
* Version: 1.0
* Description:  Interface for motion sensor
* 
* Author: Laurynas Riliskis
* E-mail: Laurynas.Riliskis@ltu.se
* Date:   March 12, 2009
*
* Copyright notice
*
* Copyright (c) Communication Networks, Lulea University of Technology.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* 1. Redistributions of source code must retain the above copyright
*    notice, this list of conditions and the following disclaimer.
* 2. Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the
*    documentation and/or other materials provided with the distribution.
* 3. All advertising materials mentioning features or use of this software
*    must display the following acknowledgement:
*	This product includes software developed by the Communication Networks
*   Group at Lulea University of Technology.
* 4. Neither the name of the University nor of the group may be used
*    to endorse or promote products derived from this software without
*    specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
* OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
*/

/**
 * Potentiometer Voltage. The returned value represents the potentiometer voltage 
 * on the expansion board. The Vref is 1.3V and AVcc is 3.3V. The formula to convert
 * it to mV is: Vout=value * 1309 / 1023. the temperature is: (Vout-509)/6.45
 *
 * @author Fan Zhang <fanzha@ltu.se>
 */

#include "hardware.h"

module MotionSensorP {

    provides {
    	interface MotionSensor;
    	interface ReadNow<uint16_t> as ReadNow;
    	interface SplitControl as ReadControl;
    }
    uses {
    	interface Alarm<TMicro, uint32_t>;
    	interface ReadNow<uint16_t> as MotionReadNow;
    	interface Resource as ReadNowResource;
    }
}
implementation {
	#define BUF_SIZE 1
	uint16_t buf[BUF_SIZE];
	uint32_t usFr;
	uint16_t threshold;
	bool swAlarm;
	
    
    async command error_t ReadNow.read() {
    	atomic{
	    	if(buf[0] > threshold){
	    		signal ReadNow.readDone(SUCCESS, buf[0]);
	    	}
	    	else{
	    		signal ReadNow.readDone(FAIL, 0);
	    	}	
    	}
    	return SUCCESS;
    }
    //default async event void ReadNow.readDone(error_t e, uint16_t d) { }
    
    command error_t ReadControl.start(){
    	atomic call Alarm.start(usFr);
    	atomic swAlarm = TRUE;
    	signal ReadControl.startDone(SUCCESS);
    	return SUCCESS;
    }
    command error_t ReadControl.stop(){
    	atomic swAlarm = FALSE;
    	signal ReadControl.stopDone(SUCCESS);
    	return SUCCESS;
    }
    
/*------------------ Alarm timer interrupt -------------------*/	
	async event void Alarm.fired() {
    	call ReadNowResource.request();
    	if(swAlarm == TRUE)
    		call Alarm.startAt(call Alarm.getNow(), usFr);
    }
	
/*----------------- interface MotionReadNow -----------------*/	
	
	
	event void ReadNowResource.granted()
    {
    	call MotionReadNow.read();
    }
  
    async event void MotionReadNow.readDone(error_t result, uint16_t data)
    {
	    if (result == SUCCESS)
	      atomic buf[0] = data; 
	    
	    call ReadNowResource.release();
    }
/*----------------- interface MotionSensor -----------------*/
      
      async command error_t MotionSensor.setSampleFrequency(uint32_t fr)
	  {
	    atomic usFr = fr;
	    return SUCCESS;
	  }
	
	  async command error_t MotionSensor.setThreshold(uint16_t thr)
	  {
	    atomic threshold = thr;
	    return SUCCESS;
	  }

}
