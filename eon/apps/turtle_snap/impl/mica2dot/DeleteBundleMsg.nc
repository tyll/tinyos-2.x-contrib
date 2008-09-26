configuration DeleteBundleMsg
{
  provides
  {
    interface StdControl;
    interface IDeleteBundleMsg;
  }
}
implementation
{
	components DeleteBundleMsgM, FlashStore, RadioComm;
	
	StdControl = RadioComm;
	
	StdControl = DeleteBundleMsgM.StdControl;
	IDeleteBundleMsg = DeleteBundleMsgM.IDeleteBundleMsg;
	DeleteBundleMsgM.MyIndex -> FlashStore.MyIndex;
	DeleteBundleMsgM.SendMsg -> RadioComm.SendMsg[AM_BUNDLE_INDEX_ACK];
}
