generic configuration SensorStreamC()
{
  provides interface ReadStream<uint16_t>;
}
implementation
{
  components SensorP, new AdcReadStreamClientC();
  
  ReadStream = AdcReadStreamClientC;
  AdcReadStreamClientC.Hcs08AdcConfig -> SensorP;
  AdcReadStreamClientC.ResourceConfigure -> SensorP;
}