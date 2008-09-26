includes TinyRely;
includes TinyStream;

interface StreamWrite
{
  /*
    returns FAIL if the connection is invalid or has timed out.  bytes
    written holds the actual number of bytes that were written, and
    may be zero if the buffer is full.
  */
  command result_t write(uint8_t connid,
			 uint8_t *buffer, 
			 uint16_t size, 
			 uint16_t *byteswritten);

}
