#include "Accelerometer.h"

configuration AccelerometerC{
	provides {
		interface Accelerometer;
		interface Read<acc_t> as AccelerometerRead;
	}
}
implementation{
	components HplMsp430InterruptP;
	components new Msp430InterruptC() as Acc_int1;
	components new Msp430InterruptC() as Acc_int2;
	Acc_int1.HplInterrupt -> HplMsp430InterruptP.Port15;
	Acc_int2.HplInterrupt -> HplMsp430InterruptP.Port16;

	components HplMsp430GeneralIOC as GeneralIOC;
	components new Msp430GpioC() as int1_io;
	components new Msp430GpioC() as int2_io;
	int1_io -> GeneralIOC.Port15;
	int2_io -> GeneralIOC.Port16;
	AccelerometerP.INT1_IO -> int1_io;
	AccelerometerP.INT2_IO -> int2_io;

	components new Msp430GpioC() as adc4;
	adc4 -> GeneralIOC.Port64;
	AccelerometerP.ADC4 -> adc4;

	components AccelerometerP, IICC;
	AccelerometerP.IIC -> IICC;
	AccelerometerP.INT1 -> Acc_int1;
	AccelerometerP.INT2 -> Acc_int2;

	Accelerometer = AccelerometerP.Accelerometer;
	AccelerometerRead = AccelerometerP;

	components LedsC;
	AccelerometerP.Leds -> LedsC;
}
