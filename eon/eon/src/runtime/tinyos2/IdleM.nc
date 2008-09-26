

module IdleM
{
  provides
  {
    interface StdControl;
    interface IIdle;
  }
  uses
  {
    interface IEnergyMap;
  }

}

implementation
{
	
	
	
  

  command error_t StdControl.start ()
  {
    
    return SUCCESS;
  }

  command error_t StdControl.stop ()
  {
    
    return SUCCESS;
  }

	command int32_t IIdle.getIdle()
	{
		return call IEnergyMap.idlePower();
	}
	
  	command error_t IIdle.setLoad(int numpaths)
	{
		
		return SUCCESS;
	}
	
	event void IEnergyMap.pathEnergy(uint16_t path, uint32_t energy, bool micro)
	{
	}
	
	

}
