configuration FastCheckVal
{
  provides
  {
    interface StdControl;
    interface IFastCheckVal;
  }
}
implementation
{
  components FastCheckValM;

  StdControl = FastCheckValM.StdControl;
  IFastCheckVal = FastCheckValM.IFastCheckVal;
}
