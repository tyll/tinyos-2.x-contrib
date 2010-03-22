configuration BatteryVoltageC{
	provides{
		interface Read<uint16_t> as BatteryRead;
	}
}
implementation
{
	components new AdcReadClientC() as adc;
	components new NormalADCP(INPUT_CHANNEL_A3) as battery;

	components HplMsp430GeneralIOC as GeneralIOC;
	components new Msp430GpioC() as adcIO;
	adcIO -> GeneralIOC.Port63;
	battery.ADC -> adcIO;

	adc.AdcConfigure -> battery.AdcConfigure;
	BatteryRead = adc.Read;

	components LedsC;
	battery.Leds -> LedsC;
}
