
#include "message.h"

interface AsyncSend {

  async command error_t send(message_t* msg);
  
  async event void sendDone(message_t* msg, error_t error);
}

