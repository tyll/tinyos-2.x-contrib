configuration SendData
{
  provides
  {
    interface StdControl;
    interface ISendData;
  }
}
implementation
{
  components SendDataM, ConnMgrC, RadioComm, AckStoreC, ObjLogC;

  StdControl = SendDataM.StdControl;
  ISendData = SendDataM.ISendData;
  
  SendDataM.SendMsg-> RadioComm.SendMsg[AM_DATAMSG];
  SendDataM.ConnMgr -> ConnMgrC.ConnMgr;
  SendDataM.AckStore -> AckStoreC.AckStore;
  SendDataM.ObjLog -> ObjLogC.ObjLog[unique("ObjLog")];
}
