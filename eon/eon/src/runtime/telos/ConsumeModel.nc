


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
  components ConsumeModelM;

  IConsumeModel = ConsumeModelM.ILoadModel;
  StdControl = ConsumeModelM.StdControl;
  //StdControl = TimerC.StdControl;
  

  //ConsumeModelM.Timer = TimerC.Timer[unique ("Timer")]; 


}
