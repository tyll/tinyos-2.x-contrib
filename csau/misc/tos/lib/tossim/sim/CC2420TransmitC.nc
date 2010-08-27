module CC2420TransmitC {

	provides {
		interface Send;
    interface CC2420Transmit;
    interface ReceiveIndicator as EnergyIndicator;
		interface ReceiveIndicator as ByteIndicator;
	}

	uses {
		interface Send as SubSend;
		interface CC2420PacketBody;
		interface ChannelAccess;
	}

} implementation {

	message_t* lastMsg = NULL;
	uint8_t lastLen;
	uint8_t ack;

	command error_t Send.send(message_t* msg, uint8_t len) {
		lastMsg = msg;
		lastLen = len;
		ack = (call CC2420PacketBody.getMetadata(lastMsg))->ack;
		dbg("LplTest", "send %hhu\n", ack);
		return call SubSend.send(msg,len);
	}
	
  command error_t Send.cancel(message_t* msg) {
		return call SubSend.cancel(msg);
	}
  
  command uint8_t Send.maxPayloadLength() {
		return call SubSend.maxPayloadLength();
	}

  command void* Send.getPayload(message_t* msg, uint8_t len) {
		return call Send.getPayload(msg,len);
	}

	event void SubSend.sendDone(message_t* msg, error_t error) {
		signal Send.sendDone(msg, error);
	}

  command error_t CC2420Transmit.resend(bool useCca) {
		if(lastMsg!=NULL) {
			(call CC2420PacketBody.getMetadata(lastMsg))->ack = ack;
			dbg("LplTest", "resend %hhu\n", (call CC2420PacketBody.getMetadata(lastMsg))->ack);
			return call SubSend.send(lastMsg, lastLen);
		} else {
			return FAIL;
		}
	}

  command bool EnergyIndicator.isReceiving() {
		return !call ChannelAccess.clearChannel();
	}

	command bool ByteIndicator.isReceiving() {
		return FALSE;
	}

}
