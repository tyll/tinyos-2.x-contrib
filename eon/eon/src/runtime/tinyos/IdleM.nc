

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
	
	
	
  command result_t StdControl.init ()
  {
  	
  	return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    
    return SUCCESS;
  }

	command int32_t IIdle.getIdle()
	{
		return call IEnergyMap.idlePower();
	}
	
  	command result_t IIdle.setLoad(int numpaths)
	{
		
		return SUCCESS;
	}
	
	event void IEnergyMap.pathEnergy(uint16_t path, uint32_t energy, bool micro)
	{
	}
	
	

}
