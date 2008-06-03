interface MTS400Sensor
{
	event void dataReady(uint8_t *buf, uint16_t length);
}
