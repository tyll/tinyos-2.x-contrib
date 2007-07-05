configuration SensorTestC {

}
implementation {
	components
		MainC,
		SensorTestP,
 		LedsC,
  		new TimerMilliC(), 
		new SensirionSht71C() as Sensor,
  		DSNC;
  		
  SensorTestP.Boot -> MainC;
  SensorTestP.Timer -> TimerMilliC;
  SensorTestP.Read -> Sensor.Temperature;
  SensorTestP.Leds -> LedsC;
  SensorTestP.DSN -> DSNC;
}
