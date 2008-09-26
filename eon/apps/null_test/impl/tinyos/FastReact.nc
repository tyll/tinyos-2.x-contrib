configuration FastReact
{
  provides
  {
    interface StdControl;
    interface IFastReact;
  }
}
implementation
{
  components FastReactM;

  StdControl = FastReactM.StdControl;
  IFastReact = FastReactM.IFastReact;
}
