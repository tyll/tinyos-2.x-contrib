configuration SetLowTxBW
{
  provides
  {
    interface StdControl;
    interface ISetLowTxBW;
  }
}
implementation
{
  components SetLowTxBWM;

  StdControl = SetLowTxBWM.StdControl;
  ISetLowTxBW = SetLowTxBWM.ISetLowTxBW;
}
