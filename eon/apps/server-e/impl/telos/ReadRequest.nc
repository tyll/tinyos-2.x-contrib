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
  components ReadRequestM, LedsC as Leds, TimerC;

  StdControl = ReadRequestM.StdControl;
  IReadRequest = ReadRequestM.IReadRequest;
  ReadRequestM.Leds -> Leds;
}
