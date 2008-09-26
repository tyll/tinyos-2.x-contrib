configuration AddToGPSStream
{
  provides
  {
    interface StdControl;
    interface IAddToGPSStream;
  }
}
implementation
{
	components AddToGPSStreamM, FlashStore, RadioComm;

  StdControl = AddToGPSStreamM.StdControl;
  StdControl = RadioComm;
  
  IAddToGPSStream = AddToGPSStreamM.IAddToGPSStream;
  
  //StdControl = FlashStore;
  
  
  AddToGPSStreamM.GpsStream -> FlashStore.GPSStream;
  AddToGPSStreamM.GpsLengthStream -> FlashStore.GPSLengthStream;
  AddToGPSStreamM.SendMsg -> RadioComm.SendMsg[37];
  
} 

