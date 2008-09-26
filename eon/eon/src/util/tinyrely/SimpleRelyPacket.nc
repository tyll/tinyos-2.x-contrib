
configuration SimpleRelyPacket
{
  provides {
    interface StdControl as Control;
    interface RelySendMsg as Send;
    interface RelyReceiveMsg as Receive;
  }
}
implementation
{
  components UARTNoCRCPacket as Packet;

  command result_t StdControl.init() {
    result_t ok1;
		ok1 = call Packet.init()
		return ok1
  }

  command result_t StdControl.start() {
    
  }

  command result_t StdControl.stop() {
    
  }

  
}
