configuration CollectData
{
  provides
  {
    interface StdControl;
    interface ICollectData;
  }
}
implementation
{
	components CollectDataM, RadioComm, XE1205RadioC as Radio;
	components ConnMgrC;
	
	StdControl = CollectDataM.StdControl;
	StdControl = RadioComm;	
	
	ICollectData = CollectDataM.ICollectData;
	
	CollectDataM.ReceiveMsg -> RadioComm.ReceiveMsg[AM_COLLECTMSG];
	CollectDataM.ConnMgr -> ConnMgrC.ConnMgr;
	
}
