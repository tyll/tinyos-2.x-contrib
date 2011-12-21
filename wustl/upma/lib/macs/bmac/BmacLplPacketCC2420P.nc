module BmacLplPacketCC2420P
{
	provides interface LowPowerListening;
	uses interface ChannelPoller;
	uses interface CC2420PacketBody;
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

	command void LowPowerListening.setRemoteWakeupInterval(message_t * msg, uint16_t ms)
	{
		(call CC2420PacketBody.getMetadata(msg))->rxInterval = ms;
	}

	command uint16_t LowPowerListening.getRemoteWakeupInterval(message_t * msg)
	{
		return (call CC2420PacketBody.getMetadata(msg))->rxInterval;
	}
	
	async event void ChannelPoller.activityDetected(bool dummy) { }
}
