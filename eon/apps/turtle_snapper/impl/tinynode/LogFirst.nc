configuration LogFirst
{
  provides
  {
    interface StdControl;
    interface ILogFirst;
  }
}
implementation
{
  components LogFirstM, ObjLogC;

  StdControl = LogFirstM.StdControl;
  ILogFirst = LogFirstM.ILogFirst;
  LogFirstM.ObjLog -> ObjLogC.ObjLog[unique("ObjLog")];
}
