module LBlinkM
{
  provides {
    interface LBlink;
    interface StdControl;
    interface Init;
  }
  uses {
    interface Leds;
    interface Timer<TMilli>;
    //interface StdControl as TimerControl;
  }
}

implementation {
  uint16_t rate;
  uint8_t yellow;
  uint8_t red;
  uint8_t green;
  bool timer_on;
  bool initialized = FALSE;

  command error_t LBlink.setRate(uint16_t r)
  {
    dbg("BVR-boot","LBlinkM$setRate: interval %d\n",r); 
    rate = r; 
    return SUCCESS;
  }   
   
  command error_t Init.init() {
    //call TimerControl.init();
    
    rate = 0;
    timer_on = FALSE;
    yellow = red = green = 0;
    
    initialized = TRUE;
    
    return SUCCESS;
  } 

  command error_t StdControl.start() {
    if (!initialized) {
      //call TimerControl.init();
      
      rate = 0;
      timer_on = FALSE;
      yellow = red = green = 0;
      initialized = TRUE;			  
    }	    
    //call TimerControl.start();
    return SUCCESS;
  } 
  command error_t StdControl.stop() {
    //call TimerControl.stop();
    return SUCCESS;
  } 

  command error_t LBlink.yellowBlink(uint8_t times)
  {
    dbg("BVR-debug","LBLinkM$yellowBlink %d times\n",times);
    yellow += times<<1;
    if (!timer_on) {
      timer_on = TRUE;
      call Timer.startPeriodic(rate);
    }
    return SUCCESS;
  }   
  command error_t LBlink.redBlink(uint8_t times)
  {
    dbg("BVR-debug","LBLinkM$redBlink %d times\n",times);
    red += times<<1;
    if (!timer_on) {
      timer_on = TRUE;
      call Timer.startPeriodic(rate);
    }
    return SUCCESS;
  }   
  command error_t LBlink.greenBlink(uint8_t times)
  {
    dbg("BVR-debug","LBLinkM$greenBlink %d times\n",times);
    green += times<<1;
    if (!timer_on) {
      timer_on = TRUE;
      call Timer.startPeriodic(rate);
    }
    return SUCCESS;
  }   
  event void Timer.fired() {
    if (yellow > 0) {
      call Leds.led2Toggle();
      yellow--;
    }
    if (red > 0) {
      call Leds.led0Toggle();
      red--;
    }
    if (green > 0) {
      call Leds.led1Toggle();
      green--;
    }
    if (yellow + green + red == 0) {
      timer_on = FALSE;
      call Timer.stop();
    }
    return ;
  }
}
