
/** One control interface must be provided in BlazeControlP for each radio.
  *
  */
  
interface BlazeControl {
  
  /* 
   * Resets the radio, and makes sure it is in the ready state 
   * before signalling done
   */
  command error_t resetRadio();
  
  /* 
   * Wakes the radio out of deep sleep mode
   *
  command error_t radioWake();
  event void radioWakeDone(error_t error);
  

  
  /* 
   * Tracks which radio is in use
   *
  command void radioSelect();
  event void radioSelected(error_t error);
  
  /* 
   * Releases the radio
   *
  command void radioRelease();
  event void radioReleased(error_t error);
  
  /* 
   * Whether or not the radio has control
   *
  command bool isSelectedRadio();
  */
  
}


