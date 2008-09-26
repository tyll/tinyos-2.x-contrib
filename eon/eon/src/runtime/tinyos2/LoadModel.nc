


configuration LoadModel
{
  provides
  {
    interface StdControl;
    interface ILoadModel;
  }

}

implementation
{
  components LoadModelM;
  components new TimerMilliC() as Timer0;
  components MainC;
  components RuntimeM;
  LoadModelM.RuntimeState -> RuntimeM.RuntimeState;
  
  
  MainC.SoftwareInit -> LoadModelM.Init;
  

  ILoadModel = LoadModelM.ILoadModel;
  
  StdControl = LoadModelM.StdControl;
  
  

  LoadModelM.Timer0 -> Timer0; 


}
