configuration SetBlinkVal
{
  provides
  {
    interface StdControl;
    interface ISetBlinkVal;
  }
}
implementation
{
  components SetBlinkValM;

  StdControl = SetBlinkValM.StdControl;
  ISetBlinkVal = SetBlinkValM.ISetBlinkVal;
}
