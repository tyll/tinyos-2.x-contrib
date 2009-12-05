/**
 * Sensors on Telosw, including Accelerometer, light sensor, temperature and humidity senor.
 * Wakeup ADCs on expansion connector
 * iCount energy meter
 *
 * @author Gang Lu 
 */

generic configuration OctopusSensorC()
{
	provides{
		interface EnergyMeter;

		interface WakeupADC;
		interface WakeupADC as WakeupLight;
		interface NormalADC;
		interface Read<uint16_t> as WakeupADCRead;
		interface Read<uint16_t> as NormalADCRead;
		interface Read<uint16_t> as LightRead;
		interface Read<uint16_t> as BatteryRead;

		interface Accelerometer;
		interface Read<acc_t> as AccelerometerRead;

		interface Read<uint16_t> as TemperatureRead;
		interface Read<uint16_t> as HumidityRead;
	}
}
implementation
{
	components new SensirionSht11C() as Sht11;
	TemperatureRead = Sht11.Temperature;
	HumidityRead = Sht11.Humidity;

	components AccelerometerC;
	Accelerometer = AccelerometerC;
	AccelerometerRead = AccelerometerC;

	components EnergyMeterC;
	EnergyMeter = EnergyMeterC;

	components WakeupADCC;
	WakeupADC = WakeupADCC.ADC0;
	WakeupLight = WakeupADCC.ADC1;
	WakeupADCRead = WakeupADCC.ADC0Read;
	LightRead = WakeupADCC.ADC1Read;

	components NormalADCC;
	NormalADCRead = NormalADCC.ADCRead;
	NormalADC = NormalADCC.ADC;

	components BatteryVoltageC;
	BatteryRead = BatteryVoltageC;
}
