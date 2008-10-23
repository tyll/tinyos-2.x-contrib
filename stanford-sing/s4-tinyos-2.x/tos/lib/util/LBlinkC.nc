configuration LBlinkC 
{
  provides interface LBlink;
  provides interface StdControl;
}

implementation {
  components LBlinkM
#ifdef LBLINK_ON
             , LedsC as Leds
#else
             , NoLedsC as Leds
#endif
             , new TimerMilliC()
             ;

  LBlink = LBlinkM;
  StdControl = LBlinkM;

  LBlinkM.Leds -> Leds;
  LBlinkM.Timer -> TimerMilliC;
  
}
