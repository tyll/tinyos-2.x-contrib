configuration SendAcks
{
  provides
  {
    interface StdControl;
    interface ISendAcks;
  }
}
implementation
{
  components SendAcksM, ConnMgrC, RadioComm, AckStoreC, NoLeds as Leds;

  
  StdControl = SendAcksM.StdControl;
  ISendAcks = SendAcksM.ISendAcks;
  
  SendAcksM.SendMsg -> RadioComm.SendMsg[AM_ACKMSG];
  SendAcksM.ConnMgr -> ConnMgrC.ConnMgr;
  SendAcksM.AckStore -> AckStoreC.AckStore;
  
  SendAcksM.Leds -> Leds;
  
}
