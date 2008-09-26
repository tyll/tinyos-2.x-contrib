configuration IgnoreConnection
{
  provides
  {
    interface StdControl;
    interface IIgnoreConnection;
  }
}
implementation
{
  components IgnoreConnectionM;

  StdControl = IgnoreConnectionM.StdControl;
  IIgnoreConnection = IgnoreConnectionM.IIgnoreConnection;
  
}
