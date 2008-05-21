generic configuration SensorNowC()
{
  provides interface ReadNow<uint16_t>;
  provides interface Resource;
}
implementation
{
  components SensorP, new AdcReadNowClientC();
  
  ReadNow = AdcReadNowClientC;
  Resource = AdcReadNowClientC;
  AdcReadNowClientC.Hcs08AdcConfig -> SensorP;
  AdcReadNowClientC.ResourceConfigure -> SensorP;
}