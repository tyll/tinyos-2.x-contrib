configuration SlowCheckVal
{
  provides
  {
    interface StdControl;
    interface ISlowCheckVal;
  }
}
implementation
{
  components SlowCheckValM;

  StdControl = SlowCheckValM.StdControl;
  ISlowCheckVal = SlowCheckValM.ISlowCheckVal;
}
