


configuration ConsumeModel
{
  provides
  {
    interface StdControl;
    interface IConsumeModel;
  }

}

implementation
{
  components ConsumeModelM;//, RandomLFSR;
  components MainC;
  components RuntimeM;
  ConsumeModelM.RuntimeState -> RuntimeM.RuntimeState;
  
  MainC.SoftwareInit -> ConsumeModelM.Init;
  
  
  
  IConsumeModel = ConsumeModelM.IConsumeModel;
  
  StdControl = ConsumeModelM.StdControl;
  

}
