module CC2420CsmaC {

	provides {
		interface SplitControl;
		interface RadioBackoff;
	}

	uses {
		interface SplitControl as SubControl;
	}
	
} implementation {
	
	uint8_t running = FALSE;

	command error_t SplitControl.start() {
		dbg("CC2420Csma","CSMA start\n");
		if(running) {
			return FAIL;
		} 
#ifdef SOFTWAREENERGY
		softenergy_on(SOFTENERGY_COMPONENT_RADIO_RECEIVE);
#endif
		return call SubControl.start();
	}
	
  event void SubControl.startDone(error_t error) {
		running = TRUE;
		dbg("CC2420Csma","CSMA startDone\n");
		signal SplitControl.startDone(error);
	}

  command error_t SplitControl.stop() {
		if(!running) {
			return FAIL;
		}
#ifdef SOFTWAREENERGY
		softenergy_off(SOFTENERGY_COMPONENT_RADIO_RECEIVE);
#endif
		dbg("CC2420Csma","CSMA stop\n");
		return call SubControl.stop();
	}

  event void SubControl.stopDone(error_t error) {
		running = FALSE;
		dbg("CC2420Csma","CSMA stopDone\n");
		signal SplitControl.stopDone(error);
	}

  async command void RadioBackoff.setInitialBackoff(uint16_t backoffTime) {}

  async command void RadioBackoff.setCongestionBackoff(uint16_t backoffTime) {}

  async command void RadioBackoff.setCca(bool ccaOn) {}

}
