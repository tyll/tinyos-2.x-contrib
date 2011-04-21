/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   June 6 2010
 */

#include "UnifiedBroadcastApp.h"

module UnifiedBroadcastAppP @safe() {

	uses {
		interface Boot;
		interface Leds;

		interface SplitControl as SerialControl;
		interface SplitControl as RadioControl;
	}

} implementation {

	/********** Init **********/

	event void Boot.booted() {
		call SerialControl.start();
		call RadioControl.start();
	}
 
	event void SerialControl.startDone(error_t error) {
		if(error!=SUCCESS) {
			call SerialControl.start();
		}
	}

	event void SerialControl.stopDone(error_t error) {

	}

	event void RadioControl.startDone(error_t error) {
		if(error!=SUCCESS) {
			call RadioControl.start();
		}
	}

	event void RadioControl.stopDone(error_t error) {

	}

}
