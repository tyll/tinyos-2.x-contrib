interface IIC
{
	command void init();
	command void start();
	command void stop();
	command void writeByte(uint8_t val);
	command uint8_t readByte();
	command error_t receiveACK();
	command error_t receiveNACK();
	command void sendACK();
	command void sendNACK();
	command error_t inUse();
}
