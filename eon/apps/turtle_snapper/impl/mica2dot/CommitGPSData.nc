configuration CommitGPSData
{
	provides
	{
		interface StdControl;
		interface ICommitGPSData;
	}
}
implementation
{
	components CommitGPSDataM, FlashStore, LedsC as Leds;
			//, InfoStoreC;

	StdControl = CommitGPSDataM.StdControl;
	//StdControl = InfoStoreC;
	ICommitGPSData = CommitGPSDataM.ICommitGPSData;
  
	CommitGPSDataM.MyIndex -> FlashStore.MyIndex;
	CommitGPSDataM.BundleNumStream -> FlashStore.BundleNumStream;
	CommitGPSDataM.Leds -> Leds;
	CommitGPSDataM.GpsStream -> FlashStore.GPSStream;
	//CommitGPSDataM.InfoStore -> InfoStoreC;
}
