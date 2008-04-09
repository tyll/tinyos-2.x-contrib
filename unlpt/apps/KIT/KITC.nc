/*
* Copyright (c) 2008 New University of Lisbon - Faculty of Sciences and
* Technology.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of New University of Lisbon - Faculty of Sciences and
*   Technology nor the names of its contributors may be used to endorse or 
*   promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * @author Miguel Silva (migueltsilva@gmail.com)
 * @version $Revision$
 * @date $Date$
 */

module KITC {

	uses interface Boot;
	uses interface Timer<TMilli> as Timer;
	uses interface Leds;
	uses interface Init;
}

implementation {

	bool stateOne;
	bool stateTwo;
	bool stateTree;
	bool direction_right;

	/***************** Prototypes ****************/
	task void processing();
	void  signallights(uint8_t value);
	void glow(uint8_t a, uint8_t b);

	/***************** Boot Events ****************/
	event void Boot.booted() {
		stateOne = TRUE;
		stateTwo = FALSE;
		stateTree = FALSE;
		direction_right = FALSE;
		call Timer.startPeriodic(50);
	}

	/***************** Timer Events ***************/
	event void Timer.fired() {
		post processing();
	}


	/****************** Tasks ****************/

	task void processing(){
		if(direction_right == FALSE){
			if (stateOne == TRUE && stateTwo == FALSE && stateTree == FALSE){	//led0 on
				signallights(1);
				stateTwo = TRUE;
				stateTree = FALSE;
				stateOne = TRUE;
				return;
			}
	
			if (stateOne == TRUE && stateTwo == TRUE && stateTree == FALSE){	//led0 and 1 on
				signallights(3);
				stateOne = FALSE;
				stateTwo = TRUE;
				stateTree = FALSE;
				return;
			}
	
			if (stateOne == FALSE && stateTwo == TRUE && stateTree == FALSE){	//led1 on
				signallights(2);
				stateOne = FALSE;
				stateTwo = TRUE;
				stateTree = TRUE;
				return;
			}
	
			if (stateOne == FALSE && stateTwo == TRUE && stateTree == TRUE){	//led2 and 1 on
				signallights(6);
				stateOne = FALSE;
				stateTwo = FALSE;
				stateTree = TRUE;
				return;
			}
	
			if (stateOne == FALSE && stateTwo == FALSE && stateTree == TRUE){	//led2 on, switch side
				signallights(4);
				stateOne = FALSE;
				stateTwo = TRUE;
				stateTree = TRUE;
				direction_right = TRUE;
				return;
			}
		}
		else{
			if (stateOne == FALSE && stateTwo == TRUE && stateTree == TRUE){	//led2 and 1 on
				signallights(6);
				stateOne = FALSE;
				stateTwo = TRUE;
				stateTree = FALSE;
				return;
			}
			if (stateOne == FALSE && stateTwo == TRUE && stateTree == FALSE){	//led1 on
				signallights(2);
				stateOne = TRUE;
				stateTwo = TRUE;
				stateTree = FALSE;
				return;
			}
			if (stateOne == TRUE && stateTwo == TRUE && stateTree == FALSE){	//led0 and 1 on
				signallights(3);
				stateOne = TRUE;
				stateTwo = FALSE;
				stateTree = FALSE;
				direction_right = FALSE;
				return;
			}
		}
	}

	void  signallights(uint8_t value){
		if(value == 1){ call Leds.led0On(); call Leds.led1Off(); call Leds.led2Off();
		} if(value == 2){ call Leds.led0Off(); call Leds.led1On(); call Leds.led2Off();
		} if(value == 3){ call Leds.led0On(); call Leds.led1On(); call Leds.led2Off();
		} if(value == 4){ call Leds.led0Off(); call Leds.led1Off(); call Leds.led2On();
		} if(value == 5){ call Leds.led0On(); call Leds.led1Off(); call Leds.led2On();
		} if(value == 6){ call Leds.led0Off(); call Leds.led1On(); call Leds.led2On();
		} if(value == 7){ call Leds.led0On(); call Leds.led1On(); call Leds.led2On();
		}
		else
		  call Leds.led0Off(); call Leds.led1Off(); call Leds.led2Off();
	}
}


