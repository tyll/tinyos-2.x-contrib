
#include "priority.h"

interface AmRegistry{

  event priority_t configure(message_t* msg);
  
  //command void configureDone(message_t msg);

}