configuration SetNoTxBW
{
  provides
  {
    interface StdControl;
    interface ISetNoTxBW;
  }
}
implementation
{
  components SetNoTxBWM;

  StdControl = SetNoTxBWM.StdControl;
  ISetNoTxBW = SetNoTxBWM.ISetNoTxBW;
}
