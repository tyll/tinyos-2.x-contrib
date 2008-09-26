configuration Compress
{
  provides
  {
    interface StdControl;
    interface ICompress;
  }
}
implementation
{
  components CompressM, FlashStore;

  StdControl = CompressM.StdControl;
  ICompress = CompressM.ICompress;
  
  //StdControl = LZSSM;
  
  //CompressM.ILZSS -> LZSSM.ILZSS;
  CompressM.StreamExport -> FlashStore.StreamExport;  
}
