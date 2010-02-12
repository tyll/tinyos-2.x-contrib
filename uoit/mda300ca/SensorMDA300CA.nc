/**
*  SensorMDA300C brings all the digital and anolog pins to a single component
*  using Read interfaces
*
*  @author Charles Elliott UOIT
*  @modified Feb 27, 2009
*/

generic configuration SensorMDA300CA()
{
  provides
  {   	
   	interface Read<uint16_t> as Vref; //!< voltage
   	
	//interface Read<uint16_t> as Temp; //!< Thermister
  	//interface Read<uint16_t> as Humidity; //!< Humidity sensor
	
	interface Read<uint16_t> as ADC_0; //!< ADC Channel 0 and Comm
	interface Read<uint16_t> as ADC_1; //!< ADC Channel 1 and Comm
	interface Read<uint16_t> as ADC_2; //!< ADC Channel 2 and Comm
	interface Read<uint16_t> as ADC_3; //!< ADC Channel 3 and Comm
	interface Read<uint16_t> as ADC_4; //!< ADC Channel 4 and Comm
	interface Read<uint16_t> as ADC_5; //!< ADC Channel 5 and Comm
	interface Read<uint16_t> as ADC_6; //!< ADC Channel 6 and Comm
	interface Read<uint16_t> as ADC_7; //!< ADC Channel 7 and Comm
	
	interface Read<uint16_t> as ADC_01; //!< ADC Channel 0 and 1
	interface Read<uint16_t> as ADC_23; //!< ADC Channel 2 and 3
	interface Read<uint16_t> as ADC_45; //!< ADC Channel 4 and 5
	interface Read<uint16_t> as ADC_67; //!< ADC Channel 6 and 7
	interface Read<uint16_t> as ADC_10; //!< ADC Channel 1 and 0
	interface Read<uint16_t> as ADC_32; //!< ADC Channel 3 and 2
	interface Read<uint16_t> as ADC_54; //!< ADC Channel 5 and 4
	interface Read<uint16_t> as ADC_76; //!< ADC Channel 7 and 6
	
	interface Read<uint8_t> as DIO; //!< Digital IO
	
	//interface DigOutput as Digital;
  }
}
implementation
{
    components
    new VoltageC(),
	//new Mda300Sht15TempC (),
	//new Mda300Sht15HumC (),
	ADCDeviceC,
	//Sht15DeviceC,
	new DIOC();
    
	//The returned value represents the difference between the battery voltage 
	//and V_BG (1.23V). The formula to convert it to mV is: 1223 * 1024 / value. 
    Vref       = VoltageC;
	
	//Temp 		= Sht15DeviceC.Temp;
  	//Humidity	= Sht15DeviceC.Hum;
	
	ADC_0		= ADCDeviceC.Channel0; //!< ADC Channel 0 and Comm
	ADC_1		= ADCDeviceC.Channel1; //!< ADC Channel 1 and Comm
	ADC_2		= ADCDeviceC.Channel2; //!< ADC Channel 2 and Comm
	ADC_3		= ADCDeviceC.Channel3; //!< ADC Channel 3 and Comm
	ADC_4		= ADCDeviceC.Channel4; //!< ADC Channel 4 and Comm
	ADC_5		= ADCDeviceC.Channel5; //!< ADC Channel 5 and Comm
	ADC_6		= ADCDeviceC.Channel6; //!< ADC Channel 6 and Comm
	ADC_7		= ADCDeviceC.Channel7; //!< ADC Channel 7 and Comm
	
	ADC_01		= ADCDeviceC.Channel01; //!< ADC Channel 0 and 1
	ADC_23		= ADCDeviceC.Channel23; //!< ADC Channel 2 and 3
	ADC_45		= ADCDeviceC.Channel45; //!< ADC Channel 4 and 5
	ADC_67		= ADCDeviceC.Channel67; //!< ADC Channel 6 and 7
	ADC_10		= ADCDeviceC.Channel10; //!< ADC Channel 1 and 0
	ADC_32		= ADCDeviceC.Channel32; //!< ADC Channel 3 and 2
	ADC_54		= ADCDeviceC.Channel54; //!< ADC Channel 5 and 4
	ADC_76		= ADCDeviceC.Channel76; //!< ADC Channel 7 and 6
	
	DIO			= DIOC.Read; //!< Digital IO    
	//Digital     = DIOC.Digital;
}
