
/**
 * @author David Moss
 */
 
module RadioOnTimeP {
  provides {
    interface RadioOnTime;
  }
  
  uses {
    interface Counter<TMilli,uint64_t>;
    interface PowerNotifier;
  }
}

implementation {

  uint64_t timeOn;
  
  uint64_t totalRadioOnTime;
  
  /***************** RadioOnTime Commands ****************/
  /**
   * @return the total amount of time, in seconds, the radio has
   *     been turned on.
   */
  command uint32_t RadioOnTime.getTotalOnTime() {
    return (totalRadioOnTime / 1024);
  }
  
  /**
   * @return the actual duty cycle % moved over two decimal places.
   *     In other words, 16.27% duty cycle will read 1627.
   */
  command uint16_t RadioOnTime.getDutyCycle() {
    return totalRadioOnTime / (call Counter.get());
  }
  
  
  /***************** PowerNotifier Events ****************/
  event void PowerNotifier.on() {
    timeOn = call Counter.get();
  }
  
  event void PowerNotifier.off() {
    totalRadioOnTime += (call Counter.get()) - timeOn;
  }
  
  /***************** Counter Events ****************/
  async event void Counter.overflow() {
  }
  
}
