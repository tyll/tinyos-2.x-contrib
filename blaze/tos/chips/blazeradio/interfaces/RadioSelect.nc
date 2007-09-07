
interface RadioSelect{

  /** Only controls which radio the current packet will be transmitted.
    * Calls the split control functions on the radio, turning them on and off
    */
  command error_t requestCC1100();
  
  event void grantCC1100(error_t error);
  
  command error_t releaseCC1100();
  
  event void releaseCC1100Done(error_t error);
  
  command error_t requestCC2500();
  
  event void grantCC2500(error_t error);
  
  command error_t releaseCC2500();
  
  event void releaseCC2500Done(error_t error);
  
}

