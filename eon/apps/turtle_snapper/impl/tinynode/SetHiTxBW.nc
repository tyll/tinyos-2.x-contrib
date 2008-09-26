configuration SetHiTxBW
{
  provides
  {
    interface StdControl;
    interface ISetHiTxBW;
  }
}
implementation
{
  components SetHiTxBWM;

  StdControl = SetHiTxBWM.StdControl;
  ISetHiTxBW = SetHiTxBWM.ISetHiTxBW;
}
