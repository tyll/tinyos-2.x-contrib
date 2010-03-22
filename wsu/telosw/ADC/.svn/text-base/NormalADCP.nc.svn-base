generic module NormalADCP(uint8_t channel)
{
	provides{
		interface NormalADC;
		interface AdcConfigure<const msp430adc12_channel_config_t*>;
	}
	uses{
		interface GeneralIO as ADC;
		interface Leds;
	}
}
implementation
{
	msp430adc12_channel_config_t config = {
	//		inch: INPUT_CHANNEL_A0,
			inch: channel,
			sref: REFERENCE_VREFplus_AVss,
			ref2_5v: REFVOLT_LEVEL_2_5,
			adc12ssel: SHT_SOURCE_ACLK,
			adc12div: SHT_CLOCK_DIV_1,
			sht: SAMPLE_HOLD_4_CYCLES,
			sampcon_ssel: SAMPCON_SOURCE_SMCLK,
			sampcon_id: SAMPCON_CLOCK_DIV_1
	};	

	command error_t NormalADC.init()
	{
		call ADC.makeInput();
	}

	async command const msp430adc12_channel_config_t* AdcConfigure.getConfiguration() {
		return &config;
	}

}
