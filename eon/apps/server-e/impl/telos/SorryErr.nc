configuration SorryErr
{
  provides
  {
    interface StdControl;
    interface ISorryErr;
    interface IEnergyCost;
  }
}
implementation
{
  components SorryErrM;

  StdControl = SorryErrM.StdControl;
  ISorryErr = SorryErrM.ISorryErr;
  IEnergyCost = SorryErrM.IEnergyCost;
}
