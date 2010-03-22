configuration IICC
{
	provides{
		interface IIC;
	}
}
implementation{
	components IICP;

	components new Msp430GpioC() as data;
	components new Msp430GpioC() as clock;
	components HplMsp430GeneralIOC as GeneralIOC;

	data -> GeneralIOC.Port41;
	clock -> GeneralIOC.Port40;

	IICP.DATA -> data;
	IICP.CLOCK -> clock;

	IIC = IICP.IIC;
}
