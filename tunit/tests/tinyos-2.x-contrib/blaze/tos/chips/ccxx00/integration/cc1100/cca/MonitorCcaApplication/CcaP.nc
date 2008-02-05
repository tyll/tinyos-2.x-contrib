
module CcaP {
  uses {
    interface Boot;
    interface Leds;
    interface GeneralIO as Cca;
    interface SplitControl;
  }
}

implementation {

  uint8_t blah;
  
  task void sample() {
    if(call Cca.get()) {
      call Leds.led0On();
      call Leds.led1Off();
      
    } else {
      call Leds.led0Off();
      call Leds.led1On();
    }
    
    blah++;
    if(!(blah % 100)) {
      call Leds.led2Toggle();
    }
    post sample();
  }
  
  event void Boot.booted() {
    blah = 0;
    call SplitControl.start();
  }
  
  event void SplitControl.startDone(error_t error) {
    post sample();
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
}

