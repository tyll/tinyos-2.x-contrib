configuration SlowReact
{
  provides
  {
    interface StdControl;
    interface ISlowReact;
  }
}
implementation
{
  components SlowReactM;

  StdControl = SlowReactM.StdControl;
  ISlowReact = SlowReactM.ISlowReact;
}
