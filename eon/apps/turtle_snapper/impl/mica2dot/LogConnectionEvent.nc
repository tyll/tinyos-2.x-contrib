configuration LogConnectionEvent
{
  provides
  {
    interface StdControl;
    interface ILogConnectionEvent;
  }
}
implementation
{
  components LogConnectionEventM;

  StdControl = LogConnectionEventM.StdControl;
  ILogConnectionEvent = LogConnectionEventM.ILogConnectionEvent;
}
