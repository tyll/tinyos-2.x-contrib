/*
* Copyright (c) 2007 New University of Lisbon - Faculty of Sciences and
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
* Technology nor the names of
*   its contributors may be used to endorse or promote products derived
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
 * @author Ricardo Tiago
 */


#include "TestFireSim.h"

module TestFireSimP {
	uses {
		interface Boot;
		interface Timer<TMilli> as FireTimer;
		interface SimFire;
		interface SimMote;
	}
}
implementation {
	
	event void Boot.booted() {
		dbg("FireSim","%s: booted @ %s\n",__FUNCTION__,sim_time_string());
		call FireTimer.startOneShot(10240);
	} 

	event void FireTimer.fired() {
		dbg("FireSim","%s: fire started @ %s\n",__FUNCTION__,sim_time_string());
		call SimFire.start();
	}

	event void SimFire.died() {
		dbg("FireSim","%s: node destroyed by fire - turning off @ %s\n",__FUNCTION__,sim_time_string());
		call SimMote.turnOff();
	}

	event void SimFire.red() {
		dbg("FireSim","%s: sensors in red @ %s\n",__FUNCTION__,sim_time_string());
	}

	event void SimFire.yellow() {
		dbg("FireSim","%s: sensors in yellow @ %s\n",__FUNCTION__,sim_time_string());
	}	

}
