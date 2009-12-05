interface WakeupADC
{
	command error_t init();
	command error_t setThreshold(uint8_t thres, uint8_t inst);

	async event void adc_int();
}
