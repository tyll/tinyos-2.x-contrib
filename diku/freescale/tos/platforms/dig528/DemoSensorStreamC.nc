generic configuration DemoSensorStreamC()
{
  provides interface ReadStream<uint16_t>;
}
implementation
{
  components new SensorStreamC();
  
  ReadStream = SensorStreamC;
}