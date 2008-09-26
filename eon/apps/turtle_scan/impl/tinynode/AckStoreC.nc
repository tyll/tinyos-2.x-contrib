configuration AckStoreC
{
  provides
  {
    interface AckStore;
  }
}
implementation
{
  components Main, AckStoreM, NoLeds as Leds, TimerC; 
 #ifdef ACK_DEBUG
  components ConsoleC as Console, HPLUARTC;
#endif
  Main.StdControl -> TimerC;
  Main.StdControl -> AckStoreM.StdControl;
  
  
  AckStore = AckStoreM.AckStore;
  AckStoreM.Leds -> Leds;
  AckStoreM.Timer -> TimerC.Timer[unique("Timer")];
#ifdef ACK_DEBUG
  AckStoreM.Console -> Console;
  Console.HPLUART -> HPLUARTC;
#endif
}
