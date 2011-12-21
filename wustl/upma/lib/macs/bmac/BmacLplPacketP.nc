module BmacLplPacketP
{
	provides interface LowPowerListening;
	provides interface AsyncSend as Send;
	
	uses interface ChannelPoller;
	uses interface AsyncSend as SubSend;
	uses interface Packet;
}
implementation
{
	command void LowPowerListening.setLocalWakeupInterval(uint16_t ms)
	{
		call ChannelPoller.setWakeupInterval(ms);
	}
	
	command uint16_t LowPowerListening.getLocalWakeupInterval()
	{
		return call ChannelPoller.getWakeupInterval();
	}
	
	void * getFooter(message_t * msg)
	{
		return (uint8_t *)call Packet.getPayload(msg, 0) + call Send.maxPayloadLength();
	}
	
	command void LowPowerListening.setRemoteWakeupInterval(message_t * msg, uint16_t ms)
	{
		uint16_t * footer = getFooter(msg);
		*footer = ms;
	}

	command uint16_t LowPowerListening.getRemoteWakeupInterval(message_t * msg)
	{
		uint16_t * footer = getFooter(msg);
		return *footer;
	}
	
	async command error_t Send.send(message_t * msg, uint8_t len)
	{
		return call SubSend.send(msg, len);
	}
	
	async command error_t Send.cancel(message_t * msg)
	{
		return call SubSend.cancel(msg);
	}
	
	async command void * Send.getPayload(message_t * msg, uint8_t len)
	{
		return call SubSend.getPayload(msg, len);
	}
	
	async command uint8_t Send.maxPayloadLength()
	{
		return call SubSend.maxPayloadLength() - sizeof(uint16_t);
	}
	
	async event void SubSend.sendDone(message_t * msg, error_t error)
	{
		signal Send.sendDone(msg, error);
	}
	
	async event void ChannelPoller.activityDetected(bool dummy) { }		
}
