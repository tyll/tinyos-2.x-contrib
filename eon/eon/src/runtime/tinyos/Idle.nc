


configuration Idle
{
  provides
  {
    interface StdControl;
    interface IIdle;
  }

}

implementation
{
  components IdleM, EnergyMapper;

  IIdle = IdleM.IIdle;
  
  StdControl = IdleM.StdControl;
  StdControl = EnergyMapper.StdControl;
  
  IdleM.IEnergyMap -> EnergyMapper.IEnergyMap;

}
