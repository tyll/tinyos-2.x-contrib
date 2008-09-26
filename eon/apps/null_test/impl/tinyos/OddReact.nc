configuration OddReact
{
  provides
  {
    interface StdControl;
    interface IOddReact;
  }
}
implementation
{
  components OddReactM;

  StdControl = OddReactM.StdControl;
  IOddReact = OddReactM.IOddReact;
}
