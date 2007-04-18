generic configuration DemoSensorC()
{
  provides interface Read<uint16_t>;
}
implementation
{
  components new SensirionSht11C() as DemoSensor;
  Read = DemoSensor.Temperature;
}
