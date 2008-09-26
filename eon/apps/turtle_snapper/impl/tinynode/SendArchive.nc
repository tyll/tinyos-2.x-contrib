configuration SendArchive
{
  provides
  {
    interface StdControl;
    interface ISendArchive;
  }
}
implementation
{
  components SendArchiveM, ConnMgrC, RadioComm, AckStoreC, ObjLogC;

  StdControl = SendArchiveM.StdControl;
  ISendArchive = SendArchiveM.ISendArchive;
  
  SendArchiveM.SendMsg-> RadioComm.SendMsg[AM_ARCHIVEMSG];
  SendArchiveM.ConnMgr -> ConnMgrC.ConnMgr;
  SendArchiveM.AckStore -> AckStoreC.AckStore;
  SendArchiveM.ObjLog -> ObjLogC.ObjLog[unique("ObjLog")];
}
