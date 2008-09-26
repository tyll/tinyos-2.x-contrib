configuration CompressRTData
{
  provides
  {
    interface StdControl;
    interface ICompressRTData;
  }
}
implementation
{
	components CompressRTDataM, FlashStore, NoLeds as Leds;

  StdControl = CompressRTDataM.StdControl;
  ICompressRTData = CompressRTDataM.ICompressRTData;
  
  CompressRTDataM.MyIndex -> FlashStore.MyIndex;
  CompressRTDataM.BundleNumStream -> FlashStore.BundleNumStream;
  
  CompressRTDataM.Leds -> Leds;
}
