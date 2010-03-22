
generic module WakeupADCP(uint8_t channel)  {
	provides
	{
		interface WakeupADC;
		interface AdcConfigure<const msp430adc12_channel_config_t*>;
	}
	uses{
		interface IIC;
		interface GeneralIO as ADC;
		interface GpioInterrupt as ADC_INT;
		interface GeneralIO as ADC_INT_IO;

		interface GeneralIO as ADC4;
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
	command error_t WakeupADC.init()
	{
		call IIC.init();
		call ADC.makeInput();
		call ADC4.makeOutput();
		call ADC4.set();
		call ADC_INT_IO.makeInput();

		if (channel == INPUT_CHANNEL_A0)
			call ADC_INT.enableRisingEdge();
		if (channel == INPUT_CHANNEL_A1)
			call ADC_INT.enableFallingEdge();

		return SUCCESS;
	}

	async event void ADC_INT.fired()
	{
		signal WakeupADC.adc_int();
	}

	command error_t WakeupADC.setThreshold(uint8_t thres, uint8_t inst)
	{
		call IIC.start();
		call IIC.writeByte(ADDR_BYTE);
		call IIC.receiveACK();
		call IIC.writeByte(inst);
		call IIC.receiveACK();
		call IIC.writeByte(thres);
		call IIC.receiveACK();
		call IIC.stop();

		return SUCCESS;
	}

	async command const msp430adc12_channel_config_t* AdcConfigure.getConfiguration() {
		return &config;
	}

	default async event void WakeupADC.adc_int() {}
}
