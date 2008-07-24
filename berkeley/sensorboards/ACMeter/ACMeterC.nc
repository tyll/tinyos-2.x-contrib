// AC Mote and Energy Meter using ADE7753
// @ Fred Jiang <fxjiang@eecs.berkeley.edu>

configuration ACMeterC {
	provides interface SplitControl;
	provides interface ACMeter;
}

implementation {
	components MainC;
	components ACMeterM, ADE7753P, LedsC;
	components new TimerMilliC() as TimerC;
	components new Msp430Spi1C() as SpiC;
	components HplMsp430GeneralIOC;
	
	SplitControl = ACMeterM;
	ACMeter = ACMeterM;
	MainC.SoftwareInit -> ADE7753P.Init;	
	ACMeterM.Leds -> LedsC;
	ACMeterM.ADE7753 -> ADE7753P;
	ACMeterM.MeterControl -> ADE7753P;
	ACMeterM.Timer -> TimerC;
	ACMeterM.onoff -> HplMsp430GeneralIOC.Port21;
	ADE7753P.SpiPacket -> SpiC;
	ADE7753P.SPIFRM -> HplMsp430GeneralIOC.Port26;
	ADE7753P.Leds -> LedsC;
	ADE7753P.Resource -> SpiC;
}
