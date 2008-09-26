
interface IEnergyMap
{
	//attribute energy to task.
	command result_t startPath(uint16_t sessionid);
	command result_t getPathEnergy(uint16_t sessionid, uint32_t* energy);  //in 0.01mJ
  
}
