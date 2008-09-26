module EonDTNM
{
  provides
  {
    interface Init;
    interface StdControl;
	
    interface INetwork;
	interface INetworkEnergy;
  }
  uses
  {
  	interface Packet;
	interface AMPacket;
	interface AMSend;
	interface Receive;
	interface SplitControl as AMControl;
  }
}
implementation
{
	bool busy = FALSE;
	message_t pkt;

  command error_t Init.init ()
  {
    return SUCCESS;
  }

  command error_t StdControl.start ()
  {
    return SUCCESS;
  }

  command error_t StdControl.stop ()
  {
    return SUCCESS;
  }


  command error_t INetwork.send_message(eon_message_t msg, uint16_t addr)
  {
  	if (!busy) 
	{
    		DataMsg_t * datapkt = (DataMsg_t*)(call Packet.getPayload(&pkt, sizeof(DataMsg_t)));
    		datapkt->src_addr = TOS_NODE_ID;
    		datapkt->sequence = 0;
    		if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(DataMsg_t)) == SUCCESS) 
		{
      			busy = TRUE;
		}
    	}
  	return SUCCESS;
  }
  
  command error_t INetworkEnergy.tune(int level)
  {
  	return SUCCESS;
  }
  
  event void AMSend.sendDone(message_t* msg, error_t error) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }
  
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) 
  {
  	if (len == sizeof(DataMsg_t)) 
	{
    		//do something in response
	}
  	return msg;
  }
  
  event void AMControl.startDone(error_t err) {
    if (err != SUCCESS) 
    {  
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) 
  {
  }

}
