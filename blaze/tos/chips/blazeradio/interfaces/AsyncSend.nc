
#include "message.h"

interface AsyncSend {

  async command error_t send(void *msg);
  
  async event void sendDone(void *msg, error_t error);
}

