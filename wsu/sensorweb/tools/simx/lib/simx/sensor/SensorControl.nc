
interface SensorControl {

	command error_t bindPort(uint8_t port, uint8_t adcPort);
	command int getInterrupt(uint8_t client);
}
