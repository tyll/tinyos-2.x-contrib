interface IIdle
{
	//returns the estimates idle power draw of the device
  command int32_t getIdle(); 
  command error_t setLoad(int numpaths);
}
