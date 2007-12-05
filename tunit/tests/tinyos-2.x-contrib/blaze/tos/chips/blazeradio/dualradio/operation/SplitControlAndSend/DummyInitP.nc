

module DummyInitP {
  provides {
    interface BlazeCommit as BlazeCommitCapture[ radio_id_t id ];
    interface BlazePower as BlazePowerCapture[ radio_id_t id ];
  }
}

implementation {

  /****************** BlazeCommit ****************/
  command error_t BlazeCommitCapture.commit[radio_id_t radio]() {
    return SUCCESS;
  }
  
  /****************** BlazePowerCapture ****************/
  async command error_t BlazePowerCapture.reset[radio_id_t radio]() {
    return SUCCESS;
  }

  async command error_t BlazePowerCapture.deepSleep[radio_id_t radio]() {
    return SUCCESS;
  }
  
  async command void BlazePowerCapture.shutdown[radio_id_t radio]() {
  }

  async command bool BlazePowerCapture.isOn[radio_id_t radio]() {
    return TRUE;
  }
  
}
