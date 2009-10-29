configuration MeasurementCollectorC {

  uses interface Leds;
  provides interface MeasurementCollector;

} implementation {

  components MeasurementCollectorP;

  components new SensirionSht11C()     as HumTempSensor;
  components new HamamatsuS10871TsrC() as LightTsrSensor;
  components new HamamatsuS1087ParC()  as LightParSensor;
  components new VoltageC()            as VoltSensor;

  MeasurementCollectorP.ReadTemp -> HumTempSensor.Temperature;
  MeasurementCollectorP.ReadHum  -> HumTempSensor.Humidity;
  MeasurementCollectorP.ReadVolt -> VoltSensor.Read;
  MeasurementCollectorP.ReadTSR  -> LightTsrSensor.Read;
  MeasurementCollectorP.ReadPAR  -> LightParSensor.Read;

  MeasurementCollectorP.Leds = Leds;

  MeasurementCollectorP.MeasurementCollector = MeasurementCollector;
}
