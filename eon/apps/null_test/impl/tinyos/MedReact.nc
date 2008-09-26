configuration MedReact
{
  provides
  {
    interface StdControl;
    interface IMedReact;
  }
}
implementation
{
  components MedReactM;

  StdControl = MedReactM.StdControl;
  IMedReact = MedReactM.IMedReact;
}
