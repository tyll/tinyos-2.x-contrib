configuration MedCheckVal
{
  provides
  {
    interface StdControl;
    interface IMedCheckVal;
  }
}
implementation
{
  components MedCheckValM;

  StdControl = MedCheckValM.StdControl;
  IMedCheckVal = MedCheckValM.IMedCheckVal;
}
