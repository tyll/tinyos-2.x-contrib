
interface IEnergyMap
{
	//attribute energy to task.
	command error_t startPath(uint16_t sessionid);
	command error_t endPath(uint16_t sessionid, uint16_t path);
	command uint32_t idlePower(); //in uW
	event void pathEnergy(uint16_t path, uint32_t energy, bool micro);  //in mJ or uJ
	
  
}
