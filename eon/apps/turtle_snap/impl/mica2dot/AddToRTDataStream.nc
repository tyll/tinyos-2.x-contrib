configuration AddToRTDataStream
{
  provides
  {
    interface StdControl;
    interface IAddToRTDataStream;
  }
   
}
implementation
{
  components AddToRTDataStreamM, SrcAccumC, FlashStore, NoLeds as Leds, Water, TimerC;

  StdControl = AddToRTDataStreamM.StdControl;
  StdControl = TimerC;
  IAddToRTDataStream = AddToRTDataStreamM.IAddToRTDataStream;
  
  AddToRTDataStreamM.SingleStream -> FlashStore.SingleStream;
  AddToRTDataStreamM.Leds -> Leds;
  AddToRTDataStreamM.IAccum -> SrcAccumC;
  //AddToRTDataStreamM.WaterTimer -> TimerC.Timer[unique("Timer")];
  //AddToRTDataStreamM.WaterControl -> Water.StdControl;
  AddToRTDataStreamM.getLevel -> Water.getLevel;
}
