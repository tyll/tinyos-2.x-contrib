configuration BufferedClockC {
}
implementation {
	components
		BufferedClockP,
		MainC,
		new TimerMilliC() as Timer,
		LedsC,
		DSNC,
		new Msp430InternalTemperatureC(),
		new Msp430InternalVoltageC(),
		new SensirionSht11C();
	
	BufferedClockP.Boot-> MainC;
	BufferedClockP.Timer-> Timer;
	BufferedClockP.Leds-> LedsC;
	BufferedClockP.DsnSend-> DSNC;
	
	BufferedClockP.InternalTemp->Msp430InternalTemperatureC;
	BufferedClockP.SensirionTemp->SensirionSht11C.Temperature;
	BufferedClockP.InternalVoltage->Msp430InternalVoltageC;
}
