module CC2420ReceiveC {
	
	provides {
		interface Receive;
		interface ReceiveIndicator as PacketIndicator;
	}

	uses {
		interface Receive as SubReceive;
	}

} implementation {

	event message_t* SubReceive.receive(message_t* msg, void* payload, uint8_t len) {
		return signal Receive.receive(msg, payload, len);
	}

	command bool PacketIndicator.isReceiving() {
		return FALSE;
	}
	

}
