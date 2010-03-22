#include "WakeupADC.h"

configuration WakeupADCC{
	provides interface WakeupADC as ADC0;
	provides interface WakeupADC as ADC1;
	provides interface Read<uint16_t> as ADC0Read;
	provides interface Read<uint16_t> as ADC1Read;
}
implementation
{
	components new AdcReadClientC() as Adc0;
	components new WakeupADCP(INPUT_CHANNEL_A0) as wakeupADC0;
	Adc0.AdcConfigure -> wakeupADC0.AdcConfigure;
	ADC0Read = Adc0.Read;

	components new AdcReadClientC() as Adc1;
	components new WakeupADCP(INPUT_CHANNEL_A1) as wakeupADC1;
	Adc1.AdcConfigure -> wakeupADC1.AdcConfigure;
	ADC1Read = Adc1.Read;

	components HplMsp430InterruptP;
	components new Msp430InterruptC() as adc0_int;
	components new Msp430InterruptC() as adc1_int;
	adc0_int.HplInterrupt -> HplMsp430InterruptP.Port17;
	adc1_int.HplInterrupt -> HplMsp430InterruptP.Port10;
	components HplMsp430GeneralIOC as GeneralIOC;
	components new Msp430GpioC() as adc0;
	components new Msp430GpioC() as adc1;
	components new Msp430GpioC() as adc0_int_io;
	components new Msp430GpioC() as adc1_int_io;
	adc0 -> GeneralIOC.Port60;
	adc1 -> GeneralIOC.Port61;
	adc0_int_io -> GeneralIOC.Port17;
	adc1_int_io -> GeneralIOC.Port10;

	wakeupADC0.ADC -> adc0;
	wakeupADC0.ADC_INT -> adc0_int;
	wakeupADC0.ADC_INT_IO -> adc0_int_io;
	wakeupADC1.ADC -> adc1;
	wakeupADC1.ADC_INT -> adc1_int;
	wakeupADC1.ADC_INT_IO -> adc1_int_io;

	ADC0 = wakeupADC0.WakeupADC;
	ADC1 = wakeupADC1.WakeupADC;

	components IICC;
	wakeupADC0.IIC -> IICC.IIC;
	wakeupADC1.IIC -> IICC.IIC;


	components new Msp430GpioC() as adc4;
	adc4 -> GeneralIOC.Port64;
	wakeupADC0.ADC4 -> adc4;
	wakeupADC1.ADC4 -> adc4;
	
	components LedsC;
	wakeupADC0.Leds -> LedsC;
	wakeupADC1.Leds -> LedsC;
}
