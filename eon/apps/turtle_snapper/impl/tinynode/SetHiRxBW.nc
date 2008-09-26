configuration SetHiRxBW
{
  provides
  {
    interface StdControl;
    interface ISetHiRxBW;
  }
}
implementation
{
  components SetHiRxBWM;

  StdControl = SetHiRxBWM.StdControl;
  ISetHiRxBW = SetHiRxBWM.ISetHiRxBW;
}
