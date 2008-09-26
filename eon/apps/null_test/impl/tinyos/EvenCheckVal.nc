configuration EvenCheckVal
{
  provides
  {
    interface StdControl;
    interface IEvenCheckVal;
  }
}
implementation
{
  components EvenCheckValM;

  StdControl = EvenCheckValM.StdControl;
  IEvenCheckVal = EvenCheckValM.IEvenCheckVal;
}
