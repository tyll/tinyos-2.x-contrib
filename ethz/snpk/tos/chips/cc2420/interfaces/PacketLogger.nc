interface PacketLogger {
	event void received(message_t* msg);
	event void sendDone(message_t* msg, error_t error);
}
