interface IIdle
{
	//returns the estimates idle power draw of the device
  command int32_t getIdle(); 
  command result_t setLoad(int numpaths);
}
