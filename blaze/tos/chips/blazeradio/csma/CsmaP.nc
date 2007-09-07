
/**
 * @author David Moss
 */
 
module CsmaP {
  provides {
    interface Send[radio_id_t id];
  }
  
  uses {
    interface AsyncSend[radio_id_t id];
  }
}

implementation {

  radio_id_t myRadio;
  
  message_t *myMsg;
  
  error_t myError;
  
  /**************** Tasks ****************/
  task void sendDone();
  
  /**************** Send Commands ****************/
  command error_t Send.send[radio_id_t id](message_t* msg, uint8_t len) {
    return call AsyncSend.send[id](msg);
  }

  command error_t Send.cancel[radio_id_t id](message_t* msg) {
    // TODO
    return FAIL;
  }

  command uint8_t Send.maxPayloadLength[radio_id_t id]() { 
    return TOSH_DATA_LENGTH;
  }

  command void* Send.getPayload[radio_id_t id](message_t* msg) {
    return NULL; // TODO
  }
  
  
  
  /***************** AsyncSend Events ****************/
  async event void AsyncSend.sendDone[radio_id_t id](message_t* msg, error_t error) {
    myMsg = msg;
    myError = error;
    myRadio = id;
    post sendDone();
  }

  
  /***************** Tasks ****************/
  task void sendDone() {
    signal Send.sendDone[myRadio](myMsg, myError);
  }
  
  /***************** Defaults ****************/
  default event void Send.sendDone[radio_id_t id](message_t* msg, error_t error) {
  }
  
}


