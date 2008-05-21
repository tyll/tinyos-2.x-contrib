generic configuration DemoSensorNowC()
{
  provides interface ReadNow<uint16_t>;
  provides interface Resource;
}
implementation
{
  components new SensorNowC();
  
  ReadNow = SensorNowC;
  Resource = SensorNowC;
}