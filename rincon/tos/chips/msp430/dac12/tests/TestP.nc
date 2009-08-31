
module TestP {
  uses {
    interface Boot;
    interface StdControl;
    interface Leds;
    interface Msp430Dac12;
  }
}

implementation {

  uint16_t i;
  task void spin() {
    call Msp430Dac12.write(i);
    i++;
    i %= 0xFFF;
    post spin();
  }
  
  event void Boot.booted() {
    call Leds.set(0xFF);
    call StdControl.start();
    post spin();
  }
  
}
