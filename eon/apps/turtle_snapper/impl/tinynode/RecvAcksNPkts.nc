includes fluxconst;

configuration RecvAcksNPkts
{
  provides
  {
    interface StdControl;
    interface IRecvAcksNPkts;
  }
  
}
implementation
{
  components RecvAcksNPktsM, RadioComm, AckStoreC, ConnMgrC, ObjLogC, TimerC, NoLeds as Leds;

  StdControl = TimerC;
  
  StdControl = RecvAcksNPktsM.StdControl;
  IRecvAcksNPkts = RecvAcksNPktsM.IRecvAcksNPkts;
  
  RecvAcksNPktsM.PreReceive -> RadioComm.ReceiveMsg[AM_PREDATA];
  RecvAcksNPktsM.AckReceive -> RadioComm.ReceiveMsg[AM_ACKMSG];
  RecvAcksNPktsM.DataReceive -> RadioComm.ReceiveMsg[AM_DATAMSG];
  RecvAcksNPktsM.ArchiveReceive -> RadioComm.ReceiveMsg[AM_ARCHIVEMSG];
  
  RecvAcksNPktsM.ConnMgr -> ConnMgrC.ConnMgr;
  RecvAcksNPktsM.AckStore -> AckStoreC.AckStore;
  RecvAcksNPktsM.ObjLog -> ObjLogC.ObjLog[unique("ObjLog")];
  RecvAcksNPktsM.Timer -> TimerC.Timer[unique("Timer")];
  RecvAcksNPktsM.Leds -> Leds;
}
