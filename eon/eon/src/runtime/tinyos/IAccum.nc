

interface IAccum
{
	//used for long time scale measurements
  command uint32_t getInMicroJoules();
  command uint32_t getOutMicroJoules();
  
  event void update(int32_t inuJ, int32_t outuJ);
  
  //general purpose
  command uint64_t getReserve();
  command uint64_t getCapacity();
  
  //extra state 
  command uint16_t getVoltage();
  command int16_t getTemperature();
  command int16_t getTemperature2();
  
}
