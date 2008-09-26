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
	components CollectDataM, RadioComm, 
		CC1000RadioIntM as Radio,
		LedsC as Leds, TimerC;
	
	StdControl = CollectDataM.StdControl;
	StdControl = RadioComm;
	StdControl = TimerC;
	
	
	ICollectData = CollectDataM.ICollectData;
	//CollectDataM.ReceiveBeginTraversalMsg -> RadioComm.ReceiveMsg[AM_BEGIN_TRAVERSAL_MSG];
	//CollectDataM.ReceiveGoNextMsg -> RadioComm.ReceiveMsg[AM_GO_NEXT_MSG];
	//CollectDataM.ReceiveGetNextChunkMsg -> RadioComm.ReceiveMsg[AM_GET_NEXT_CHUNK];
	CollectDataM.ReceiveGetBundleMsg -> RadioComm.ReceiveMsg[AM_GET_BUNDLE_MSG];
	//CollectDataM.ReceiveDeleteBundleMsg -> RadioComm.ReceiveMsg[AM_DELETE_BUNDLE_MSG];
	CollectDataM.ReceiveDeleteAllBundlesMsg -> RadioComm.ReceiveMsg[AM_DELETE_ALL_BUNDLES_MSG];
	//CollectDataM.ReceiveEndCollectionSessionMsg -> RadioComm.ReceiveMsg[AM_END_DATA_COLLECTION_SESSION];
	
	CollectDataM.ReceiveRadioHiPowerMsg -> RadioComm.ReceiveMsg[AM_RADIO_HI_POWER];
	CollectDataM.ReceiveRadioLoPowerMsg -> RadioComm.ReceiveMsg[AM_RADIO_LO_POWER];
	
	CollectDataM.SetListeningMode -> Radio.SetListeningMode;
	CollectDataM.GetListeningMode -> Radio.GetListeningMode;

	CollectDataM.SendMsg -> RadioComm.SendMsg[AM_DEADLOCK_MSG];
	
	CollectDataM.Leds -> Leds;
	CollectDataM.Timer -> TimerC.Timer[unique("Timer")];
}
