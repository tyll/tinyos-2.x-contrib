module TestLppBasestationP
{
  uses {
    interface Boot;
    interface Leds;
    interface SplitControl as RadioSplitControl;
    interface KeepAlive;
  }
}

implementation
{
  event void Boot.booted()
  {
    call RadioSplitControl.start();
  }

  event void RadioSplitControl.startDone(error_t error)
  {
    call Leds.led0On();
    call KeepAlive.startBroadcast(1024);
  }

  event void RadioSplitControl.stopDone(error_t error) { }
  event void KeepAlive.timeout() { }
}
