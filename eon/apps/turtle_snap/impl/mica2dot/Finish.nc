configuration Finish
{
  provides
  {
    interface StdControl;
    interface IFinish;
  }
}
implementation
{
  components FinishM;

  StdControl = FinishM.StdControl;
  IFinish = FinishM.IFinish;
}
