interface INetwork
{

  command error_t send_message(eon_message_t msg, uint16_t addr);
  event void receive(eon_message_t *msg);
   
  
}
