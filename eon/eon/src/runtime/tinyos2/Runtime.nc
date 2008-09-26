#include "StorageVolumes.h"
#include "nodes.h"


configuration Runtime
{
}
implementation
{
  components MainC, RuntimeM;
  
  components new TimerMilliC () as Timer1;
  //components new TimerMilliC () as Timer2;
  components new TimerMilliC () as Timer3;
  components new TimerMilliC () as Timer4;
  components Evaluator, LedsC as Leds;
  components NodeCalls;
  components EonScheduler;
  
  components new ConfigStorageC(VOLUME_EONCONFIG) as EonConfigC;
  ;
  
  RuntimeM.Boot -> MainC.Boot;
  
  MainC.SoftwareInit -> RuntimeM.Init;
  
  //RuntimeM.SubControl -> EnergyMapper.StdControl;
  RuntimeM.SubControl -> Evaluator.StdControl;
  RuntimeM.SubControl -> NodeCalls.StdControl;
  RuntimeM.SubControl -> EonScheduler.StdControl;
  
  
  //RuntimeM.DummyPathDone->RuntimeM.IPathDone;
  //RuntimeM.IEnergyMap	-> EnergyMapper;
  
  RuntimeM.SaveTimer	-> Timer1;
  //RuntimeM.RecoverTimer	-> Timer2;
  RuntimeM.EvalTimer	-> Timer3;
  RuntimeM.RTClockTimer	-> Timer4;
  RuntimeM.IEval		-> Evaluator.IEval;
  RuntimeM.IScheduler -> EonScheduler;
	
  
  
  RuntimeM.Mount -> EonConfigC.Mount;
  RuntimeM.ConfigStorage -> EonConfigC.ConfigStorage;
  //EonScheduler.EonFlows -> NodeCalls.EonFlows;
  //EonScheduler.EonGraph -> NodeCalls.EonGraph;
}
