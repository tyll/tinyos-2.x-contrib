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

#include <sim_fire.h>

module SimFireP {
	provides interface SimFire;
	uses interface Timer<TMilli> as FireTimer;
}

implementation {

	int posx[20]; //Position X of Nodes
	int posy[20]; //Position Y of Nodes
	int nodes_grid[20]; //Nodes in Danger
	uint32_t node_fire; //Node in Danger

	uint32_t timer = 0; 

	/* Each minute this event checks which nodes are in RED,YELLOW or DEAD*/
	event void FireTimer.fired() {
		int xsize;
		int ysize;
		uint8_t i;
		uint32_t timer_fire;
		++timer;
		if (timer % 60 == 0) {
			timer_fire = timer/60;
			xsize = getPositionXFromValue(timer_fire,posx);
			ysize = getPositionYFromValue(timer_fire,posy);
			getNodeFromXY(posx,xsize,posy,ysize,nodes_grid);
			for (i = 0; i < xsize; i++) {
				node_fire	= nodes_grid[i];
				if (node_fire != 0 && node_fire==TOS_NODE_ID) {
					signal SimFire.died();
					return;
				}
			}
			if (checkRed(posx,posy,xsize)) {
					signal SimFire.red();
					return;
			}
			else if (checkYellow(posx,posy,xsize)) {
					signal SimFire.yellow();
					return;
			}
		}
	}

	/* Start the Fire Simulation */
	command void SimFire.start() {
		dbg("FireSim","%s: fire started @ %s\n",__FUNCTION__,sim_time_string());
		getMyPos();
		call FireTimer.startPeriodic(1024);
		return;
	}

	/* Stop the Fire Simulation */
	command void SimFire.stop() {
		//not implemented
		return;
	}
}
