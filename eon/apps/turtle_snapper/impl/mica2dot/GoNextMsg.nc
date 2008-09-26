configuration GoNextMsg
{
  provides
  {
    interface StdControl;
    interface IGoNextMsg;
  }
}
implementation
{
	components GoNextMsgM, FlashStore, RadioComm;

	StdControl = RadioComm;
	StdControl = GoNextMsgM.StdControl;
	
	IGoNextMsg = GoNextMsgM.IGoNextMsg;
	
	GoNextMsgM.MyIndex -> FlashStore.MyIndex;
	GoNextMsgM.SendMsg -> RadioComm.SendMsg[AM_BUNDLE_INDEX_ACK];
	GoNextMsgM.SingleStream -> FlashStore.SingleStream;
}
