configuration EvenReact
{
  provides
  {
    interface StdControl;
    interface IEvenReact;
  }
}
implementation
{
  components EvenReactM;

  StdControl = EvenReactM.StdControl;
  IEvenReact = EvenReactM.IEvenReact;
}
