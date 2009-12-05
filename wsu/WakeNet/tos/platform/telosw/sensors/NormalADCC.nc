configuration NormalADCC{
	provides{
		interface Read<uint16_t> as ADCRead;
		interface NormalADC as ADC;
	}
}
implementation
{
	components new AdcReadClientC() as adc;
	components new NormalADCP(INPUT_CHANNEL_A6) as normalADC;

	components HplMsp430GeneralIOC as GeneralIOC;
	components new Msp430GpioC() as adcIO;
	adcIO -> GeneralIOC.Port66;
	normalADC.ADC -> adcIO;

	adc.AdcConfigure -> normalADC.AdcConfigure;
	ADCRead = adc.Read;

	components LedsC;
	normalADC.Leds -> LedsC;

	ADC = normalADC.NormalADC;
}
