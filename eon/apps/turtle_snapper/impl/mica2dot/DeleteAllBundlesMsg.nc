configuration DeleteAllBundlesMsg
{
  provides
  {
    interface StdControl;
    interface IDeleteAllBundlesMsg;
  }
}
implementation
{
	components DeleteAllBundlesMsgM, FlashStore, RadioComm;
	
	StdControl = RadioComm;
	
	StdControl = DeleteAllBundlesMsgM.StdControl;
	IDeleteAllBundlesMsg = DeleteAllBundlesMsgM.IDeleteAllBundlesMsg;
	DeleteAllBundlesMsgM.MyIndex -> FlashStore.MyIndex;
	DeleteAllBundlesMsgM.SendMsg -> RadioComm.SendMsg[AM_DELETE_ALL_ACK];
}
