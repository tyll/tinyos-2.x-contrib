configuration EonRecv
{
  provides
  {
    interface StdControl;
    interface IEonRecv;
  }
}
implementation
{
  components EonRecvM;
  components MainC;

  MainC.SoftwareInit->EonRecvM.Init;
  StdControl = EonRecvM.StdControl;
  IEonRecv = EonRecvM.IEonRecv;
}
