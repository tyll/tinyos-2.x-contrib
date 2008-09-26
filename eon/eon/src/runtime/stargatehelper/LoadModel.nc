


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
  components LoadModelM, TimerC;

  ILoadModel = LoadModelM.ILoadModel;
  StdControl = LoadModelM.StdControl;
  StdControl = TimerC.StdControl;
  

  LoadModelM.Timer -> TimerC.Timer[unique ("Timer")]; 


}
