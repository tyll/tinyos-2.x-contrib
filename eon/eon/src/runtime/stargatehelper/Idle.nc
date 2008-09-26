


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
  components IdleM, SysTimeC, SrcAccumC, TimerC;

  IIdle = IdleM.IIdle;
  
  StdControl = IdleM.StdControl;
  StdControl = SrcAccumC.StdControl;
  StdControl = TimerC.StdControl;
  
 
	IdleM.IAccum -> SrcAccumC.IAccum;
	IdleM.SysTime -> SysTimeC.SysTime;
	IdleM.Timer -> TimerC.Timer[unique("Timer")];

}
