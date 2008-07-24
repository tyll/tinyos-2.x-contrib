interface ACMeter {
	// TRUE = is now ON; FALSE = is now OFF
	command bool toggle();
	command bool set(bool state);
	command bool getState();
	command error_t start(uint16_t interval);
	command error_t stop();
	event void sampleDone(uint32_t energy);
}
