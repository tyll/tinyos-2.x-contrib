configuration ReadRequest
{
  provides
  {
    interface StdControl;
    interface IReadRequest;
  }
}
implementation
{
	components ReadRequestM, RadioComm, NoLeds as Leds;
	
	StdControl = ReadRequestM.StdControl;
	StdControl = RadioComm;
	
	
	IReadRequest = ReadRequestM.IReadRequest;
	
	ReadRequestM.SendMsg -> RadioComm.SendMsg[AM_BUNDLE_INDEX_ACK];
	ReadRequestM.Leds -> Leds;
	
}
