
interface RadioPowerControl{

  async command void start();
  
  async event void startDone( error_t error );
  
  async command void stop();
  
  async event void stopDone( error_t error );
}


