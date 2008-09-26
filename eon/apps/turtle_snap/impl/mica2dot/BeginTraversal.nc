configuration BeginTraversal
{
  provides
  {
    interface StdControl;
    interface IBeginTraversal;
  }
}
implementation
{
	components BeginTraversalM, FlashStore, RadioComm, NoLeds as Leds;
	
	StdControl = RadioComm;
	
	
	StdControl = BeginTraversalM.StdControl;
	IBeginTraversal = BeginTraversalM.IBeginTraversal;
	BeginTraversalM.MyIndex -> FlashStore.MyIndex;
	BeginTraversalM.Leds -> Leds;
	BeginTraversalM.SendMsg -> RadioComm.SendMsg[AM_BUNDLE_INDEX_ACK];
	BeginTraversalM.BundleNumStream -> FlashStore.BundleNumStream;
}
