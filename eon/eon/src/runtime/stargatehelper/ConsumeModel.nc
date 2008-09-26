


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
  components ConsumeModelM, RandomLFSR;

  IConsumeModel = ConsumeModelM.IConsumeModel;
  StdControl = ConsumeModelM.StdControl;
  //StdControl = TimerC.StdControl;
  
  ConsumeModelM.Random -> RandomLFSR;

  //ConsumeModelM.Timer = TimerC.Timer[unique ("Timer")]; 


}
