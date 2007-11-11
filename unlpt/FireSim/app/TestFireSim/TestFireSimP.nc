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
