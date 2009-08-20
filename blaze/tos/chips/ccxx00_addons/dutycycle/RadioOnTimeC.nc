
/**
 * @author David Moss
 */
 
configuration RadioOnTimeC {
  provides {
    interface RadioOnTime;
  }
}

implementation {

  components RadioOnTimeP;
  RadioOnTime = RadioOnTimeP;
  
  components BlazeInitC;
  RadioOnTimeP.PowerNotifier -> BlazeInitC;
  
  components Counter64bitMilliC;
  RadioOnTimeP.Counter -> Counter64bitMilliC;
  
}
