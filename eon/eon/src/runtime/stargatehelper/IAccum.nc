

interface IAccum
{
	//used for short time scale measurements
  command uint64_t getInMicroJoules();
  command uint64_t getOutMicroJoules();
  //used for long time-scale measurements
  command int32_t getInMilliLong();
  command int32_t getOutMilliLong();
  //general purpose
  command uint64_t getReserve();
  command uint64_t getCapacity();
  
  //battery state 
  command uint16_t getVoltage();
  command int16_t getTemperature();
  
}
