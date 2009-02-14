module MySerialWriterP {
    provides interface PortWriter;
    uses {
        interface SendBytePacket;
        interface TaskQuanto as SignalSendDoneTask;
        interface SingleContext as CPUContext;
    }
}

implementation {

  typedef enum {
    SEND_STATE_IDLE = 0,
    SEND_STATE_BEGIN = 1,
    SEND_STATE_DATA = 2
  } send_state_t;

  uint8_t *sendBuffer = NULL;
  send_state_t sendState = SEND_STATE_IDLE;
  uint8_t sendLen = 0;
  uint8_t sendIndex = 0;
  norace error_t sendError = SUCCESS;
 
  async command error_t PortWriter.write(uint8_t* buf, uint16_t len) {
    uint8_t b;
    atomic {
        if (sendState != SEND_STATE_IDLE) {
         return EBUSY;
        }
    }
    atomic {
      
      sendError = SUCCESS;
      sendBuffer = (uint8_t*)buf;
      sendState = SEND_STATE_DATA;
      // If something we're starting past the header, something is wrong
      // Bug fix from John Regehr


      sendLen = len;
      b = sendBuffer[0];
      sendIndex = 1; //we send the first byte here
    }
    if (call SendBytePacket.startSend(b) == SUCCESS) {
      return SUCCESS;
    }
    else {
      atomic sendState = SEND_STATE_IDLE;
      return FAIL;
    }
  }

  event void SignalSendDoneTask.runTask(){
    error_t error;
    uint8_t* b;

    atomic {
        sendState = SEND_STATE_IDLE;
        error = sendError;
        b = sendBuffer;
    }

    signal PortWriter.writeDone(b, error);
  }

  async event uint8_t SendBytePacket.nextByte() {
    uint8_t b;
    uint8_t indx;
    atomic {
      b = sendBuffer[sendIndex];
      sendIndex++;
      indx = sendIndex;
    }
    if (indx > sendLen) {
      call SendBytePacket.completeSend();
      return 0;
    }
    else {
      return b;
    }
  }

  async event void SendBytePacket.sendCompleted(error_t error){
    atomic sendError = error;
    call SignalSendDoneTask.postTask(call CPUContext.get());
  }

  default event void PortWriter.writeDone(uint8_t *buf, error_t result){
    return;
  }



}
