/* interface to start data gathering in SenZip */
interface StartGathering {
    
  command bool isStarted();
  
  command void getStarted(uint8_t type);  
  
  event void startDone();
  
}
