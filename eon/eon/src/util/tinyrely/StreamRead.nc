
includes TinyRely;
includes TinyStream;

interface StreamRead
{
  command result_t read(uint8_t connid,
			uint8_t *buffer, 
			uint16_t size, 
			uint16_t *bytesread);

}
