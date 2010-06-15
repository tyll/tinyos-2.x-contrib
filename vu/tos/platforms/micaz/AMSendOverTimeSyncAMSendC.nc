module AMSendOverTimeSyncAMSendC {
	provides interface AMSend[am_id_t id];
	uses interface TimeSyncAMSend<TRadio, uint32_t> as SubTimeSyncAMSend[am_id_t id];
}
implementation
{
	command error_t AMSend.send[am_id_t id](am_addr_t addr, message_t* msg, uint8_t len)
	{
		return call SubTimeSyncAMSend.send[id](addr, msg, len, 0);
	}

	command error_t AMSend.cancel[am_id_t id](message_t* msg)
	{
		return call SubTimeSyncAMSend.cancel[id](msg);
	}

	default event void AMSend.sendDone[am_id_t id](message_t* msg, error_t error)
	{
	}

	command uint8_t AMSend.maxPayloadLength[am_id_t id]()
	{
		return call SubTimeSyncAMSend.maxPayloadLength[id]();
	}

	command void* AMSend.getPayload[am_id_t id](message_t* msg, uint8_t len)
	{
		return call SubTimeSyncAMSend.getPayload[id](msg, len);
	}
 
	event void SubTimeSyncAMSend.sendDone[am_id_t id](message_t* msg, error_t error) {
		signal AMSend.sendDone[id](msg, error);
	}
}

