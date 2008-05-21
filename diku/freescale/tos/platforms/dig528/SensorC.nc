generic configuration SensorC()
{
  provides interface Read<uint16_t>;
}
implementation
{
  components SensorP, new AdcReadClientC();
  
  Read = AdcReadClientC;
  AdcReadClientC.Hcs08AdcConfig -> SensorP;
  AdcReadClientC.ResourceConfigure -> SensorP;
}