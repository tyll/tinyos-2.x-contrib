configuration SetNoRxBW
{
  provides
  {
    interface StdControl;
    interface ISetNoRxBW;
  }
}
implementation
{
  components SetNoRxBWM;

  StdControl = SetNoRxBWM.StdControl;
  ISetNoRxBW = SetNoRxBWM.ISetNoRxBW;
}
