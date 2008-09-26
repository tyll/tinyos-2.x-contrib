configuration EonSend
{
  provides
  {
    interface StdControl;
    interface IEonSend;
  }
}
implementation
{
  components EonSendM;
  components MainC;
  components EonNetworkC;

  MainC.SoftwareInit->EonSendM.Init;
  StdControl = EonSendM.StdControl;
  IEonSend = EonSendM.IEonSend;
  
  EonSendM.INetwork -> EonNetworkC.INetwork;
}
