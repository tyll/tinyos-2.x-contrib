interface PacketStats {
	command uint16_t getBroadcast();
	command uint16_t getUnicast();
	command uint16_t getUnicastAck();
	command uint16_t getSyncUnicast();
	command uint16_t getSyncUnicastAck();
}
