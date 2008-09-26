

configuration EonScheduler
{
	provides
	{
		interface StdControl;
		interface IScheduler;
	}
}

implementation
{
	components EonSchedulerM;
	components EnergyMapper;
	components MainC;
	components NodeCalls;
	components RuntimeM;
	
	components new TimerMilliC () as Timer0;

	MainC.SoftwareInit -> EonSchedulerM.Init;
	StdControl = EonSchedulerM.StdControl;
	IScheduler = EonSchedulerM.IScheduler;
	
	EonSchedulerM.QueueTimer -> Timer0; 
	EonSchedulerM.EonGraph -> NodeCalls.EonGraph;
	EonSchedulerM.EonFlows -> NodeCalls.EonFlows;
	EonSchedulerM.IEnergyMap -> EnergyMapper.IEnergyMap;
	
	EonSchedulerM.RuntimeState -> RuntimeM.RuntimeState;
}
