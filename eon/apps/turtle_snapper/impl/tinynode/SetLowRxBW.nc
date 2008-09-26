configuration SetLowRxBW
{
  provides
  {
    interface StdControl;
    interface ISetLowRxBW;
  }
}
implementation
{
  components SetLowRxBWM;

  StdControl = SetLowRxBWM.StdControl;
  ISetLowRxBW = SetLowRxBWM.ISetLowRxBW;
}
