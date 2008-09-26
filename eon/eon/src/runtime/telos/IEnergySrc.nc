includes energystructs;

interface IEnergySrc
{
	//predict energy pdf for next <minutes> minutes.
  command int32_t getEnergyPrediction(uint16_t minutes); 
  
}
