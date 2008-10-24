
/**
 * @author David Moss
 */
 
module PeriodicTimerP {
  provides {
    interface Timer<TMilli>;
  }
  
  uses {
    interface Timer<TMilli> as SubTimer;
  }
}

implementation {
  
  bool stopped = FALSE;
  
  bool running = FALSE;
  
  bool oneShot = FALSE;
  
  uint32_t currentInterval = 0;
  
  
  /***************** Timer Commands ****************/
  command void Timer.startPeriodic(uint32_t dt) {
    oneShot = FALSE;
    running = TRUE;
    
    if((dt != currentInterval) || stopped) { 
      stopped = FALSE;
      currentInterval = dt;
      
      if(currentInterval > 0) {
        call SubTimer.startPeriodic(dt);
      
      } else {
        running = FALSE;
      }
    }
  }
  
  command void Timer.startOneShot(uint32_t dt) {
    oneShot = TRUE;
    running = TRUE;
    
    if(dt != currentInterval || stopped) {
      stopped = FALSE;
      currentInterval = dt;
      
      if(currentInterval > 0) {
        call SubTimer.startPeriodic(dt);
        
      } else {
        running = FALSE;
        oneShot = FALSE;
      }
    }
  }
  
  command void Timer.stop() {
    running = FALSE;
    oneShot = FALSE;
    stopped = TRUE;
  }
  
  command bool Timer.isRunning() {
    return running;
  }
  
  command bool Timer.isOneShot() {
    return call SubTimer.isOneShot();
  }
  
  command void Timer.startPeriodicAt(uint32_t t0, uint32_t dt) {
    running = TRUE;
    currentInterval = dt;
    call SubTimer.startPeriodicAt(t0, dt);
  }
  
  command void Timer.startOneShotAt(uint32_t t0, uint32_t dt) {
    running = TRUE;
    currentInterval = dt;
    call SubTimer.startOneShotAt(t0, dt);
  }
  
  command uint32_t Timer.getNow() {
    return call SubTimer.getNow();
  }
  
  command uint32_t Timer.gett0() {
    return call SubTimer.gett0();
  }
  
  command uint32_t Timer.getdt() {
    return call SubTimer.getdt();
  }
  
  /***************** SubTimer Events ****************/
  event void SubTimer.fired() {
    if(running) {
      if(oneShot) {
        oneShot = FALSE;
        running = FALSE;
      }
      
      signal Timer.fired();
    }
  }
}
