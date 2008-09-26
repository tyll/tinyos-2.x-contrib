configuration GetBundleMsg
{
	provides
	{
		interface StdControl;
		interface IGetBundleMsg;
	}
}
implementation
{
	components GetBundleMsgM, FlashStore, RadioComm, TimerC;
	components LedsC;
	
	StdControl = RadioComm;
	
	StdControl = GetBundleMsgM.StdControl;
	
	IGetBundleMsg = GetBundleMsgM.IGetBundleMsg;
	GetBundleMsgM.MyIndex -> FlashStore.MyIndex;
	GetBundleMsgM.SingleStream -> FlashStore.SingleStream;
	GetBundleMsgM.SendMsg -> RadioComm.SendMsg[AM_BUNDLE_INDEX_ACK];
	GetBundleMsgM.Timer -> TimerC.Timer[unique("Timer")];
	GetBundleMsgM.Leds -> LedsC;
}
