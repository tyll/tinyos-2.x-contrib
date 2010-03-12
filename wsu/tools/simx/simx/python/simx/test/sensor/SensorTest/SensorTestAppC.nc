configuration SensorTestAppC { }
implementation
{
  components SensorTestC, MainC,
    new TimerMilliC() as Timer1,
    new TimerMilliC() as Timer2,
    new SimxSensorC(0, uint16_t) as Sensor1,
    new SimxSensorC(1, uint32_t) as Sensor2;

  SensorTestC.Boot -> MainC;
  SensorTestC.Timer1 -> Timer1;
  SensorTestC.Timer2 -> Timer2;
  SensorTestC.Read1 -> Sensor1.Read;
  SensorTestC.Read2 -> Sensor2.Read;
  
}
