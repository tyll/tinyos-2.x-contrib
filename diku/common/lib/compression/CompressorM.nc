module CompressorM {
  provides {
    interface Compressor;
  }
}

implementation {

#include "../../tools/compression/buffer.c"
#include "compressor.h"

	command error_t Compressor.init()
	{
		reset_buffer();

		return SUCCESS;
	}

  command error_t Compressor.compress(uint16_t x, uint16_t y,
				       uint16_t z)
  {
    compress_sample(x, y, z, 0, 0);

    return SUCCESS;
  }

  command error_t Compressor.flush()
  {
    flush();
    return SUCCESS;
  }

  void handle_full_buffer(uint8_t *buf, uint16_t nobytes) 
  {
    signal Compressor.bufferFull(buf, nobytes);
  }
}
