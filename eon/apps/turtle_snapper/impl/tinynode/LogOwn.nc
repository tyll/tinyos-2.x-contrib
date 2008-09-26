configuration LogOwn
{
  provides
  {
    interface StdControl;
    interface ILogOwn;
  }
}
implementation
{
  components LogOwnM, ObjLogC;

  StdControl = LogOwnM.StdControl;
  ILogOwn = LogOwnM.ILogOwn;
  LogOwnM.ObjLog -> ObjLogC.ObjLog[unique("ObjLog")];
}
