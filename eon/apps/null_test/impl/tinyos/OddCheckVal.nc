configuration OddCheckVal
{
  provides
  {
    interface StdControl;
    interface IOddCheckVal;
  }
}
implementation
{
  components OddCheckValM;

  StdControl = OddCheckValM.StdControl;
  IOddCheckVal = OddCheckValM.IOddCheckVal;
}
