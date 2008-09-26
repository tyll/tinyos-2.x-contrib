

includes sensorboard;
configuration Water
{
  provides 
  	{
  		interface StdControl;
		command bool getLevel(uint16_t *data);
	}
}
implementation
{
  components WaterM, ADCC, TimerC;

 getLevel = WaterM.getLevel;
  StdControl = WaterM;
  StdControl = TimerC;
  
  WaterM.ADCControl -> ADCC;
	WaterM.ADC -> ADCC.ADC[TOS_ADC_WATER_PORT];
	WaterM.Timer -> TimerC.Timer[unique("Timer")];
	
}
