
#include "message.h"

interface AsyncSend {

  async command error_t load(void *msg);
  
  async command error_t send();
  
  
  async event void loadDone(void *msg, error_t error);
  
  async event void sendDone(error_t error);
  
}

