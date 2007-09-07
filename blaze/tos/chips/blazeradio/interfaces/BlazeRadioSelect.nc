
interface BlazeRadioSelect{

  /** Only controls which radio the current packet will be transmitted.
    * Must be called before RadioPowerControl.start() is called. Will return 
    * error if the other radio currently has control of the Transmit stack;
    */
  async command void requestCC1100();
  
  async event void grantCC1100(error_t error);
  
  /** Can only be called after RadioPowerControl.stopDone() event is received
    */ 
  async command void releaseCC1100();
  
  async event void releaseCC1100Done(error_t);
  
  async command void requestCC2500();
  
  async event void grantCC2500(error_t error);
  
  async command void releaseCC2500();
  
  async event void releaseCC2500Done(error_t);
  
}

