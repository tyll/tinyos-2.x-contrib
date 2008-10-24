
/**
 * This component keeps a timer firing periodically and indefinitely. 
 * Its starting point never changes unless you change the period.
 * 
 * The point here is that we can keep our radios consistently turning on at
 * approximately the same time to support synchronous low power communiciations
 * on top of the asynchronous implementations. One shot timer fires will fire
 * on the next periodic event from whenever the timer was originally started.
 * 
 * You can restart the timer by giving it a new interval, or stop it and
 * start it again.
 * 
 * @author David Moss.
 */

configuration PeriodicTimerC {
  provides {
    interface Timer<TMilli>;
  }
}

implementation {
  
  components PeriodicTimerP,
      new TimerMilliC();
      
  Timer = PeriodicTimerP;
  
  PeriodicTimerP.SubTimer -> TimerMilliC;
  
}

