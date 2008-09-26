configuration EndCollectionSession
{
  provides
  {
    interface StdControl;
    interface IEndCollectionSession;
  }
}
implementation
{
	components EndCollectionSessionM, FlashStore, 
		CC1000RadioIntM as Radio,
		RadioComm,
		LedsC as Leds;
	
	StdControl = RadioComm;
  StdControl = EndCollectionSessionM.StdControl;
  IEndCollectionSession = EndCollectionSessionM.IEndCollectionSession;
  EndCollectionSessionM.MyIndex -> FlashStore.MyIndex;
  EndCollectionSessionM.SendMsg -> RadioComm.SendMsg[AM_BUNDLE_INDEX_ACK];
  EndCollectionSessionM.SetListeningMode -> Radio.SetListeningMode;
  EndCollectionSessionM.GetListeningMode -> Radio.GetListeningMode;
  EndCollectionSessionM.Leds -> Leds;
}
