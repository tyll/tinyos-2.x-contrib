

interface IEnergySrc
{
	command uint32_t getBattery();
	command uint32_t getBatteryCapacity();
	//predict energy pdf for next <minutes> minutes.
  command int64_t getEnergyPrediction(uint16_t hours); 
  
}
